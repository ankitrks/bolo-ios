//
//  TrendingAndFollowingViewController.swift
//  BoloIndya
//
//  Created by apple on 7/10/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class TrendingAndFollowingViewController: UIViewController {
    
    var trendingView = UITableView()
    
    var videos: [Topic] = []
    var page: Int = 1
    var isLoading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Trending")
        fetchData()
        setTrendingViewDelegate()
    }
    
    func setTrendingViewDelegate() {
        trendingView.isScrollEnabled = true
        trendingView.isPagingEnabled = true
        trendingView.delegate = self
        trendingView.dataSource = self
        trendingView.register(VideoCell.self, forCellReuseIdentifier: "Cell")
    
        view.addSubview(trendingView)
        
        let screenSize = UIScreen.main.bounds.size
        
        self.trendingView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height-(self.tabBarController?.tabBar.frame.size.height ?? 49.0))
    }
    
    @IBAction func goToNextScreens(_ sender: UIButton) {
        let isLoggedIn = UserDefaults.standard.isLoggedIn() ?? false

        if (!isLoggedIn) {
            goToLoginPage()
        }
    }

    func goToLoginPage() {
       let vc = storyboard?.instantiateViewController(withIdentifier: "LoginAndSignUpViewController") as! LoginAndSignUpViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
    
    func fetchData() {

        if isLoading {
            return
        }
        
        isLoading = true
        
        let headers: [String: Any] = [
            "Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        
        let url = "https://www.boloindya.com/api/v1/get_popular_video_bytes/?language_id=\(UserDefaults.standard.getValueForLanguageId().unsafelyUnwrapped)&page=\(page)&uid=\(UserDefaults.standard.getUserId().unsafelyUnwrapped)"
        
        print(url)
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers as? HTTPHeaders)
            .responseString  { (responseData) in
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                    
                    do {
                        let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                        if let content = json_object?["topics"] as? [[String:Any]] {
                            for each in content {
                                let user = User()
                                let user_obj = each["user"] as? [String:Any]
                                
                                user.setUserName(username: user_obj?["username"] as? String ?? "")
                                let topic = Topic(user: user)
                                topic.setTitle(title: each["title"] as? String ?? "")
                                topic.setThumbnail(thumbail: each["question_image"] as? String ?? "")
                                self.videos.append(topic)
                            }
                            self.isLoading = false
                            self.page += 1
                            self.trendingView.reloadData()
                        }
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
}

extension TrendingAndFollowingViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let video_cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! VideoCell
        video_cell.title.text = videos[indexPath.row].title.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        let url = URL(string: videos[indexPath.row].thumbnail)
        video_cell.video_image.kf.setImage(with: url)
        video_cell.username.text = "@"+videos[indexPath.row].user.username
        return video_cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        
        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
            self.fetchData()
        }
        
    }
}
