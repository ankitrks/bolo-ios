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
import SVProgressHUD

class TrendingAndFollowingViewController: BaseVC {
    
    var trendingView = SelfSizedTableView()
    
    var videos: [Topic] = []
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
    
    var video_url: URL!
    var topic_liked: [Int] = []
    var comment_like: [Int] = []
    
    var current_video_cell: VideoCell!
    let screenSize = UIScreen.main.bounds
    var deviceHeight:CGFloat = 100.0
    
    var avPlayer = AVPlayer()
    
    var commentsView: BICommentView?
    var reportViewController: BIReportViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
        initTabBarProfileImage()
        
        topic_liked = UserDefaults.standard.getLikeTopic()
        comment_like = UserDefaults.standard.getLikeComment()
        setTrendingViewDelegate()
        deviceHeight = self.view.frame.height
        fetcUserDetails()
        fetchData()
        
//        tabBarController?.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
        print("DEVICE ID ",UIDevice.current.identifierForVendor?.uuidString ?? "")
//        print("DEVICE ID ",(UIDevice.current.name + UIDevice.current.systemName + UIDevice.current.systemVersion).replacingCharacters(in: " ", with: "boloindya") )
         //var ui:String =
      //  self.showToast(message: "DEVICE ID \(UIDevice.current.identifierForVendor?.uuidString ?? "")")
        if current_video_cell != nil {

            current_video_cell.player.player?.play()
            current_video_cell.play_and_pause_image.image = UIImage(named: "pause")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if current_video_cell != nil {
            current_video_cell.player.player?.pause()
        }
    }
    
    private func initTabBarProfileImage() {
        if let pic = UserDefaults.standard.getProfilePic(),
           !pic.isEmpty,
           let url = URL(string: pic),
           let count = tabBarController?.tabBar.items?.count,
           count > 4 {
            
            let item = tabBarController?.tabBar.items?[4]
            
//            if ImageCache.default.isCached(forKey: url.absoluteString) {
//                item?.selectedImage = nil
//                item?.image = nil
//            }
            
            ImageCache.default.clearDiskCache()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let imageSize: CGFloat = 24
                let processor = ResizingImageProcessor(referenceSize: CGSize(width: imageSize, height: imageSize)) |> RoundCornerImageProcessor(cornerRadius: imageSize/2)
                let resource = ImageResource(downloadURL: url)
                KingfisherManager.shared.retrieveImage(with: resource, options: [.processor(processor),
                                                                                 .scaleFactor(UIScreen.main.scale)])
                { (result) in
                    switch result {
                    case .success(let value):
                        let image = value.image
                        DispatchQueue.main.async {
                            item?.selectedImage = image.withRenderingMode(.alwaysOriginal)
                            item?.image = image.withRenderingMode(.alwaysOriginal)
                        }
                        
                    case .failure(let error):
                        print("Error: \(error)")
    //                    item?.selectedImage = UIImage(named: "user")
    //                    item?.image = UIImage(named: "user")
                    }
                }
            }
        }
    }
    
    func setTrendingViewDelegate() {
        trendingView.isScrollEnabled = true
        trendingView.isPagingEnabled = true
        trendingView.delegate = self
        trendingView.dataSource = self
       // trendingView.intrinsicContentSize
        trendingView.register(VideoCell.self, forCellReuseIdentifier: "Cell")
        trendingView.showsVerticalScrollIndicator = false
        
        view.addSubview(progress)
        view.addSubview(trendingView)
        view.addSubview(trending)
        view.addSubview(following)
        view.addSubview(label)
        
        trending.translatesAutoresizingMaskIntoConstraints = false
        trending.widthAnchor.constraint(equalToConstant: 88).isActive = true
        trending.rightAnchor.constraint(equalTo: label.leftAnchor, constant: 0).isActive = true
        trending.topAnchor.constraint(equalTo: self.view.topAnchor, constant: getStatusBarHeight()+10).isActive = true
        
        trending.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 0).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        label.topAnchor.constraint(equalTo: self.view.topAnchor, constant: getStatusBarHeight()+10).isActive = true
        
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        progress.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        progress.color = UIColor.white
        
        following.translatesAutoresizingMaskIntoConstraints = false
        following.widthAnchor.constraint(equalToConstant: 88).isActive = true
        following.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 0).isActive = true
        following.topAnchor.constraint(equalTo: self.view.topAnchor, constant: getStatusBarHeight()+10).isActive = true
        
        following.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        trending.text = "Trending"
        label.text = ""
        following.text = "Following"
        
        trending.textColor = UIColor(hex: "10A5F9")
        following.textColor = UIColor.white
        
        following.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeToFollowing(_:)))
        following.addGestureRecognizer(tapGesture)
        
        
        trending.isUserInteractionEnabled = true
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(changeToTrending(_:)))
        trending.addGestureRecognizer(tapGesture1)
        

        
        trendingView.translatesAutoresizingMaskIntoConstraints = false
        trendingView.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        trendingView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        trendingView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: getStatusBarHeight()).isActive = true
        trendingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -(self.tabBarController?.tabBar.frame.size.height ?? 49.0)).isActive = true
        trendingView.separatorStyle = .none
    }
    
    @objc func changeToFollowing(_ sender: UITapGestureRecognizer) {
        if isLogin() {
            if (isTrending) {
                following.textColor = UIColor(hex: "10A5F9")
                trending.textColor = UIColor.white
                if current_video_cell != nil {
                    current_video_cell.player.player?.pause()
                }
                self.videos = self.followingTopics
                self.trendingView.backgroundColor = UIColor.black
                //                self.trendingView.isUserInteractionEnabled = true
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
            trending.textColor = UIColor(hex: "10A5F9")
            following.textColor = UIColor.white
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
            progress.startAnimating()
        }
        
        isLoading = true
        
        var headers: HTTPHeaders? = nil
        
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
            headers = [
                "Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        
        let url = "https://www.boloindya.com/api/v1/get_follow_post/?language_id=\(UserDefaults.standard.getValueForLanguageId().unsafelyUnwrapped)&page=\(following_page)&uid=\(UserDefaults.standard.getUserId().unsafelyUnwrapped)"
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
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
                                self.progress.stopAnimating()
                                self.progress.isHidden = true
                                self.videos = self.followingTopics
                                self.isLoading = false
                                self.following_page += 1
                                self.trendingView.reloadData()
                                
                                if self.page == 2, let object = self.followingTopics.first {
                                    self.hitEvent(eventName: EventName.videoPlayed, object: object)
                                }
                            }
                        }
                        catch {
                            self.isLoading = false
                            self.progress.isHidden = true
                            self.progress.stopAnimating()
                            print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    self.isLoading = false
                    self.progress.isHidden = true
                    self.progress.stopAnimating()
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
        
        var headers: HTTPHeaders? = nil
        
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
            headers = [
                "Authorization": "Bearer \(UserDefaults.standard.getAuthToken() ?? "")"]
        }
        print("Auth token \(headers ?? ["":""])")

       var vb_score = "";

        if !videos.isEmpty {
            vb_score = "&vb_score=" + videos[videos.count - 1].vb_score
        }

       // if let time = UserDefaults.standard.getlastUpdateTime(){
        let lasttime = "&last_updated=\(UserDefaults.standard.getlastUpdateTime() ?? "")"


        let url = "https://www.boloindya.com/api/v1/get_popular_video_bytes/?language_id=\(UserDefaults.standard.getValueForLanguageId().unsafelyUnwrapped)&page=\(page)\(vb_score)\(lasttime)&uid=\(UserDefaults.standard.getUserId().unsafelyUnwrapped)"
        print("url \(url)")
        
        AF.request(url, method: .get, parameters: nil, headers: headers, interceptor: nil)
            .responseString  { (responseData) in
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                        
                        do {
                            let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                        //    print(" response \(json_object?["topics"])")
                            if let content = json_object?["topics"] as? [[String:Any]] {
                                
                                for each in content {
                                    self.trendingTopics.append(getTopicFromJson(each: each))
                                }
                            }
                            self.progress.stopAnimating()
                            self.trendingView.isHidden = false
                            self.progress.isHidden = true
                            self.videos = self.trendingTopics
                            self.isLoading = false
                            self.page += 1
                            self.trendingView.reloadData()
                            UserDefaults.standard.setLastUpdateTime(value: "\(Date().currentTimeMillis())")
                            
                            if self.page == 2, let object = self.trendingTopics.first {
                                self.hitEvent(eventName: EventName.videoPlayed, object: object)
                            }
                        }
                        catch {
                            self.isLoading = false
                            self.progress.stopAnimating()
                            self.progress.isHidden = true
                            print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    self.isLoading = false
                    self.progress.stopAnimating()
                    self.progress.isHidden = true
                    print(error)
                }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ProfileViewController {
            let vc = segue.destination as? ProfileViewController
            if let user = videos[selected_position].user {
                vc?.user = user
            }
        } else  if segue.destination is LoginAndSignUpViewController {
            let vc = segue.destination as? LoginAndSignUpViewController
            vc?.selected_tab = 0
        } else if segue.destination is ThumbailViewController {
            let vc = segue.destination as? ThumbailViewController
            vc?.url = video_url
        }
    }
    
    
    @objc func onClickTransparentView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve, animations: {
            self.commentsView?.frame.origin.y = self.view.bounds.height
            self.commentsView?.layoutIfNeeded()
        }, completion: { _ in
            self.commentsView?.removeFromSuperview()
            self.commentsView = nil
        })
        
        current_video_cell.player.player?.play()
    }
    
    func fetcUserDetails() {
        
        var headers: HTTPHeaders!
        
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
            headers  = [ "Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        } else {
            return
        }
        
        let url = "https://www.boloindya.com/api/v1/get_user_follow_and_like_list/"
        
        AF.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: headers)
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
                                
                                UserDefaults.standard.setLikeComment(value: json_object?["comment_like"] as! [Int])
                                
                                
                                self.topic_liked = json_object?["topic_like"] as! [Int]
                                self.comment_like = json_object?["comment_like"] as! [Int]
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
        
        var headers: HTTPHeaders?
        
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
            headers = ["Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        

        
        AF.request(SEEN_VB, method: .post, parameters: paramters, encoding: URLEncoding.default, headers: headers)
            .responseString  { (responseData) in
                print(responseData)
        }
    //  setParam(showProgressBar: false, url: SEEN_VB, param: paramters, className: <#T##Mappable.Protocol#>)


    }
    
    func topicLike() {
        
        let paramters: [String: Any] = [
            "topic_id": "\(videos[selected_position].id)"
        ]
        
        var headers: HTTPHeaders?
        
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
            headers = ["Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        
        let url = "https://www.boloindya.com/api/v1/like/"
        
        AF.request(url, method: .post, parameters: paramters, encoding: URLEncoding.default, headers: headers)
            .responseString  { (responseData) in
                
        }
    }
    
    func commentLike(id: Int) {
        let paramters: [String: Any] = [
            "comment_id": "\(id)"
        ]
        
        var headers: HTTPHeaders?
        
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
            headers = ["Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        
        let url = "https://www.boloindya.com/api/v1/like/"
        
        AF.request(url, method: .post, parameters: paramters, encoding: URLEncoding.default, headers: headers)
            .responseString  { (responseData) in
                
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func playVideo(url: String) {
        
        guard let videoUrl = URL(string: url) else { return }
        
        let mimeType = "video/mp4; codecs=\"avc1.42E01E, mp4a.40.2\""
        let asset = AVURLAsset(url: videoUrl, options:["AVURLAssetOutOfBandMIMETypeKey": mimeType])
        let playerItem = AVPlayerItem(asset: asset)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.avPlayer = AVPlayer(playerItem: playerItem)
            
            //avPlayer = AVPlayer(url: videoUrl! as URL)
            self.avPlayer.addObserver(self, forKeyPath: "status", options: [.old, .new], context: nil)
            if #available(iOS 10.0, *) {
                self.avPlayer.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
            } else {
                self.avPlayer.addObserver(self, forKeyPath: "rate", options: [.old, .new], context: nil)
            }
            if self.current_video_cell != nil {
                self.current_video_cell.player.playerLayer.player = self.avPlayer
                self.current_video_cell.player.playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                // current_video_cell.backgroundColor = UIColVor.black.cgColor
                
            }
            
            self.avPlayer.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main, using: { (CMTime) -> Void in
                let time: Float64 = CMTimeGetSeconds(self.avPlayer.currentTime())
                
                if self.current_video_cell != nil {
                    self.current_video_cell.playerSlider.value = Float(time)
                    self.current_video_cell.playerSlider.minimumValue = 0
                    self.current_video_cell.playerSlider.maximumValue = Float(CMTimeGetSeconds( (self.avPlayer.currentItem?.asset.duration)!))
                    let durationTime = Int(time)
                    self.current_video_cell.duration.text = String(format: "%02d:%02d", durationTime/60 , durationTime % 60)
                }
            })
            self.topicSeen()
        }

    }
    func playingVideo() {
        if #available(iOS 10.0, *) {
            avPlayer.automaticallyWaitsToMinimizeStalling = false
            avPlayer.playImmediately(atRate: 1.0)
        } else {
            avPlayer.play()
        }
    }
    
    @objc func playerSlider() {
        if current_video_cell != nil {
            let seekTime = CMTime(value: Int64(current_video_cell.playerSlider.value), timescale: 1)
            avPlayer.seek(to: seekTime)
            print("time \(seekTime)")
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as AnyObject? === avPlayer {
            if keyPath == "status" {
                if avPlayer.status == .readyToPlay {
                    playingVideo()
                }
            } else if keyPath == "timeControlStatus" {
                if #available(iOS 10.0, *) {
                    if avPlayer.timeControlStatus == .playing {
                        current_video_cell.playerSlider.addTarget(self, action: #selector(playerSlider), for: .valueChanged)
                        if current_video_cell != nil {
                            current_video_cell.video_image.isHidden = true
                            current_video_cell.play_and_pause_image.image = UIImage(named: "pause")
                        }
                    } else {
                        if current_video_cell != nil {
                            current_video_cell.play_and_pause_image.image = UIImage(named: "play")
                        }
                    }
                }
            } else if keyPath == "rate" {
                if avPlayer.rate > 0 {
                    if current_video_cell != nil {
                        current_video_cell.video_image.isHidden = true
                        current_video_cell.play_and_pause_image.image = UIImage(named: "pause")
                    }
                } else {
                    if current_video_cell != nil {
                        current_video_cell.play_and_pause_image.image = UIImage(named: "play")
                    }
                }
            }
        }
    }
    
}

extension TrendingAndFollowingViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.trendingView) {
            return videos.count
        } else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == self.trendingView) {
            let video_cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! VideoCell
            
            if !self.topic_liked.isEmpty {
                if self.topic_liked.contains(Int(videos[indexPath.row].id)!) {
                    videos[indexPath.row].isLiked = true
                }
            }
            video_cell.sizeFrame =  screenSize.size
            if selected_position == indexPath.row {
                if current_video_cell != nil {
                    current_video_cell.player.player?.pause()
                }else{
                    current_video_cell = video_cell
                    
                }
                
                let object = videos[indexPath.row]
                self.playVideo(url: object.video_url)
            }else{
                video_cell.selected_postion = indexPath.row
                video_cell.tag = indexPath.row
            }
            video_cell.configure(with: videos[indexPath.row])
            
            video_cell.delegate = self
            
            return video_cell
        } else {
            let menucell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CommentViewCell
            menucell.selected_postion = indexPath.row
            return menucell
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let video_cell = trendingView.visibleCells.first as? VideoCell, selected_position != video_cell.tag {
            if current_video_cell != nil {
                current_video_cell.player.player?.pause()
                
            }
            current_video_cell = video_cell
            selected_position = video_cell.tag
            
            guard videos.count > selected_position else { return }
            
            let object = videos[selected_position]
            self.playVideo(url: object.video_url)
            
            hitEvent(eventName: EventName.videoPlayed, object: object)
        }
    }
    
    private func hitEvent(eventName: String, object: Topic) {
        let values = ["WhatsApp Share Num": object.getCountNum(from: object.whatsapp_share_count),
                      "WhatsApp Share": object.whatsapp_share_count,
                      "Video Id": object.id,
                      "User Id": object.user?.id ?? 0,
                      "Video Link": object.video_url,
                      "Comments": object.comment_count,
                      "Comments Num": object.getCountNum(from: object.comment_count),
                      "Likes": object.like_count,
                      "Likes Num": object.getCountNum(from: object.like_count),
                      "Name": object.user?.name ?? "",
                      "Shares": object.share_count,
                      "Shares Num": object.getCountNum(from: object.share_count),
                      "Language": object.languageId,
                      "Username": object.user?.username ?? "",
                      "User Type": object.user?.getUserType() ?? ""] as [String: Any]
        WebEngageHelper.trackEvent(eventName: eventName, values: values)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  tableView.frame.height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        
        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
            self.fetchData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == self.trendingView) {
            selected_position = indexPath.row
        } else {
            tableView.deselectRow(at: indexPath, animated: false)
        }
        
        onClickTransparentView()
    }
}

extension TrendingAndFollowingViewController: VideoCellDelegate {
    func goToAudioSelect(with selected_postion: Int) {
        guard videos.count > selected_postion else { return }
        
        current_video_cell.player.player?.pause()
        
        let vc = BIAudioSelectViewController.loadFromNib()
        vc.music = videos[selected_postion].music
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapOptions(with selected_postion: Int) {
        current_video_cell.player.player?.pause()
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Report", style: .destructive, handler: { (_) in
            guard self.videos.count > selected_postion else { return }
            
            SVProgressHUD.show()
            
            var headers: HTTPHeaders?
            if let token = UserDefaults.standard.getAuthToken(), !token.isEmpty {
                headers = ["Authorization": "Bearer \(token)"]
            }
            
            let url = "https://www.boloindya.com/api/v2/report/items/?target=video"
            
            AF.request(url, method: .get, encoding: URLEncoding.default, headers: headers)
                .responseString  { [weak self] (responseData) in
                    SVProgressHUD.dismiss()
                    
                    switch responseData.result {
                    case.success(let data):
                        if let json_data = data.data(using: .utf8) {
                            do {
                                let jsonObject = try JSONDecoder().decode(BIReportModel.self, from: json_data)
                                
                                let vc = BIReportViewController.loadFromNib()
                                vc.delegate = self
                                vc.model = jsonObject
                                vc.video = self?.videos[selected_postion]
                                vc.modalPresentationStyle = .overCurrentContext
                                vc.modalTransitionStyle = .crossDissolve
                                self?.present(vc, animated: true, completion: nil)
                                
                                self?.reportViewController = vc
                                
                                return
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    case.failure(let error):
                        print(error)
                    }
                    
                    self?.showToast(message: "Something went wrong. Please try again.")
            }
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { _ in
            self.current_video_cell.player.player?.play()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func didTapPlayer() {
        onClickTransparentView()
    }

    func renderComments(with selected_postion: Int) {
        if isLogin() {
            self.selected_position = selected_postion
            if current_video_cell != nil {
                current_video_cell.player.player?.pause()
                current_video_cell.play_and_pause_image.image = UIImage(named: "play")
            }
            
            commentsView = BICommentView.fromNib()
            let y = view.bounds.height - (self.tabBarController?.tabBar.bounds.height ?? 0) - 350
            let frame = CGRect(x: 0, y: y, width: view.bounds.width, height: 350)
            if videos.count > selected_position {
                commentsView?.config(topic: videos[selected_position], originalFrame: frame, viewController: self, delegate: self, type: .trendingView)
            }
            self.view.addSubview(commentsView!)
            
            commentsView?.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: 350)
            UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve, animations: {
                self.commentsView?.frame.origin.y = frame.origin.y
                self.commentsView?.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func goToProfile(with selected_postion: Int) {
        self.selected_position = selected_postion
        self.performSegue(withIdentifier: "ProfileView", sender: self)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func goToSharing(with selected_postion: Int) {
        shareAndDownload(with: selected_postion)
    }

    func shareAndDownload(with selected_postion: Int) {
        guard videos.count > selected_postion else { return }
        
        var isDownloadUrlAvailable = true
        
        let object = videos[selected_postion]
        
        var videoUrl = object.downloaded_url
        if videoUrl.isEmpty {
            videoUrl = object.video_url
            isDownloadUrlAvailable = false
        }
        
        guard let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let destinationUrl = docsUrl.appendingPathComponent("boloindya_videos" + object.id + ".mp4")
        let watermarkedUrl = docsUrl.appendingPathComponent("boloindya_videos" + object.id + "watermark.mp4")
        
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setContainerView(self.view)
        SVProgressHUD.show(withStatus: "Preparing")
        
        if FileManager().fileExists(atPath: watermarkedUrl.path), isDownloadUrlAvailable {
            SVProgressHUD.dismiss()
            
            let activityController = UIActivityViewController(activityItems: [watermarkedUrl], applicationActivities: nil)
            activityController.completionWithItemsHandler = { (type, completed, _, error) in
                if type == UIActivity.ActivityType.instagram, let instagramUrl = URL(string: "instagram://app"), UIApplication.shared.canOpenURL(instagramUrl) {
                    UIApplication.shared.open(instagramUrl, options: [:], completionHandler: nil)
                }
                
                if completed {
                    print("completed")
                } else {
                    print("error")
                }
            }
            present(activityController, animated: true)
        } else if !videoUrl.isEmpty {
            SVProgressHUD.show(withStatus: "Downloading")
            
            AF.request(videoUrl).downloadProgress(closure: { (progress) in
                let fraction = progress.fractionCompleted
                let percent = Int(fraction * 100)
                SVProgressHUD.showProgress(Float(fraction), status: "Downloading... \(percent)%")
            }).responseData{ (response) in
                let result = response.result
                
                switch result {
                case .success(let data):
                    do {
                        if isDownloadUrlAvailable {
                            let _ = try data.write(to: watermarkedUrl, options: Data.WritingOptions.atomic)
                            
                            DispatchQueue.main.async {
                                let activityController = UIActivityViewController(activityItems: [watermarkedUrl], applicationActivities: nil)
                                activityController.completionWithItemsHandler = { (type, completed, _, error) in
                                    if type == UIActivity.ActivityType.instagram, let instagramUrl = URL(string: "instagram://app"), UIApplication.shared.canOpenURL(instagramUrl) {
                                        UIApplication.shared.open(instagramUrl, options: [:], completionHandler: nil)
                                    }
                                    
                                    if completed {
                                        print("completed")
                                    } else {
                                        print("error")
                                    }
                                }
                                
                                self.present(activityController, animated: true)
                                SVProgressHUD.dismiss()
                            }
                        } else {
                            let _ = try data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                            
                            VideoHelper().watermark(videoURL: destinationUrl, outputURL: watermarkedUrl, imageName: "boloindya_watermark", watermarkPosition: .BottomRight) { (status, session, url) in
                                
                                var videoUrl: URL
                                if let url = url, NSData(contentsOf: url) != nil {
                                    videoUrl = url
                                } else {
                                    videoUrl = destinationUrl
                                }
                                
                                let activityController = UIActivityViewController(activityItems: [videoUrl], applicationActivities: nil)
                                activityController.completionWithItemsHandler = { (type, completed, _, error) in
                                    if type == UIActivity.ActivityType.instagram, let instagramUrl = URL(string: "instagram://app"), UIApplication.shared.canOpenURL(instagramUrl) {
                                        UIApplication.shared.open(instagramUrl, options: [:], completionHandler: nil)
                                    }
                                    
                                    if completed {
                                        print("completed")
                                    } else {
                                        print("error")
                                    }
                                }
                                
                                self.present(activityController, animated: true)
                                SVProgressHUD.dismiss()
                            }
                        }
                        
                    } catch {
                        print(error)
                        
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                    }
                    
                    print(error)
                }
            }
        } else {
            SVProgressHUD.dismiss()
        }
        
        let values = ["User Id": object.user?.id ?? 0,
                      "Video Link": object.video_url,
                      "Name": object.user?.name ?? "",
                      "Language": object.languageId,
                      "Username": object.user?.username ?? "",
                      "User Type": object.user?.getUserType() ?? ""] as [String: Any]
        WebEngageHelper.trackEvent(eventName: EventName.sharedVideo, values: values)
    }
    
    func downloadAndShareVideoWhatsapp(with selected_postion: Int) {
        if current_video_cell != nil {
            current_video_cell.player.player?.pause()
            current_video_cell.play_and_pause_image.image = UIImage(named: "play")
        }
        
        shareAndDownload(with: selected_postion)
    }
    
    func likedTopic(with selected_postion: Int) {
        guard videos.count > selected_postion,
              let idInt = Int(videos[selected_postion].id)
            else { return }
        
        self.selected_position = selected_postion
        
        if self.videos[selected_postion].isLiked {
            if let index = topic_liked.firstIndex(of: idInt), topic_liked.count > index {
                topic_liked.remove(at: index)
            }
        } else {
            topic_liked.append(idInt)
        }
        
        UserDefaults.standard.setLikeTopic(value: topic_liked)
        
        videos[selected_postion].isLiked = !videos[selected_postion].isLiked
        
        self.topicLike()
        
        if videos[selected_postion].isLiked {
            hitEvent(eventName: EventName.videoLiked, object: videos[selected_postion])
        }
    }
}

extension TrendingAndFollowingViewController: BICommentViewDelegate {
    func didTapCloseButton() {
        onClickTransparentView()
    }
    
    func didTapSendButton(comment: String?, topic: Topic?) {
        guard let text = comment,
              let topic = topic
            else { return }
        
        let paramters: [String: Any] = [
            "comment": text,
            "topic_id": "\(topic.id)",
            "language_id": "\(UserDefaults.standard.getValueForLanguageId().unsafelyUnwrapped)",
            "gify_details": "{}"
        ]
        
        var headers: HTTPHeaders?
        
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
            headers = ["Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        
        let url = "https://www.boloindya.com/api/v1/reply_on_topic"
        
        AF.request(url, method: .post, parameters: paramters, encoding: URLEncoding.default, headers: headers)
            .responseString { [weak self] (responseData) in
                
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                        do {
                            let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                            if let content = json_object?["comment"] as? [String:Any] {
                                self?.commentsView?.comments.insert(getComment(each: content), at: 0)
                                
                                DispatchQueue.main.async {
                                    self?.commentsView?.commentTable.removeMessage()
                                    self?.commentsView?.commentTable.reloadData()
                                    
                                    if let cell = self?.trendingView.visibleCells.first as? VideoCell, let commentString = cell.comment_count.text, let comment = Int(commentString) {
                                        cell.comment_count.text = "\(comment+1)"
                                    }
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    
                case.failure(let error):
                    print(error)
                }
        }
        
        hitEvent(eventName: EventName.videoCommented, object: videos[selected_position])
    }
    
    func didTapLikeComment(isLike: Bool, comment: Comment, topic: Topic?) {
        
        if let idInt = Int(comment.id) {
            if isLike {
                comment_like.append(idInt)
            } else {
                if let index = comment_like.firstIndex(of: idInt), comment_like.count > index {
                    comment_like.remove(at: index)
                }
            }
            UserDefaults.standard.setLikeComment(value: comment_like)
        }
        
        let paramters: [String: Any] = [
            "comment_id": "\(comment.id)"
        ]
        
        var headers: HTTPHeaders?
        
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
            headers = ["Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        
        let url = "https://www.boloindya.com/api/v1/like/"
        
        AF.request(url, method: .post, parameters: paramters, encoding: URLEncoding.default, headers: headers)
            .responseString  { (responseData) in
                
            }
    }
}

extension TrendingAndFollowingViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
}

extension TrendingAndFollowingViewController: BIReportViewControllerDelegate {
    func didTapDismissButton() {
        reportViewController?.dismiss(animated: true, completion: {
            self.reportViewController = nil
        })
        current_video_cell.player.player?.play()
    }
    
    func didTapSubmit(text: String, object: BIReportResult, video: Topic?) {
        guard let videoId = video?.id else { return }
        
        SVProgressHUD.show()
        
        var headers: HTTPHeaders?
        if let token = UserDefaults.standard.getAuthToken(), !token.isEmpty {
            headers = ["Authorization": "Bearer \(token)"]
        }
        
        let paramters: [String: Any] = [
            "report": "\(object.id)",
            "description": text
        ]
        
        let url = "https://www.boloindya.com/api/v2/video/\(videoId)/report/"
        
        AF.request(url, method: .post, parameters: paramters, encoding: URLEncoding.default, headers: headers)
            .responseString { [weak self] (responseData) in
                SVProgressHUD.dismiss()
                
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                        do {
                            let _ = try
                                JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                            
                            self?.reportViewController?.dismiss(animated: true, completion: {
                                self?.reportViewController = nil
                            })
                            self?.current_video_cell.player.player?.play()
                            
                            self?.showToast(message: "Video Reported Successfully")
                            return
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    print(error)
                }
                
                self?.showToast(message: "Something went wrong. Please try again.")
            }
    }
}
