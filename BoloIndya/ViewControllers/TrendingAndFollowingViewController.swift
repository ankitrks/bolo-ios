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
    var comments: [Comment] = []
    var trendingTopics: [Topic] = []
    var followingTopics: [Topic] = []
    var page: Int = 1
    var following_page: Int = 1
    var isLoading: Bool = false
    var isTrending: Bool = true
    var selected_position = 0
    var label = UILabel()
    var trending = UILabel()
    var following = UILabel()
    var progress = UIActivityIndicatorView()
    var transparentView = UIView()
    var commentView = UITableView()
    var comment_tab = UIView()
    var profile_pic = UIImageView()
    var comment_title = UITextField()
    var submit_comment = UIImageView()
    var go_back =  UIImageView()
    var progress_comment = UIActivityIndicatorView()
    var comment_label = UILabel()
    var video_url: URL!
    var comment_page = 0
    var topic_liked: [Int] = []
    
    var current_video_cell: VideoCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Trending")
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
        topic_liked = UserDefaults.standard.getLikeTopic()
        
        fetcUserDetails()
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
    }
    
    func setTrendingViewDelegate() {
        trendingView.isScrollEnabled = true
        trendingView.isPagingEnabled = true
        trendingView.delegate = self
        trendingView.dataSource = self
        trendingView.register(VideoCell.self, forCellReuseIdentifier: "Cell")
        
        commentView.isScrollEnabled = true
        commentView.delegate = self
        commentView.dataSource = self
        commentView.backgroundColor = .black
        commentView.register(CommentViewCell.self, forCellReuseIdentifier: "Cell")
    
        comment_tab.addSubview(profile_pic)
        comment_tab.addSubview(submit_comment)
        comment_tab.addSubview(comment_title)
        comment_tab.addSubview(commentView)
        comment_tab.addSubview(progress_comment)
        comment_tab.addSubview(comment_label)
        comment_tab.addSubview(go_back)
        
        view.addSubview(trendingView)
        view.addSubview(trending)
        view.addSubview(following)
        view.addSubview(label)
        view.addSubview(progress)
        view.addSubview(comment_tab)
        
        
        comment_tab.translatesAutoresizingMaskIntoConstraints = false
        comment_tab.heightAnchor.constraint(equalToConstant: 400).isActive = true
        comment_tab.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        comment_tab.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        comment_tab.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -(self.tabBarController?.tabBar.frame.size.height ?? 49.0)).isActive = true
        comment_tab.backgroundColor = .black
        
        go_back.translatesAutoresizingMaskIntoConstraints = false
        go_back.widthAnchor.constraint(equalToConstant: 30).isActive = true
        go_back.heightAnchor.constraint(equalToConstant: 30).isActive = true
        go_back.rightAnchor.constraint(equalTo: comment_tab.rightAnchor, constant: -5).isActive = true
        go_back.topAnchor.constraint(equalTo: comment_tab.topAnchor, constant: 5).isActive = true

        go_back.image = UIImage(named: "close")
        go_back.tintColor = UIColor.white

        go_back.isUserInteractionEnabled = true

        let tapGestureBack = UITapGestureRecognizer(target: self, action: #selector(onClickTransparentView(_:)))
        go_back.addGestureRecognizer(tapGestureBack)
        
        progress_comment.translatesAutoresizingMaskIntoConstraints = false
        progress_comment.heightAnchor.constraint(equalToConstant: 60).isActive = true
        progress_comment.widthAnchor.constraint(equalToConstant: 60).isActive = true
        progress_comment.centerYAnchor.constraint(equalTo: comment_tab.centerYAnchor, constant: 0).isActive = true
        progress_comment.centerXAnchor.constraint(equalTo: comment_tab.centerXAnchor, constant: 0).isActive = true
        progress_comment.color = UIColor.white
        
        profile_pic.translatesAutoresizingMaskIntoConstraints = false
        profile_pic.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profile_pic.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profile_pic.leftAnchor.constraint(equalTo: comment_tab.leftAnchor, constant: 10).isActive = true
        profile_pic.bottomAnchor.constraint(equalTo: comment_tab.bottomAnchor, constant: -10).isActive = true
        profile_pic.layer.cornerRadius = 20
        profile_pic.contentMode = .scaleAspectFill
        profile_pic.clipsToBounds = true
        
        comment_title.translatesAutoresizingMaskIntoConstraints = false
        comment_title.heightAnchor.constraint(equalToConstant: 30).isActive = true
        comment_title.leftAnchor.constraint(equalTo: profile_pic.rightAnchor, constant: 5).isActive = true
        comment_title.rightAnchor.constraint(equalTo: submit_comment.leftAnchor, constant: -5).isActive = true
        comment_title.bottomAnchor.constraint(equalTo: comment_tab.bottomAnchor, constant: -10).isActive = true
        
        comment_title.placeholder = "Add a comment"
        comment_title.attributedPlaceholder = NSAttributedString(string: "Add a comment", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        submit_comment.translatesAutoresizingMaskIntoConstraints = false
        submit_comment.heightAnchor.constraint(equalToConstant: 30).isActive = true
        submit_comment.widthAnchor.constraint(equalToConstant: 30).isActive = true
        submit_comment.rightAnchor.constraint(equalTo: comment_tab.rightAnchor, constant: -10).isActive = true
        submit_comment.bottomAnchor.constraint(equalTo: comment_tab.bottomAnchor, constant: -10).isActive = true
        submit_comment.contentMode = .scaleAspectFill
        submit_comment.clipsToBounds = true
        
        if (!(UserDefaults.standard.getProfilePic() ?? "").isEmpty) {
            let url = URL(string: UserDefaults.standard.getProfilePic() ?? "")
            profile_pic.kf.setImage(with: url, placeholder: UIImage(named: "user"))
        } else {
            profile_pic.image = UIImage(named: "user")
        }
        
        submit_comment.image = UIImage(named: "submit")
        
        comment_label.translatesAutoresizingMaskIntoConstraints = false
        comment_label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        comment_label.leftAnchor.constraint(equalTo: comment_tab.leftAnchor, constant: 10).isActive = true
        comment_label.rightAnchor.constraint(equalTo: comment_tab.rightAnchor, constant: 0).isActive = true
        comment_label.bottomAnchor.constraint(equalTo: commentView.topAnchor, constant: -5).isActive = true
        comment_label.textColor = UIColor.white
        comment_label.text = "Comments"
    
        commentView.translatesAutoresizingMaskIntoConstraints = false
        commentView.heightAnchor.constraint(equalToConstant: 310).isActive = true
        commentView.leftAnchor.constraint(equalTo: comment_tab.leftAnchor, constant: 0).isActive = true
        commentView.rightAnchor.constraint(equalTo: comment_tab.rightAnchor, constant: 0).isActive = true
        commentView.bottomAnchor.constraint(equalTo: profile_pic.topAnchor, constant: -5).isActive = true
        commentView.separatorStyle = .none
        
        comment_tab.isHidden = true
        
        trending.translatesAutoresizingMaskIntoConstraints = false
        trending.widthAnchor.constraint(equalToConstant: 100).isActive = true
        trending.heightAnchor.constraint(equalToConstant: 20).isActive = true
        trending.rightAnchor.constraint(equalTo: label.leftAnchor, constant: 10).isActive = true
        trending.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 25).isActive = true
              
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 2).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        label.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 25).isActive = true
        
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.widthAnchor.constraint(equalToConstant: 60).isActive = true
        progress.heightAnchor.constraint(equalToConstant: 60).isActive = true
        progress.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        progress.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        
        following.translatesAutoresizingMaskIntoConstraints = false
        following.widthAnchor.constraint(equalToConstant: 100).isActive = true
        following.heightAnchor.constraint(equalToConstant: 20).isActive = true
        following.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 10).isActive = true
        following.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 25).isActive = true
        
        trending.text = "Trending"
        label.text = "|"
        following.text = "Following"
        
        trending.textColor = UIColor.red
        following.textColor = UIColor.gray
        
        following.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeToFollowing(_:)))
        following.addGestureRecognizer(tapGesture)
        
        
        trending.isUserInteractionEnabled = true
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(changeToTrending(_:)))
        trending.addGestureRecognizer(tapGesture1)
        
        let screenSize = UIScreen.main.bounds.size
        
        self.trendingView.frame = CGRect(x: 0, y: 15, width: screenSize.width, height: screenSize.height-(self.tabBarController?.tabBar.frame.size.height ?? 49.0))
    }
    
    @objc func changeToFollowing(_ sender: UITapGestureRecognizer) {
        let isLoggedIn = UserDefaults.standard.isLoggedIn() ?? false
        if (!isLoggedIn) {
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.isNavigationBarHidden = true
            performSegue(withIdentifier: "trendingLogin", sender: self)
        } else {
            if (isTrending) {
                following.textColor = UIColor.red
                trending.textColor = UIColor.gray
                if current_video_cell != nil {
                    current_video_cell.player.player?.pause()
                }
                self.videos = self.followingTopics
                self.trendingView.reloadData()
                if (self.videos.count == 0) {
                    self.fetchFollowingData()
                }
                isTrending = false
            }
        }
    }
    
    @objc func changeToTrending(_ sender: UITapGestureRecognizer) {
        if (!isTrending) {
            trending.textColor = UIColor.red
            following.textColor = UIColor.gray
            if current_video_cell != nil {
               current_video_cell.player.player?.pause()
            }
            self.videos = self.trendingTopics
            self.trendingView.reloadData()
            isTrending = true
        }
    }
    
    func fetchFollowingData() {

        if isLoading {
            return
        }
        
        if (following_page == 1) {
            trendingView.isHidden = true
            progress.isHidden = false
        }
        
        isLoading = true
        
        var headers: [String: Any]? = nil
        
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
        headers = [
            "Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        
        let url = "https://www.boloindya.com/api/v1/get_follow_post/?language_id=\(UserDefaults.standard.getValueForLanguageId().unsafelyUnwrapped)&page=\(following_page)&uid=\(UserDefaults.standard.getUserId().unsafelyUnwrapped)"
    
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers as? HTTPHeaders)
            .responseString  { (responseData) in
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                    
                    do {
                        let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                        if let content = json_object?["results"] as? [[String:Any]] {
                            for each in content {
                                self.followingTopics.append(getTopicFromJson(each: each))
                            }
                            self.trendingView.isHidden = false
                            self.progress.isHidden = true
                            self.videos = self.followingTopics
                            self.isLoading = false
                            self.following_page += 1
                            self.trendingView.reloadData()
                        }
                    }
                    catch {
                        self.isLoading = false
                        self.progress.isHidden = true
                        print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    self.isLoading = false
                    self.progress.isHidden = true
                    print(error)
                }
        }
    }
    
    
    @IBAction func goToNextScreens(_ sender: UIButton) {
    }

    func fetchData() {

        if isLoading {
            return
        }
        
        if (page == 1) {
            trendingView.isHidden = true
            progress.isHidden = false
        }
        
        isLoading = true
        
        var headers: [String: Any]? = nil
        
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
        headers = [
            "Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        
        let url = "https://www.boloindya.com/api/v1/get_popular_video_bytes/?language_id=\(UserDefaults.standard.getValueForLanguageId().unsafelyUnwrapped)&page=\(page)&uid=\(UserDefaults.standard.getUserId().unsafelyUnwrapped)"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers as? HTTPHeaders)
            .responseString  { (responseData) in
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                    
                    do {
                        let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                        if let content = json_object?["topics"] as? [[String:Any]] {
                            for each in content {
                                self.trendingTopics.append(getTopicFromJson(each: each))
                            }
                            self.trendingView.isHidden = false
                            self.progress.isHidden = true
                            self.videos = self.trendingTopics
                            self.isLoading = false
                            self.page += 1
                            self.trendingView.reloadData()
                        }
                    }
                    catch {
                        self.isLoading = false
                        self.progress.isHidden = true
                        print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    self.isLoading = false
                    self.progress.isHidden = true
                    print(error)
                }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ProfileViewController {
            let vc = segue.destination as? ProfileViewController
            vc?.user = videos[selected_position].user
        } else  if segue.destination is LoginAndSignUpViewController {
           let vc = segue.destination as? LoginAndSignUpViewController
           vc?.selected_tab = 0
        } else if segue.destination is ThumbailViewController {
            let vc = segue.destination as? ThumbailViewController
            vc?.url = video_url
        }
    }
    
    
   @objc func onClickTransparentView(_ sender: UITapGestureRecognizer){
        self.comment_tab.isHidden = true
   }
    
    func fetchComment() {
        
        var headers: [String: Any]? = nil
        
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
        headers = [
            "Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        
        let url = "https://www.boloindya.com/api/v1/topics/ddwd/" + videos[selected_position].id + "/comments/?limit=15&offset=\(comment_page*15)"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers as? HTTPHeaders)
            .responseString  { (responseData) in
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                    
                    do {
                        let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                        if let content = json_object?["results"] as? [[String:Any]] {
                            for each in content {
                                self.comments.append(getComment(each: each))
                            }
                            if self.comments.count == 0 {
                                self.comment_label.text = "No Comments"
                            } else {
                                self.comment_label.text = "Comments"
                            }
                            self.progress_comment.isHidden = true
                            self.comment_page += 1
                            self.commentView.reloadData()
                        }
                    }
                    catch {
                        self.progress_comment.isHidden = true
                        print(error.localizedDescription)
                    }
                }
                case.failure(let error):
                self.progress_comment.isHidden = true
                    print(error)
                }
        }
    }

    func fetcUserDetails() {
           
        var headers: HTTPHeaders!
        
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
           headers  = [ "Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        } else {
            return
        }
           
        let url = "https://www.boloindya.com/api/v1/get_user_follow_and_like_list/"
       
        Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: headers)
               .responseString  { (responseData) in
                   switch responseData.result {
                   case.success(let data):
                       if let json_data = data.data(using: .utf8) {
                       
                       do {
                           let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                           if let content = json_object?["user"] as? [String:Any] {
                            
                            let user_profile_obj = content["userprofile"] as? [String:Any]
                            
                            UserDefaults.standard.setCategories(value: user_profile_obj?["sub_category"] as! [Int])
                            UserDefaults.standard.setFollowingUsers(value: json_object?["all_follow"] as! [Int])
                            
                            UserDefaults.standard.setLikeTopic(value: json_object?["topic_like"] as! [Int])
                           }
                       }
                       catch {
                           print(error.localizedDescription)
                           }
                       }
                   case.failure(let error):
                       print(error)
                   }
           }
       }
    
        func topicSeen() {
           
           let paramters: [String: Any] = [
            "topic_id": "\(videos[selected_position].id)"
           ]
           
           var headers: [String: Any]? = nil
           
           if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
               headers = ["Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
           }
           
           let url = "https://www.boloindya.com/api/v1/vb_seen/"
           
           Alamofire.request(url, method: .post, parameters: paramters, encoding: URLEncoding.default, headers: headers as? HTTPHeaders)
               .responseString  { (responseData) in
                   
           }
       }
}

extension TrendingAndFollowingViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.trendingView) {
            return videos.count
        } else {
            return comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == self.trendingView) {
            let video_cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! VideoCell
            video_cell.title.text = videos[indexPath.row].title.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            let url = URL(string: videos[indexPath.row].thumbnail)
            video_cell.video_image.kf.setImage(with: url)
            video_cell.username.text = "@"+videos[indexPath.row].user.username
            video_cell.play_and_pause_image.image = UIImage(named: "play")
            video_cell.like_count.text = videos[indexPath.row].like_count
            video_cell.comment_count.text = videos[indexPath.row].comment_count
            video_cell.share_count.text = videos[indexPath.row].share_count
            video_cell.whatsapp_share_count.text = videos[indexPath.row].whatsapp_share_count
            if !self.topic_liked.isEmpty {
                if self.topic_liked.contains(Int(videos[indexPath.row].id)!) {
                    videos[indexPath.row].isLiked = true
                    video_cell.like_image.image = video_cell.like_image.image?.withRenderingMode(.alwaysTemplate)
                    video_cell.like_image.tintColor = UIColor.red
                }
            }
            if selected_position == indexPath.row {
               if current_video_cell != nil {
                   current_video_cell.player.player?.pause()
               }
               
               current_video_cell = video_cell
               let videoUrl = NSURL(string: videos[indexPath.row].video_url)
                if videoUrl != nil {
                   let avPlayer = AVPlayer(url: videoUrl! as URL)

                   video_cell.player.playerLayer.player = avPlayer
                   video_cell.player.player?.play()
                   self.topicSeen()
                   current_video_cell.play_and_pause_image.image = UIImage(named: "pause")
                }
            }
            if (!videos[indexPath.row].user.profile_pic.isEmpty) {
                let pic_url = URL(string: videos[indexPath.row].user.profile_pic)
                video_cell.user_image.kf.setImage(with: pic_url, placeholder: UIImage(named: "user"))
            } else {
                video_cell.user_image.image = UIImage(named: "user")
            }
            video_cell.tag = indexPath.row
            video_cell.selected_postion = indexPath.row
            video_cell.delegate = self
            return video_cell
        } else {
            let menucell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CommentViewCell
            if indexPath.row < comments.count {
                menucell.configure(with: comments[indexPath.row])
            }
            return menucell
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let video_cell = self.trendingView.visibleCells[0] as? VideoCell
        if selected_position != video_cell?.tag ?? 0 {
            if current_video_cell != nil {
                current_video_cell.player.player?.pause()
            }
            current_video_cell = video_cell
            selected_position = video_cell?.tag ?? 0
            let videoUrl = NSURL(string: videos[video_cell?.tag ?? 0].video_url)
            if videoUrl != nil {
                let avPlayer = AVPlayer(url: videoUrl! as URL)

                current_video_cell.player.playerLayer.player = avPlayer
                current_video_cell.player.player?.play()
                self.topicSeen()
                current_video_cell.play_and_pause_image.image = UIImage(named: "pause")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (tableView == self.trendingView) {
            return tableView.frame.size.height
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (tableView == self.trendingView) {
            let lastSectionIndex = tableView.numberOfSections - 1
            let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
            
            if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
                self.fetchData()
            }
        } else {
            fetchComment()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == self.trendingView) {
            selected_position = indexPath.row
            self.comment_tab.isHidden = true
        } else {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}

extension TrendingAndFollowingViewController: VideoCellDelegate {
    func renderComments(with selected_postion: Int) {
        selected_position = selected_postion
        progress_comment.isHidden = false
        comment_tab.isHidden = false
        comment_page = 0
        comments.removeAll()
        commentView.reloadData()
        fetchComment()
    }
    
    func goToProfile(with selected_postion: Int) {
        self.selected_position = selected_postion
        self.performSegue(withIdentifier: "ProfileView", sender: self)
        self.tabBarController?.tabBar.isHidden = true
    }

    func downloadAndShareVideoWhatsapp(with selected_postion: Int) {
        let videoUrl = videos[selected_postion].video_url

        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let destinationUrl = docsUrl.appendingPathComponent("boloindya_videos"+videos[selected_postion].id+".mp4")
        if(FileManager().fileExists(atPath: destinationUrl.path)){
            let activityController = UIActivityViewController(activityItems: [destinationUrl], applicationActivities: nil)
            activityController.completionWithItemsHandler = { (nil, completed, _, error) in
                if completed {
                    print("completed")
                } else {
                    print("error")
                }
            }
            self.video_url = destinationUrl
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.isNavigationBarHidden = true
            performSegue(withIdentifier: "thumbnailVideo", sender: self)
            
//            self.present(activityController, animated: true) {
//                print("Done")
//            }
            print("\n\nfile already exists\n\n")
        } else{
            var request = URLRequest(url: URL(string: videoUrl)!)
            request.httpMethod = "GET"
            _ = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if(error != nil){
                print("\n\nsome error occured\n\n")
                return
            }
            if let response = response as? HTTPURLResponse{
                if response.statusCode == 200 {
                    DispatchQueue.main.async {
                        if let data = data{
                            if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic){
                                
                                print("\n\nurl data written\n\n")
                                print(destinationUrl)
                                let activityController = UIActivityViewController(activityItems: [destinationUrl], applicationActivities: nil)
                                activityController.completionWithItemsHandler = { (nil, completed, _, error) in
                                    if completed {
                                        print("completed")
                                    } else {
                                        print("error")
                                    }
                                    
                                    }
                                    self.present(activityController, animated: true) {
                                }
                            
                            }
                            else{
                                print("\n\nerror again\n\n")
                            }
                        }
                    }
                }
            }
        }).resume()
            
        }
    }
    
    func likedTopic(with selected_postion: Int) {
        if self.videos[selected_postion].isLiked {
            topic_liked.remove(at: topic_liked.firstIndex(of: Int(self.videos[selected_postion].id)!)!)
        } else {
            topic_liked.append(Int(self.videos[selected_postion].id)!)
        }
        UserDefaults.standard.setLikeTopic(value: topic_liked)
    }
}
