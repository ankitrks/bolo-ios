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
import SVProgressHUD

class VideoViewController: UIViewController {
    
    var videos: [Topic] = []
    var videoView = UITableView()
    var go_back =  UIImageView()
    
    var selected_position = 0
    var isLoaded: Bool = false
    var self_user: Bool = false
    var topic_id = ""
    
    var current_video_cell: VideoCell!
    
    var topic_liked: [Int] = []
    var comment_like: [Int] = []
    
    var avPlayer = AVPlayer()
    
    var commentsView: BICommentView?
    var reportViewController: BIReportViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        topic_liked = UserDefaults.standard.getLikeTopic()
        comment_like = UserDefaults.standard.getLikeComment()
        
        setVideoViewDelegate()
        
        if let object = self.videos.first {
            hitEvent(eventName: EventName.videoPlayed, object: object)
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
        go_back.topAnchor.constraint(equalTo: self.view.topAnchor, constant: getStatusBarHeight()+10).isActive = true
        
        go_back.image = UIImage(named: "close_white")
        
        go_back.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goBack(_:)))
        go_back.addGestureRecognizer(tapGesture)
        
        if !topic_id.isEmpty {
            self.videoView.isHidden = true
            fetchVideoBytes()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if current_video_cell != nil {
            current_video_cell.player.player?.pause()
        }
    }
    
    @objc func onClickTransparentView (_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve, animations: {
            self.commentsView?.frame.origin.y = self.view.bounds.height
            self.commentsView?.layoutIfNeeded()
        }, completion: { _ in
            self.commentsView?.removeFromSuperview()
            self.commentsView = nil
        })
        
        current_video_cell.player.player?.play()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ProfileViewController {
            let vc = segue.destination as? ProfileViewController
            vc?.user = videos[selected_position].user
        }
    }
    
    func onClickTransparentView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve, animations: {
            self.commentsView?.frame.origin.y = self.view.bounds.height
            self.commentsView?.layoutIfNeeded()
        }, completion: { _ in
            self.commentsView?.removeFromSuperview()
            self.commentsView = nil
        })
        
        current_video_cell.player.player?.play()
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
    
    
    func playVideo() {
        guard let videoUrl = URL(string: videos[selected_position].video_url) else { return }
        
        let mimeType = "video/mp4; codecs=\"avc1.42E01E, mp4a.40.2\""
        let asset = AVURLAsset(url: videoUrl, options:["AVURLAssetOutOfBandMIMETypeKey": mimeType])
        let playerItem = AVPlayerItem(asset: asset)
        
        avPlayer = AVPlayer(playerItem: playerItem)
        avPlayer.addObserver(self, forKeyPath: "status", options: [.old, .new], context: nil)
        
        if #available(iOS 10.0, *) {
            avPlayer.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        } else {
            avPlayer.addObserver(self, forKeyPath: "rate", options: [.old, .new], context: nil)
        }
        
        if current_video_cell != nil {
            current_video_cell.player.playerLayer.player = avPlayer
        }
        
        avPlayer.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main, using: { (CMTime) -> Void in
            let time: Float64 = CMTimeGetSeconds(self.avPlayer.currentTime())
            
            if self.current_video_cell != nil {
                self.current_video_cell.playerSlider.value = Float(time)
                self.current_video_cell.playerSlider.minimumValue = 0
                self.current_video_cell.playerSlider.maximumValue = Float(CMTimeGetSeconds( (self.avPlayer.currentItem?.asset.duration)!))
                let durationTime = Int(time)
                self.current_video_cell.duration.text = String(format: "%02d:%02d", durationTime/60 , durationTime % 60)
            }
        })
        
        topicSeen()
    }
    
    @objc func playerSlider() {
       if current_video_cell != nil {
           print(current_video_cell.playerSlider.value)
           let seekTime = CMTime(value: Int64(current_video_cell.playerSlider.value), timescale: 1)
           avPlayer.seek(to: seekTime)
       }
   }
    
       
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as AnyObject? === avPlayer {
            if keyPath == "status" {
                if avPlayer.status == .readyToPlay {
                    avPlayer.play()
                }
            } else if keyPath == "timeControlStatus" {
                if #available(iOS 10.0, *) {
                    if avPlayer.timeControlStatus == .playing {
                        if current_video_cell != nil {
                            current_video_cell.playerSlider.addTarget(self, action: #selector(playerSlider), for: .valueChanged)
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

extension VideoViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == videoView {
            return videos.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == videoView {
            let video_cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! VideoCell
            if !self.topic_liked.isEmpty {
                if self.topic_liked.contains(Int(videos[indexPath.row].id)!) {
                    videos[indexPath.row].isLiked = true
                }
            }
            video_cell.configure(with: videos[indexPath.row])
            if selected_position == indexPath.row {
                if current_video_cell != nil {
                    current_video_cell.player.player?.pause()
                }
                current_video_cell = video_cell
                self.playVideo()
            }
            if (!self.isLoaded && indexPath.row <= selected_position) {
                if (indexPath.row == selected_position) {
                    print("Position \(selected_position)")
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
            menucell.selected_postion = indexPath.row
            return menucell
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let video_cell = self.videoView.visibleCells.first as? VideoCell else { return }
        
        if current_video_cell != nil {
            current_video_cell.player.player?.pause()
        }
        current_video_cell = video_cell
        selected_position = video_cell.tag
        self.playVideo()
        
        hitEvent(eventName: EventName.videoPlayed, object: videos[selected_position])
    }
    
    private func hitEvent(eventName: String, object: Topic) {
        let values = ["WhatsApp Share Num": object.getCountNum(from: object.whatsapp_share_count),
                      "WhatsApp Share": object.whatsapp_share_count,
                      "Video Id": object.id,
                      "User Id": object.user.id,
                      "Video Link": object.video_url,
                      "Comments": object.comment_count,
                      "Comments Num": object.getCountNum(from: object.comment_count),
                      "Likes": object.like_count,
                      "Likes Num": object.getCountNum(from: object.like_count),
                      "Name": object.user.name,
                      "Shares": object.share_count,
                      "Shares Num": object.getCountNum(from: object.share_count),
                      "Language": object.languageId,
                      "Username": object.user.username,
                      "User Type": object.user.getUserType()] as [String: Any]
        WebEngageHelper.trackEvent(eventName: eventName, values: values)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == videoView {
            return tableView.frame.size.height
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        
        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
            self.fetchData()
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
    func didTapOptions(with selected_postion: Int) {
        current_video_cell.player.player?.pause()
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Report", style: .destructive, handler: { (_) in
            guard self.videos.count > selected_postion else { return }
            
            SVProgressHUD.show()
            
            var headers: [String: Any]?
            if let token = UserDefaults.standard.getAuthToken(), !token.isEmpty {
                headers = ["Authorization": "Bearer \(token)"]
            }
            
            let url = "https://www.boloindya.com/api/v2/report/items/?target=video"
            
            Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: headers as? HTTPHeaders)
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
        self.selected_position = selected_postion
        if current_video_cell != nil {
            current_video_cell.player.player?.pause()
            current_video_cell.play_and_pause_image.image = UIImage(named: "play")
        }
        
        commentsView = BICommentView.fromNib()
        let y = view.bounds.height - 350
        let frame = CGRect(x: 0, y: y, width: view.bounds.width, height: 350)
        if videos.count > selected_position {
            commentsView?.config(topic: videos[selected_position], originalFrame: frame, viewController: self, delegate: self, type: .videoView)
        }
        self.view.addSubview(commentsView!)
        
        commentsView?.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: 350)
        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve, animations: {
            self.commentsView?.frame.origin.y = frame.origin.y
            self.commentsView?.layoutIfNeeded()
        }, completion: nil)
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
        
        if FileManager().fileExists(atPath: destinationUrl.path) {
            SVProgressHUD.dismiss()
            
            let activityController = UIActivityViewController(activityItems: [destinationUrl], applicationActivities: nil)
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
            
            Alamofire.request(videoUrl).downloadProgress(closure: { (progress) in
                let fraction = progress.fractionCompleted
                let percent = Int(fraction * 100)
                SVProgressHUD.showProgress(Float(fraction), status: "Downloading... \(percent)%")
            }).responseData{ (response) in
                if let data = response.result.value {
                    do {
                        if isDownloadUrlAvailable {
                            let _ = try data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                            
                            DispatchQueue.main.async {
                                let activityController = UIActivityViewController(activityItems: [destinationUrl], applicationActivities: nil)
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
                            
                            if FileManager().fileExists(atPath: watermarkedUrl.path) {
                                do {
                                    try FileManager().removeItem(atPath: watermarkedUrl.path)
                                } catch {
                                    print(error)
                                }
                            }
                        } else {
                            if FileManager().fileExists(atPath: watermarkedUrl.path) {
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
                                    
                                    DispatchQueue.main.async {
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
                                    
                                    if FileManager().fileExists(atPath: destinationUrl.path) {
                                        do {
                                            try FileManager().removeItem(atPath: destinationUrl.path)
                                        } catch {
                                            print(error)
                                        }
                                    }
                                }
                            }
                        }
                        
                    } catch {
                        print(error)
                        
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                    }
                }
            }
        } else {
            SVProgressHUD.dismiss()
        }
        
        let values = ["User Id": object.user.id,
                      "Video Link": object.video_url,
                      "Name": object.user.name,
                      "Language": object.languageId,
                      "Username": object.user.username,
                      "User Type": object.user.getUserType()] as [String: Any]
        WebEngageHelper.trackEvent(eventName: EventName.sharedVideo, values: values)
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

extension VideoViewController: BICommentViewDelegate {
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
        
        var headers: [String: Any]? = nil
        
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
            headers = ["Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        
        let url = "https://www.boloindya.com/api/v1/reply_on_topic"
        
        Alamofire.request(url, method: .post, parameters: paramters, encoding: URLEncoding.default, headers: headers as? HTTPHeaders)
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
                                    
                                    if let cell = self?.videoView.visibleCells.first as? VideoCell, let commentString = cell.comment_count.text, let comment = Int(commentString) {
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


extension VideoViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
}

extension VideoViewController: BIReportViewControllerDelegate {
    func didTapDismissButton() {
        reportViewController?.dismiss(animated: true, completion: {
            self.reportViewController = nil
        })
    }
    
    func didTapSubmit(text: String, object: BIReportResult, video: Topic?) {
        guard let videoId = video?.id else { return }
        
        SVProgressHUD.show()
        
        var headers: [String: Any]?
        if let token = UserDefaults.standard.getAuthToken(), !token.isEmpty {
            headers = ["Authorization": "Bearer \(token)"]
        }
        
        let paramters: [String: Any] = [
            "report": "\(object.id)",
            "description": text
        ]
        
        let url = "https://www.boloindya.com/api/v2/video/\(videoId)/report/"
        
        Alamofire.request(url, method: .post, parameters: paramters, encoding: URLEncoding.default, headers: headers as? HTTPHeaders)
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
