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
import AVFoundation

class TrendingAndFollowingViewController: UIViewController {
    
    var trendingView = UITableView()
    
    var videos: [Topic] = []
    var page: Int = 1
    var isLoading: Bool = false
    var selected_position = 0
    
    var current_video_cell: VideoCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Trending")
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
        fetchData()
        setTrendingViewDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
        if current_video_cell != nil {
            current_video_cell.player.player?.play()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if current_video_cell != nil {
            current_video_cell.player.player?.pause()
        }
        self.navigationController?.isNavigationBarHidden = false
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
                                print(each)
                                let user = User()
                                let user_obj = each["user"] as? [String:Any]
                                let user_profile_obj = user_obj?["userprofile"] as? [String:Any]
                                user.setId(id: (user_obj?["id"] as? Int ?? 0))
                                user.setUserName(username: user_obj?["username"] as? String ?? "")
                                
                                user.setName(name: user_profile_obj?["name"] as? String ?? "")
                                user.setBio(bio: user_profile_obj?["bio"] as? String ?? "")
                                user.setCoverPic(cover_pic: user_profile_obj?["cover_pic"] as? String ?? "")
                                user.setProfilePic(profile_pic: user_profile_obj?["profile_pic"] as? String ?? "")
                                
                                let topic = Topic(user: user)
                                topic.setTitle(title: each["title"] as? String ?? "")
                                topic.setThumbnail(thumbail: each["question_image"] as? String ?? "")
                                
                                topic.video_url = each["question_video"] as? String ?? ""
                                
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ProfileViewController {
            let vc = segue.destination as? ProfileViewController
            vc?.user = videos[selected_position].user
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

        let video_cell = cell as! VideoCell
        if current_video_cell != nil {
            current_video_cell.player.player?.pause()
        }
        
        current_video_cell = video_cell
        
        let videoUrl = NSURL(string: videos[indexPath.row].video_url)
        let avPlayer = AVPlayer(url: videoUrl! as URL)

        video_cell.player.playerLayer.player = avPlayer
        video_cell.player.player?.play()

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected_position = indexPath.row
        self.performSegue(withIdentifier: "ProfileView", sender: self)
        self.tabBarController?.tabBar.isHidden = true
    }
}
