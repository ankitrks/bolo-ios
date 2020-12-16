//
//  NotificationViewController.swift
//  BoloIndya
//
//  Created by apple on 7/10/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Alamofire

class NotificationViewController: BaseVC {

    var notificationView = UITableView()
    var loader = UIActivityIndicatorView()

    var next_offset = "0"

    var notifications: [Notification] = []
    var selected_position: Int = 0
    var isLoading: Bool = false
    var video_id = ""
    
    var retry = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Notification")
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
        if  isLogin(){
            view.addSubview(loader)
            
            loader.center = self.view.center
            
            loader.color = UIColor.white
            
            setNotificationViewDelegate()
            fetchNotifications()
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       self.navigationController?.isNavigationBarHidden = true
       self.tabBarController?.tabBar.isHidden = false
    }
       
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func goToLoginPage() {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        performSegue(withIdentifier: "notificationLogin", sender: self)
    }

    func fetchNotifications() {
        
        if (next_offset.isEmpty) {
            return
        }
        
        if (next_offset == "0") {
            loader.isHidden = false
            loader.startAnimating()
            notificationView.isHidden = true
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
                                let notification = Notification(id: each["id"] as! Int, title: each["title"] as! String, read_status: each["read_status"] as! Int, notification_type: each["notification_type"] as! String, actor_profile_pic: each["actor_profile_pic"] as! String, created_at: each["created_at"] as! String, instance_id: each["instance_id"] as! Int)
                                if let id = each["topic_id"] as? Int {
                                    notification.topic_id = "\(id)"
                                }
                                self.notifications.append(notification)
                            }
                            self.notificationView.reloadData()
                        }

                        self.loader.isHidden = true
                        self.loader.stopAnimating()
                        self.notificationView.isHidden = false
                        self.isLoading = false
                    }
                    catch {
                        self.isLoading = false
                        if self.next_offset == "0" {
                           self.retry.isHidden = false
                           self.notificationView.isHidden = true
                       }
                        self.loader.isHidden = true
                        self.loader.stopAnimating()
                        print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    self.isLoading = false
                    if self.next_offset == "0" {
                        self.retry.isHidden = false
                        self.notificationView.isHidden = true
                    }
                    self.loader.isHidden = true
                    self.loader.stopAnimating()
                    print(error)
                }
        }
    }
    
    func setNotificationViewDelegate() {
        notificationView.delegate = self
        notificationView.dataSource = self
        notificationView.backgroundColor = .black
        notificationView.register(NotificationCell.self, forCellReuseIdentifier: "NotificationCell")
        
        view.addSubview(notificationView)
        
        notificationView.translatesAutoresizingMaskIntoConstraints = false
        notificationView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: getStatusBarHeight()).isActive = true
        notificationView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        notificationView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        notificationView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -(self.tabBarController?.tabBar.frame.size.height ?? 49.0)).isActive = true
        
        view.addSubview(retry)
        
        let screenSize = UIScreen.main.bounds.size
        
        retry.translatesAutoresizingMaskIntoConstraints = false
        retry.heightAnchor.constraint(equalToConstant: 30).isActive = true
        retry.widthAnchor.constraint(equalToConstant: 150).isActive = true
        retry.topAnchor.constraint(equalTo: self.view.topAnchor, constant: (screenSize.height/2)).isActive = true
        retry.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: (screenSize.width/2)-65).isActive = true
        
        retry.setTitle("Retry", for: .normal)
        retry.setTitleColor(UIColor(hex: "10A5F9"), for: .normal)
        retry.layer.borderWidth = 1
        retry.layer.borderColor = UIColor(hex: "10A5F9")?.cgColor
        retry.layer.cornerRadius = 5.0
        
        retry.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        retry.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12.0)
        retry.isHidden = true
    }
    
    @objc func refresh() {
         self.retry.isHidden = true
        fetchNotifications()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.destination is ProfileViewController {
            let vc = segue.destination as? ProfileViewController
            let user = User()
            user.id = notifications[selected_position].instance_id
            vc?.user = user
       } else  if segue.destination is VideoViewController {
            let vc = segue.destination as? VideoViewController
        vc?.topic_id = self.video_id
       }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selected_position = indexPath.row
        switch notifications[indexPath.row].notification_type {
            case "4":
                self.tabBarController?.tabBar.isHidden = true
                performSegue(withIdentifier: "ProfileNotification", sender: self)
            case "7":
                self.tabBarController?.selectedIndex = 0
                break
            case "2":
                self.video_id = notifications[indexPath.row].topic_id
                self.tabBarController?.tabBar.isHidden = true
                performSegue(withIdentifier: "VideoNotification", sender: self)
                break
            case "3":
                self.video_id = notifications[indexPath.row].topic_id
                self.tabBarController?.tabBar.isHidden = true
                performSegue(withIdentifier: "VideoNotification", sender: self)
                break
            case "10":
                self.video_id = notifications[indexPath.row].topic_id
                self.tabBarController?.tabBar.isHidden = true
                performSegue(withIdentifier: "VideoNotification", sender: self)
                break
            default:
                self.video_id = "\(notifications[indexPath.row].instance_id)"
                self.tabBarController?.tabBar.isHidden = true
                performSegue(withIdentifier: "VideoNotification", sender: self)
            
        }
        if (notifications[indexPath.row].notification_type == "7") {
            
        } else if (notifications[indexPath.row].notification_type == "4") {
            
        } else {
           
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

