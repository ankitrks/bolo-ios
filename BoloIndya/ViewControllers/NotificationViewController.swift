//
//  NotificationViewController.swift
//  BoloIndya
//
//  Created by apple on 7/10/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Alamofire

class NotificationViewController: UIViewController {

    @IBOutlet weak var notificationView: UITableView!

    var next_offset = "0"

    var notifications: [Notification] = []
    
    var isLoading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Notification")
        // Do any additional setup after loading the view.
        let isLoggedIn = UserDefaults.standard.isLoggedIn() ?? false
        if (!isLoggedIn) {
            goToLoginPage()
        } else {
            setNotificationViewDelegate()
            fetchNotifications()
        }
    }
    
    func goToLoginPage() {
       let vc = storyboard?.instantiateViewController(withIdentifier: "LoginAndSignUpViewController") as! LoginAndSignUpViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }

    func fetchNotifications() {
        
        if (next_offset.isEmpty) {
            return
        }
        
        isLoading = true
        
        let parameters: [String: Any] = [
            "limit": "20",
            "offset": next_offset
        ]
        
        let headers: [String: Any] = [
            "Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        
        Alamofire.request("https://www.boloindya.com/api/v1/notification/get", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers as? HTTPHeaders)
            .responseString  { (responseData) in
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                    
                    do {
                        
                        let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                    
                        if let next_offset = json_object?["next_offset"] as? Int {
                            self.next_offset = "\(next_offset)"
                        } else {
                            self.next_offset = ""
                        }
                        
                        if let content = json_object?["notification_data"] as? [[String:Any]] {
                            for each in content {
                                let notification = Notification(id: each["id"] as! Int, title: each["title"] as! String, read_status: each["read_status"] as! Int, notification_type: each["notification_type"] as! String, actor_profile_pic: each["actor_profile_pic"] as! String, created_at: each["created_at"] as! String)
                                self.notifications.append(notification)
                            }
                            self.notificationView.reloadData()
                        }
                        self.isLoading = false
                    }
                    catch {
                        self.isLoading = false
                        print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    self.isLoading = false
                    print(error)
                }
        }
    }
    
    func setNotificationViewDelegate() {
        notificationView.delegate = self
        notificationView.dataSource = self
    }
}

extension NotificationViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let notification_cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        notification_cell.configure(with: notifications[indexPath.row])
        return notification_cell 
    }
 
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        
        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
            fetchNotifications()
        }
        
    }
}
