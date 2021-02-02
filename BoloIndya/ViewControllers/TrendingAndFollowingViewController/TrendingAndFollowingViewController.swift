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
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.showsVerticalScrollIndicator = false
            tableView.isPagingEnabled = true
            tableView.separatorStyle = .none
            
            tableView.register(cellType: BIVideoCell.self)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.prefetchDataSource = self
        }
    }
    
    @IBOutlet private weak var trendingFollowingView: UIView!
    @IBOutlet private weak var trendingFollowingStackView: UIStackView!
    @IBOutlet private weak var trendingLabel: UILabel! {
        didSet {
            trendingLabel.textColor = UIColor(hex: "10A5F9")
            
            trendingLabel.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeToTrending(_:)))
            trendingLabel.addGestureRecognizer(tapGesture)
        }
    }
    @IBOutlet private weak var followingLabel: UILabel! {
        didSet {
            followingLabel.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeToFollowing(_:)))
            followingLabel.addGestureRecognizer(tapGesture)
        }
    }
    
    var videos: [Topic] = []
    var trendingTopics: [Topic] = []
    var followingTopics: [Topic] = []
    var page: Int = 1
    var following_page: Int = 1
    var isLoading: Bool = false
    var isTrending: Bool = true
    var selected_position = 0
    var label = UILabel()
    var progress = UIActivityIndicatorView()
    var transparentView = UIView()
    
    var video_url: URL!
    var topic_liked: [Int] = []
    var comment_like: [Int] = []
    
    var current_video_cell: BIVideoCell!
    let screenSize = UIScreen.main.bounds
    var deviceHeight:CGFloat = 100.0
    
    var commentsView: BICommentView?
    var reportViewController: BIReportViewController?
    var gaanaOfferViewController: BIGaanaOfferViewController?
    
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
        
        
        trendingFollowingView.translatesAutoresizingMaskIntoConstraints = false
        trendingFollowingView.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 0).isActive = true
        trendingFollowingView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        trendingFollowingView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        trendingFollowingView.heightAnchor.constraint(equalToConstant: safeAreaTop+50).isActive = true
        
        trendingFollowingStackView.translatesAutoresizingMaskIntoConstraints = false
        trendingFollowingStackView.bottomAnchor.constraint(equalTo: trendingFollowingView.bottomAnchor, constant: 10).isActive = true
//        trendingFollowingStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        trendingFollowingStackView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            let gradient = CAGradientLayer()
            gradient.colors = [UIColor.black.withAlphaComponent(0.8).cgColor,
                               UIColor.clear.cgColor]
            gradient.locations = [0.0, 1.0]
            gradient.frame = self.trendingFollowingView.bounds
            self.trendingFollowingView.layer.insertSublayer(gradient, at: 0)
        }
        
//        tabBarController?.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(showGaanaOfferView), name: .init("showGaanaOfferView"), object: nil)
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

//            current_video_cell.player.player?.play()
//            current_video_cell.play_and_pause_image.image = UIImage(named: "pause")
        }
        
        for cell in tableView.visibleCells {
            (cell as? BIVideoCell)?.play()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if current_video_cell != nil {
            current_video_cell.pause()
        }
        
        for cell in tableView.visibleCells {
            (cell as? BIVideoCell)?.pause()
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
        view.addSubview(progress)
        
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        progress.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        progress.color = UIColor.white
    }
    
    @objc func changeToFollowing(_ sender: UITapGestureRecognizer) {
        if isLogin() {
            if (isTrending) {
                followingLabel.textColor = UIColor(hex: "10A5F9")
                trendingLabel.textColor = UIColor.white
                if current_video_cell != nil {
                    current_video_cell.pause()
                }
                self.videos = self.followingTopics
                self.tableView.backgroundColor = UIColor.black
                //                self.trendingView.isUserInteractionEnabled = true
                self.tableView.reloadData()
                if (self.videos.count == 0) {
                    self.fetchFollowingData()
                }
                
                if !self.videos.isEmpty {
                    let cell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? BIVideoCell
                    cell?.play()
                    self.topicSeen()
                    
                    if videos.count > selected_position {
                        hitEvent(eventName: EventName.videoPlayed, object: videos[selected_position])
                    }
                }
                isTrending = false
            }
        }
    }
    
    @objc func changeToTrending(_ sender: UITapGestureRecognizer) {
        if (!isTrending) {
            trendingLabel.textColor = UIColor(hex: "10A5F9")
            followingLabel.textColor = UIColor.white
            if current_video_cell != nil {
                current_video_cell.pause()
            }
            self.videos = self.trendingTopics
            self.tableView.reloadData()
            isTrending = true
            
            if !self.videos.isEmpty {
                let cell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? BIVideoCell
                cell?.play()
                self.topicSeen()
                
                if videos.count > selected_position {
                    hitEvent(eventName: EventName.videoPlayed, object: videos[selected_position])
                }
            }
        }
    }
    
    @objc private func showGaanaOfferView() {
        var headers: HTTPHeaders? = nil
        
        if let token = UserDefaults.standard.getAuthToken(), !token.isEmpty {
            headers = ["Authorization": "Bearer \(token)"]
        }
        
        let url = "https://www.boloindya.com/api/v1/marketing/brand-partner/gaana/coupon/"
        AF.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseString { [weak self] (responseData) in
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                        
                        do {
                            let object = try JSONDecoder().decode(BIGaanaOfferModel.self, from: json_data)
                            print(object)
                            
                            let vc = BIGaanaOfferViewController.loadFromNib()
                            vc.config(model: object)
                            vc.delegate = self
                            vc.modalPresentationStyle = .overCurrentContext
                            vc.modalTransitionStyle = .crossDissolve
                            self?.present(vc, animated: true, completion: nil)
                            
                            self?.gaanaOfferViewController = vc
                            
                            if let cells = self?.tableView.visibleCells {
                                for cell in cells {
                                    (cell as? BIVideoCell)?.pause()
                                }
                            }
                            
                            self?.current_video_cell?.pause()
                        } catch {
                            print(error)
                        }
                    }
                case.failure(let error):
                    print(error)
                }
        }
    }
    
    func fetchFollowingData() {
        
        if isLoading {
            return
        }
        
        if (following_page == 1) {
            tableView.isHidden = true
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
                                self.tableView.isHidden = false
                                self.progress.stopAnimating()
                                self.progress.isHidden = true
                                self.videos = self.followingTopics
                                self.isLoading = false
                                self.following_page += 1
                                self.tableView.reloadData()
                                
                                if self.page == 2, let object = self.followingTopics.first {
                                    self.hitEvent(eventName: EventName.videoPlayed, object: object)
                                }
                                
                                if self.page == 2, !self.videos.isEmpty {
                                    let cell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? BIVideoCell
                                    cell?.play()
                                    self.topicSeen()
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
            tableView.isHidden = true
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
            .responseString { [weak self] (responseData) in
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                        
                        do {
                            let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                            
                            var topics = [Topic]()
                            
                            if let content = json_object?["topics"] as? [[String:Any]] {
                                for each in content {
                                    topics.append(getTopicFromJson(each: each))
                                }
                            }
                            self?.trendingTopics = topics
                            self?.progress.stopAnimating()
                            self?.tableView.isHidden = false
                            self?.progress.isHidden = true
                            self?.videos.append(contentsOf: topics)
                            self?.isLoading = false
                            self?.page += 1
                            self?.tableView.reloadData()
                            UserDefaults.standard.setLastUpdateTime(value: "\(Date().currentTimeMillis())")
                            
                            if self?.page == 2, let object = self?.trendingTopics.first {
                                self?.hitEvent(eventName: EventName.videoPlayed, object: object)
                            }
                            
                            if self?.page == 2, self?.videos.isEmpty == false {
                                if let statusBarHeight = self?.getStatusBarHeight() {
                                    self?.tableView.contentInset = UIEdgeInsets.init(top: -statusBarHeight, left: 0, bottom: 0, right: 0)
                                }
                                
                                let ip = IndexPath(row: 0, section: 0)
                                let cell = self?.tableView.cellForRow(at: ip) as? BIVideoCell
                                cell?.play()
                                self?.topicSeen()
                            }
                        } catch {
                            self?.isLoading = false
                            self?.progress.stopAnimating()
                            self?.progress.isHidden = true
                            print(error)
                        }
                    }
                case.failure(let error):
                    self?.isLoading = false
                    self?.progress.stopAnimating()
                    self?.progress.isHidden = true
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
        
        current_video_cell.play()
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
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension TrendingAndFollowingViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        
        if lastRowIndex > 5, indexPath.row > (lastRowIndex - 5) {
            self.fetchData()
        } else if indexPath.row == lastRowIndex {
            fetchData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let video_cell = tableView.dequeueReusableCell(with: BIVideoCell.self, for: indexPath)
        
        if videos.count > indexPath.row {
            if !topic_liked.isEmpty, let id = Int(videos[indexPath.row].id), topic_liked.contains(id) {
                videos[indexPath.row].isLiked = true
            }
            
            video_cell.configure(topic: videos[indexPath.row])
            video_cell.selected_postion = indexPath.row
            video_cell.tag = indexPath.row
            video_cell.delegate = self
            
            selected_position = indexPath.row
            
            current_video_cell = video_cell
        }

        return video_cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? BIVideoCell)?.pause()
        (cell as? BIVideoCell)?.playerView?.removeFromSuperview()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in tableView.visibleCells {
            guard let videoCell = (cell as? BIVideoCell) else { continue }

            videoCell.pause()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in tableView.visibleCells {
            guard let videoCell = (cell as? BIVideoCell) else { continue }

            if let indexPath = tableView.indexPath(for: videoCell) {
                let cellRect = tableView.rectForRow(at: indexPath)
                let superview = tableView.superview

                let convertedRect = tableView.convert(cellRect, to: superview)
                let intersect = tableView.frame.intersection(convertedRect)
                let visibleHeight = intersect.height

                if visibleHeight > 400 {
                    videoCell.play()
                    topicSeen()
                    
                    if videos.count > selected_position {
                        hitEvent(eventName: EventName.videoPlayed, object: videos[selected_position])
                    }
                    
                } else {
                    videoCell.pause()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == self.tableView) {
            selected_position = indexPath.row
        } else {
            tableView.deselectRow(at: indexPath, animated: false)
        }
        
        onClickTransparentView()
    }
}

extension TrendingAndFollowingViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        var urls = [URL]()
        for indexpath in indexPaths {
            guard videos.count > indexpath.row else { continue }
            
            if let urlString = videos[indexpath.row].user?.profile_pic, let url = URL(string: urlString) {
                urls.append(url)
            }
            
            if let url = URL(string: videos[indexpath.row].thumbnail) {
                urls.append(url)
            }
        }
        
        ImagePrefetcher(urls: urls).start()
    }
}

extension TrendingAndFollowingViewController: VideoCellDelegate {
    func goToAudioSelect(with selected_postion: Int) {
        guard videos.count > selected_postion else { return }
        
        current_video_cell.pause()
        
        let vc = BIAudioSelectViewController.loadFromNib()
        vc.music = videos[selected_postion].music
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapOptions(with selected_postion: Int) {
        current_video_cell.pause()
        
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
            self.current_video_cell.play()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func didTapPlayer() {
        onClickTransparentView()
    }

    func renderComments(with selected_postion: Int) {
        current_video_cell?.pause()
        
        if isLogin() {
            self.selected_position = selected_postion
            if current_video_cell != nil {
                current_video_cell.pause()
//                current_video_cell.play_and_pause_image.image = UIImage(named: "play")
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
        
        current_video_cell?.pause()
        
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
                
                self.current_video_cell.play()
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
                                    
                                    self.current_video_cell.play()
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
                                    
                                    self.current_video_cell.play()
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
                                    
                                    if let cell = self?.tableView.visibleCells.first as? BIVideoCell, let commentString = cell.commentLabel.text, let comment = Int(commentString) {
                                        cell.commentLabel.text = "\(comment+1)"
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
    func didTapSubmit(object: BIReportResult) {
        
    }
    
    func didTapDismissButton() {
        reportViewController?.dismiss(animated: true, completion: {
            self.reportViewController = nil
        })
        current_video_cell.play()
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
                            self?.current_video_cell.play()
                            
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

extension TrendingAndFollowingViewController: BIGaanaOfferViewControllerDelegate {
    func didTapGaanaOfferCloseButton() {
        gaanaOfferViewController?.dismiss(animated: true, completion: nil)
        gaanaOfferViewController = nil
        
        for cell in tableView.visibleCells {
            (cell as? BIVideoCell)?.play()
        }
    }
    
    func didTapGaanaOfferCopyCodeButton(model: BIGaanaOfferModel?) {
        guard let coupon = model?.coupon, !coupon.isEmpty else { return }
        
        UIPasteboard.general.string = coupon
        
        showToast(message: "Copied to clipboard")
    }
}
