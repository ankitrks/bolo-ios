//
//  VideoViewController.swift
//  BoloIndya
//
//  Created by apple on 7/14/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class VideoViewController: UIViewController {
    
    var videos: [Topic] = []
    var comments: [Comment] = []
    var videoView = UITableView()
    var go_back =  UIImageView()
    
    var selected_position = 0
    var isLoaded: Bool = false
    var self_user: Bool = false
    var topic_id = ""
    
    var commentView = UITableView()
    var comment_tab = UIView()
    var profile_pic = UIImageView()
    var comment_title = UITextField()
    var submit_comment = UIImageView()
    var progress_comment = UIActivityIndicatorView()
    var comment_label = UILabel()
    
    var go_back_comment =  UIImageView()
    
    var comment_page = 0
    var current_video_cell: VideoCell!
    
    var topic_liked: [Int] = []
    var comment_like: [Int] = []
    var keyboardHeight: Int = 250
    
    weak var contrain: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        
        NotificationCenter.default.addObserver(self, selector:  #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        topic_liked = UserDefaults.standard.getLikeTopic()
        comment_like = UserDefaults.standard.getLikeComment()
        
        setVideoViewDelegate()
    }
    
    @objc internal func keyboardWillShow(_ notification: NSNotification?) {
        var _kbSize: CGSize!
        
        if let info = notification?.userInfo {
            let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
            if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
                let screenSize = UIScreen.main.bounds
                let intersectRect = kbFrame.intersection(screenSize)
                if intersectRect.isNull {
                    _kbSize = CGSize(width: screenSize.size.width, height: 0)
                } else {
                    _kbSize = intersectRect.size
                    contrain.constant = -(_kbSize.height)
                    
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setVideoViewDelegate() {
        view.addSubview(videoView)
        view.addSubview(go_back)
        
        videoView.translatesAutoresizingMaskIntoConstraints = false
        videoView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        videoView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        videoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        videoView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        
        videoView.isScrollEnabled = true
        videoView.isPagingEnabled = true
        videoView.delegate = self
        videoView.dataSource = self
        videoView.backgroundColor = .black
        videoView.register(VideoCell.self, forCellReuseIdentifier: "Cell")
        
        go_back.translatesAutoresizingMaskIntoConstraints = false
        go_back.widthAnchor.constraint(equalToConstant: 40).isActive = true
        go_back.heightAnchor.constraint(equalToConstant: 40).isActive = true
        go_back.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5).isActive = true
        go_back.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        
        go_back.image = UIImage(named: "close")
        go_back.tintColor = UIColor.white
        
        go_back.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goBack(_:)))
        go_back.addGestureRecognizer(tapGesture)
        
        if !topic_id.isEmpty {
            self.videoView.isHidden = true
            fetchVideoBytes()
        }
        
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
        comment_tab.addSubview(go_back_comment)
        
        view.addSubview(comment_tab)
        
        comment_tab.translatesAutoresizingMaskIntoConstraints = false
        comment_tab.heightAnchor.constraint(equalToConstant: 400).isActive = true
        comment_tab.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        comment_tab.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        contrain = comment_tab.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        contrain.isActive = true
        comment_tab.backgroundColor = .black
        
        go_back_comment.translatesAutoresizingMaskIntoConstraints = false
        go_back_comment.widthAnchor.constraint(equalToConstant: 30).isActive = true
        go_back_comment.heightAnchor.constraint(equalToConstant: 30).isActive = true
        go_back_comment.rightAnchor.constraint(equalTo: comment_tab.rightAnchor, constant: -5).isActive = true
        go_back_comment.topAnchor.constraint(equalTo: comment_tab.topAnchor, constant: 5).isActive = true
        
        go_back_comment.image = UIImage(named: "close")
        go_back_comment.tintColor = UIColor.white
        
        go_back_comment.isUserInteractionEnabled = true
        
        let tapGestureBack = UITapGestureRecognizer(target: self, action: #selector(onClickTransparentView(_:)))
        go_back_comment.addGestureRecognizer(tapGestureBack)
        
        progress_comment.translatesAutoresizingMaskIntoConstraints = false
        progress_comment.heightAnchor.constraint(equalToConstant: 60).isActive = true
        progress_comment.widthAnchor.constraint(equalToConstant: 60).isActive = true
        progress_comment.centerXAnchor.constraint(equalTo: comment_tab.centerXAnchor, constant: 0).isActive = true
        progress_comment.centerYAnchor.constraint(equalTo: comment_tab.centerYAnchor, constant: 0).isActive = true
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
        
        comment_title.textColor = UIColor.white
        comment_title.placeholder = "Add a comment"
        comment_title.attributedPlaceholder = NSAttributedString(string: "Add a comment", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        comment_title.delegate = self
        
        submit_comment.translatesAutoresizingMaskIntoConstraints = false
        submit_comment.heightAnchor.constraint(equalToConstant: 30).isActive = true
        submit_comment.widthAnchor.constraint(equalToConstant: 30).isActive = true
        submit_comment.rightAnchor.constraint(equalTo: comment_tab.rightAnchor, constant: -10).isActive = true
        submit_comment.bottomAnchor.constraint(equalTo: comment_tab.bottomAnchor, constant: -10).isActive = true
        submit_comment.contentMode = .scaleAspectFill
        submit_comment.clipsToBounds = true
        
        submit_comment.isUserInteractionEnabled = true
        
        let tapGestureSubmit = UITapGestureRecognizer(target: self, action: #selector(submitComment(_:)))
        submit_comment.addGestureRecognizer(tapGestureSubmit)
        
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
        
        comment_tab.isHidden = true
        
        commentView.translatesAutoresizingMaskIntoConstraints = false
        commentView.heightAnchor.constraint(equalToConstant: 310).isActive = true
        commentView.leftAnchor.constraint(equalTo: comment_tab.leftAnchor, constant: 0).isActive = true
        commentView.rightAnchor.constraint(equalTo: comment_tab.rightAnchor, constant: 0).isActive = true
        commentView.bottomAnchor.constraint(equalTo: profile_pic.topAnchor, constant: -5).isActive = true
        commentView.separatorStyle = .none
        
        comment_tab.isHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if current_video_cell != nil {
            current_video_cell.player.player?.pause()
        }
    }
    
    @objc func onClickTransparentView (_ sender: UITapGestureRecognizer) {
        self.comment_tab.isHidden = true
        self.comment_title.resignFirstResponder()
        contrain.constant = 0
    }
    
    func fetchData() {
        
    }
    
    func fetchVideoBytes() {
        
        
        let headers: [String: Any] = [
            "Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        
        let url = "https://www.boloindya.com/api/v1/notification_topic/?topic_id=\(topic_id)"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers as? HTTPHeaders)
            .responseString  { (responseData) in
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                        
                        do {
                            let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                            if let content = json_object?["result"] as? [[String:Any]] {
                                for each in content {
                                    self.videos.append(getTopicFromJson(each: each))
                                }
                            }
                            self.videoView.isHidden = false
                            self.videoView.reloadData()
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
    
    @objc func goBack(_ sender: UITapGestureRecognizer) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func submitComment(_ sender: UITapGestureRecognizer) {
        let paramters: [String: Any] = [
            "comment": "\(comment_title.text.unsafelyUnwrapped)",
            "topic_id": "\(videos[selected_position].id)",
            "language_id": "\(UserDefaults.standard.getValueForLanguageId().unsafelyUnwrapped)"
        ]
        
        var headers: [String: Any]? = nil
        
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
            headers = ["Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        
        let url = "https://www.boloindya.com/api/v1/reply_on_topic"
        
        Alamofire.request(url, method: .post, parameters: paramters, encoding: URLEncoding.default, headers: headers as? HTTPHeaders)
            .responseString  { (responseData) in
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                        
                        do {
                            let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                            if let content = json_object?["comment"] as? [String:Any] {
                                self.comments.insert(getComment(each: content), at: 0)
                                if self.comments.count == 0 {
                                    self.comment_label.text = "No Comments"
                                } else {
                                    self.comment_label.text = "Comments"
                                }
                                self.comment_title.resignFirstResponder()
                                self.contrain.constant = 0
                                self.comment_title.text = ""
                                self.commentView.reloadData()
                            }
                        }
                        catch {
                            self.comment_title.resignFirstResponder()
                            self.contrain.constant = 0
                            print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    self.comment_title.resignFirstResponder()
                    self.contrain.constant = 0
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
    
    func onClickTransparentView() {
        self.comment_tab.isHidden = true
        self.comment_title.resignFirstResponder()
        contrain.constant = 0
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
    
    func topicLike() {
        
        let paramters: [String: Any] = [
            "topic_id": "\(videos[selected_position].id)"
        ]
        
        var headers: [String: Any]? = nil
        
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
            headers = ["Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        
        let url = "https://www.boloindya.com/api/v1/like/"
        
        Alamofire.request(url, method: .post, parameters: paramters, encoding: URLEncoding.default, headers: headers as? HTTPHeaders)
            .responseString  { (responseData) in
                
        }
    }
    
    
    func commentLike(id: Int) {
        let paramters: [String: Any] = [
            "comment_id": "\(id)"
        ]
        
        var headers: [String: Any]? = nil
        
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
            headers = ["Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        
        let url = "https://www.boloindya.com/api/v1/like/"
        
        Alamofire.request(url, method: .post, parameters: paramters, encoding: URLEncoding.default, headers: headers as? HTTPHeaders)
            .responseString  { (responseData) in
                
        }
    }
}

extension VideoViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == videoView {
            return videos.count
        } else {
            return comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == videoView {
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
                    
                    current_video_cell.player.playerLayer.player = avPlayer
                    current_video_cell.player.player?.play()
                    current_video_cell.play_and_pause_image.image = UIImage(named: "pause")
                }
                self.topicSeen()
            }
            if (!videos[indexPath.row].user.profile_pic.isEmpty) {
                let pic_url = URL(string: videos[indexPath.row].user.profile_pic)
                video_cell.user_image.kf.setImage(with: pic_url)
            }
            if (!self.isLoaded && indexPath.row <= selected_position) {
                if (indexPath.row == selected_position) {
                    self.isLoaded = true
                    self.videoView.scrollToRow(at: IndexPath(row:  indexPath.row, section: 0), at: .none, animated: false)
                } else {
                    self.videoView.scrollToRow(at: IndexPath(row:  indexPath.row + 1 , section: 0), at: .none, animated: false)
                }
            }
            video_cell.tag = indexPath.row
            video_cell.selected_postion = indexPath.row
            video_cell.delegate = self
            return video_cell
        } else {
            let menucell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CommentViewCell
            if indexPath.row < comments.count {
                if !self.comment_like.isEmpty {
                    if self.comment_like.contains(Int(comments[indexPath.row].id)!) {
                        comments[indexPath.row].isLiked = true
                    }
                }
                menucell.configure(with: comments[indexPath.row])
            }
            return menucell
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let video_cell = self.videoView.visibleCells[0] as? VideoCell
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
            current_video_cell.play_and_pause_image.image = UIImage(named: "pause")
        }
        self.topicSeen()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == videoView {
            return tableView.frame.size.height
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (tableView == videoView) {
            let lastSectionIndex = tableView.numberOfSections - 1
            let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
            
            if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
                self.fetchData()
            }
        } else {
            let lastSectionIndex = tableView.numberOfSections - 1
            let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
            
            if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
                self.fetchComment()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == videoView) {
            selected_position = indexPath.row
            self.onClickTransparentView()
        } else {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
}

extension VideoViewController: VideoCellDelegate {
    func renderComments(with selected_postion: Int) {
        self.selected_position = selected_postion
        if current_video_cell != nil {
            current_video_cell.player.player?.pause()
            current_video_cell.play_and_pause_image.image = UIImage(named: "play")
        }
        progress_comment.isHidden = false
        comment_tab.isHidden = false
        comment_page = 0
        comments.removeAll()
        commentView.reloadData()
        comment_title.text = ""
        fetchComment()
    }
    
    func goToProfile(with selected_postion: Int) {
        if self.self_user {
            if current_video_cell != nil {
                current_video_cell.player.player?.pause()
            }
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.selected_position = selected_postion
            self.performSegue(withIdentifier: "videoProfile", sender: self)
            self.tabBarController?.tabBar.isHidden = true
        }
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
            self.present(activityController, animated: true) {
                print("Done")
            }
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
        self.selected_position = selected_postion
        if self.videos[selected_postion].isLiked {
            topic_liked.remove(at: topic_liked.firstIndex(of: Int(self.videos[selected_postion].id)!)!)
        } else {
            topic_liked.append(Int(self.videos[selected_postion].id)!)
        }
        UserDefaults.standard.setLikeTopic(value: topic_liked)
        self.topicLike()
    }
}


extension VideoViewController: CommentViewCellDelegate {
    
    func likedComment(with selected_postion: Int) {
        if self.comments[selected_postion].isLiked {
            comment_like.remove(at: comment_like.firstIndex(of: Int(self.comments[selected_postion].id)!)!)
        } else {
            comment_like.append(Int(self.comments[selected_postion].id)!)
        }
        UserDefaults.standard.setLikeComment(value: comment_like)
        self.commentLike(id: Int(self.comments[selected_postion].id)!)
    }
}


extension VideoViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.comment_title.resignFirstResponder()
        contrain.constant = 0
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
}

