//
//  SearchViewController.swift
//  BoloIndya
//
//  Created by apple on 8/8/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController {
    
    var search_text = ""
    
    var user_id: Int = 0
    var userView = UITableView()
    var hashTagView = UITableView()
    
    var users: [User] = []
    var hashTags: [HashTag] = []
    var isLoading: Bool = false
    var isAtEnd: Bool = false
    var isLoadingHash = false
    var isAtEndHash = false
    var isLoadingVideo = false
    var isAtEndVideo = false
    var selected_position: Int = 0
    var selected_hash_position: Int = 0
    var selected_video: Int = 0
    var user_page = 1
    var hash_page = 1
    var videos_page = 1
    
    var users_following: [Int] = []
    var id = ""
    
    var search_text_all = UITextField()
    var back_image = UIImageView()
    
    var videoView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    var topic_liked: [Int] = []
    var topics: [Topic] = []
    
    var serach_upper_tab = UIView()
    var videos_label = UILabel()
    var users_label = UILabel()
    var hash_label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        users_following = UserDefaults.standard.getFollowingUsers()
        topic_liked = UserDefaults.standard.getLikeTopic()
        
        let screenSize = UIScreen.main.bounds.size
        
        view.addSubview(userView)
        view.addSubview(hashTagView)
        view.addSubview(videoView)
        view.addSubview(search_text_all)
        view.addSubview(back_image)
        
        serach_upper_tab.addSubview(videos_label)
        serach_upper_tab.addSubview(users_label)
        serach_upper_tab.addSubview(hash_label)
        
        view.addSubview(serach_upper_tab)
        
        back_image.translatesAutoresizingMaskIntoConstraints = false
        back_image.heightAnchor.constraint(equalToConstant: 25).isActive = true
        back_image.widthAnchor.constraint(equalToConstant: 40).isActive = true
        back_image.topAnchor.constraint(equalTo: self.view.topAnchor, constant: getStatusBarHeight()+10).isActive = true
        back_image.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        
        back_image.image = UIImage(named: "back")
        back_image.contentMode = .scaleAspectFit
        
        back_image.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goBack(_:)))
        back_image.addGestureRecognizer(tapGesture)
        
        search_text_all.translatesAutoresizingMaskIntoConstraints = false
        search_text_all.heightAnchor.constraint(equalToConstant: 25).isActive = true
        search_text_all.topAnchor.constraint(equalTo: self.view.topAnchor, constant: getStatusBarHeight()+10).isActive = true
        search_text_all.leftAnchor.constraint(equalTo: self.back_image.rightAnchor, constant: 10).isActive = true
        search_text_all.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        search_text_all.layer.cornerRadius = 10.0
        search_text_all.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.8470588235)
        
        search_text_all.textColor = UIColor.white
        search_text_all.placeholder = "Search"
        search_text_all.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        search_text_all.text = search_text
        search_text_all.font = UIFont.boldSystemFont(ofSize: 12.0)
        search_text_all.delegate = self
        
        serach_upper_tab.translatesAutoresizingMaskIntoConstraints = false
        serach_upper_tab.heightAnchor.constraint(equalToConstant: 30).isActive = true
        serach_upper_tab.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        serach_upper_tab.topAnchor.constraint(equalTo: search_text_all.bottomAnchor, constant: 10).isActive = true
        
        serach_upper_tab.backgroundColor = UIColor.white
        
        videos_label.translatesAutoresizingMaskIntoConstraints = false
        videos_label.heightAnchor.constraint(equalToConstant: 11).isActive = true
        videos_label.widthAnchor.constraint(equalToConstant: screenSize.width/3 - 10).isActive = true
        videos_label.leftAnchor.constraint(equalTo: serach_upper_tab.leftAnchor, constant: 5).isActive = true
        videos_label.centerYAnchor.constraint(equalTo: serach_upper_tab.centerYAnchor, constant: 0).isActive = true
        videos_label.textColor = UIColor.red
        
        videos_label.font = UIFont.boldSystemFont(ofSize: 10.0)
        videos_label.text = "Videos"
        videos_label.textAlignment = .center
        
        videos_label.isUserInteractionEnabled = true
        let tapGestureVideo = UITapGestureRecognizer(target: self, action: #selector(showVideo(_:)))
        videos_label.addGestureRecognizer(tapGestureVideo)
        
        users_label.translatesAutoresizingMaskIntoConstraints = false
        users_label.heightAnchor.constraint(equalToConstant: 11).isActive = true
        users_label.widthAnchor.constraint(equalToConstant: screenSize.width/3 - 10).isActive = true
        users_label.leftAnchor.constraint(equalTo: videos_label.rightAnchor, constant: 5).isActive = true
        users_label.centerYAnchor.constraint(equalTo: serach_upper_tab.centerYAnchor, constant: 0).isActive = true
        users_label.textColor = UIColor.gray
        users_label.textAlignment = .center
        
        users_label.font = UIFont.boldSystemFont(ofSize: 10.0)
        users_label.text = "User"
        
        users_label.isUserInteractionEnabled = true
        let tapGestureUser = UITapGestureRecognizer(target: self, action: #selector(showUser(_:)))
        users_label.addGestureRecognizer(tapGestureUser)
        
        hash_label.translatesAutoresizingMaskIntoConstraints = false
        hash_label.heightAnchor.constraint(equalToConstant: 11).isActive = true
        hash_label.widthAnchor.constraint(equalToConstant: screenSize.width/3 - 10).isActive = true
        hash_label.leftAnchor.constraint(equalTo: users_label.rightAnchor, constant: 5).isActive = true
        hash_label.centerYAnchor.constraint(equalTo: serach_upper_tab.centerYAnchor, constant: 0).isActive = true
        hash_label.textColor = UIColor.gray
        hash_label.textAlignment = .center
        
        hash_label.font = UIFont.boldSystemFont(ofSize: 10.0)
        hash_label.text = "HashTags"
        
        hash_label.isUserInteractionEnabled = true
        let tapGestureHash = UITapGestureRecognizer(target: self, action: #selector(showHash(_:)))
        hash_label.addGestureRecognizer(tapGestureHash)
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        userView.isScrollEnabled = true
        userView.separatorStyle = .none
        userView.delegate = self
        userView.dataSource = self
        userView.register(FollowerViewCell.self, forCellReuseIdentifier: "Cell")
        userView.backgroundColor = .black
        
        userView.translatesAutoresizingMaskIntoConstraints = false
        userView.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        userView.topAnchor.constraint(equalTo: serach_upper_tab.bottomAnchor, constant: 10).isActive = true
        userView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        userView.isHidden = true
        
        hashTagView.isScrollEnabled = true
        hashTagView.separatorStyle = .none
        hashTagView.delegate = self
        hashTagView.dataSource = self
        hashTagView.register(HashSearchCollectionViewCell.self, forCellReuseIdentifier: "Cell")
        hashTagView.backgroundColor = .black
        
        hashTagView.translatesAutoresizingMaskIntoConstraints = false
        hashTagView.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        hashTagView.topAnchor.constraint(equalTo: serach_upper_tab.bottomAnchor, constant: 10).isActive = true
        hashTagView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        hashTagView.isHidden = true
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: (screenSize.width/3.4), height: (screenSize.width/3.4) * 1.5)
        videoView.collectionViewLayout = layout
        
        videoView.delegate = self
        videoView.dataSource = self
        videoView.backgroundColor = UIColor.clear
        videoView.register(SearchViewVideoCell.self, forCellWithReuseIdentifier: "UserVideoCell")
        self.view.addSubview(videoView)
        
        videoView.translatesAutoresizingMaskIntoConstraints = false
        videoView.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        videoView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        videoView.topAnchor.constraint(equalTo: serach_upper_tab.bottomAnchor, constant: 10).isActive = true
        videoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        fetchVideos()
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func showVideo(_ sender: Any) {
        userView.isHidden = true
        hashTagView.isHidden = true
        
        users_label.textColor = UIColor.gray
        hash_label.textColor = UIColor.gray
        videos_label.textColor = UIColor.red
        
        videoView.isHidden = false
        userView.isHidden = true
        hashTagView.isHidden = true
        
        if topics.count == 0 {
            fetchVideos()
        }
    }
    
    @IBAction func showUser(_ sender: Any) {
        hashTagView.isHidden = true
        videoView.isHidden = true
        
        videos_label.textColor = UIColor.gray
        hash_label.textColor = UIColor.gray
        users_label.textColor = UIColor.red
        
        videoView.isHidden = true
        userView.isHidden = false
        hashTagView.isHidden = true
        
        if users.count == 0 {
            fetchUserData()
        }
    }
    
    @IBAction func showHash(_ sender: Any) {
        userView.isHidden = true
        videoView.isHidden = true
        
        videos_label.textColor = UIColor.gray
        users_label.textColor = UIColor.gray
        hash_label.textColor = UIColor.red
        
        videoView.isHidden = true
        userView.isHidden = true
        hashTagView.isHidden = false
        
        if hashTags.count == 0 {
            fetchHashData()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func fetchUserData() {
        
        if (isLoading || isAtEnd) {
            return
        }
        
        isLoading = true
        
        let url = "https://www.boloindya.com/api/v1/solr/search/users?term=\(search_text)&page=\(user_page)"
        
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseString  { (responseData) in
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                        
                        do {
                            let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                            if let content = json_object?["results"] as? [[String:Any]] {
                                if content.count == 0 {
                                    self.isAtEnd = true
                                }
                                for result in content {
                                    let user = User()
                                    let user_profile_obj = result["userprofile"] as? [String:Any]
                                    
                                    user.id = user_profile_obj?["user"] as! Int
                                    user.setUserName(username: user_profile_obj?["slug"] as? String ?? "")
                                    
                                    user.setName(name: user_profile_obj?["name"] as? String ?? "")
                                    user.setBio(bio: user_profile_obj?["bio"] as? String ?? "")
                                    user.setCoverPic(cover_pic: user_profile_obj?["cover_pic"] as? String ?? "")
                                    user.setProfilePic(profile_pic: user_profile_obj?["profile_pic"] as? String ?? "")
                                    user.vb_count = user_profile_obj?["vb_count"] as! Int
                                    user.view_count = user_profile_obj?["view_count"] as! String
                                    if let follow_count = user_profile_obj?["follow_count"] as? Int {
                                        user.follow_count = "\(follow_count)"
                                    } else {
                                        user.follow_count = user_profile_obj?["follow_count"] as! String
                                    }
                                    if let following_count = user_profile_obj?["follower_count"] as? Int {
                                        user.follower_count = "\(following_count)"
                                    } else {
                                        user.follower_count = user_profile_obj?["follower_count"] as! String
                                    }
                                    if !self.users_following.isEmpty {
                                        if self.users_following.contains(user.id) {
                                            user.isFollowing = true
                                        } else {
                                            user.isFollowing = false
                                        }
                                    }
                                    self.users.append(user)
                                }
                                self.user_page += 1
                                self.userView.reloadData()
                                self.isLoading = false
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
    
    func fetchHashData() {
        
        if (isLoadingHash || isAtEndHash) {
            return
        }
        
        isLoadingHash = true
        
        let url = "https://www.boloindya.com/api/v1/solr/search/hash_tag?term=\(search_text)&page=\(hash_page)"
        
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseString  { (responseData) in
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                        
                        do {
                            let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                            if let content = json_object?["results"] as? [[String:Any]] {
                                if content.count == 0 {
                                    self.isAtEndHash = true
                                }
                                for result in content {
                                    let each_hash = HashTag()
                                    
                                    each_hash.title = result["hash_tag"] as! String
                                    if let count = (result["total_videos_count"]) {
                                        each_hash.videos_count = "\(count)"
                                    } else {
                                        each_hash.videos_count = result["total_videos_count"] as? String ?? ""
                                    }
                                    if let count = (result["total_views"]) {
                                        each_hash.total_views = "\(count)"
                                    } else {
                                        each_hash.total_views = result["total_views"] as? String ?? ""
                                    }
                                    each_hash.image = result["picture"] as? String ?? ""
                                    self.hashTags.append(each_hash)
                                }
                                self.hash_page += 1
                                self.hashTagView.reloadData()
                                self.isLoadingHash = false
                            }
                        }
                        catch {
                            self.isLoadingHash = false
                            print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    self.isLoadingHash = false
                    print(error)
                }
        }
    }
    
    func fetchVideos() {
        
        if (isLoadingVideo || isAtEndVideo) {
            return
        }
        
        isLoadingVideo = true
        
        let url = "https://www.boloindya.com/api/v1/solr/search/?term=\(search_text)&language_id=\(UserDefaults.standard.getValueForLanguageId().unsafelyUnwrapped)&page=\(videos_page)"
        
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseString  { (responseData) in
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                        
                        do {
                            let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                            if let content = json_object?["results"] as? [[String:Any]] {
                                if content.count == 0 {
                                    self.isAtEndVideo = true
                                }
                                for result in content {
                                    self.topics.append(getTopicFromJson(each: result))
                                }
                                self.videos_page += 1
                                self.videoView.reloadData()
                                self.isLoadingVideo = false
                            }
                        }
                        catch {
                            self.isLoadingVideo = false
                            print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    self.isLoadingVideo = false
                    print(error)
                }
        }
    }
    
    func followingUser() {
        
        let paramters: [String: Any] = [
            "user_following_id": "\(id)"
        ]
        
        var headers: [String: Any]? = nil
        
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
            headers = ["Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        
        let url = "https://www.boloindya.com/api/v1/follow_user/"
        
        Alamofire.request(url, method: .post, parameters: paramters, encoding: URLEncoding.default, headers: headers as? HTTPHeaders)
            .responseString  { (responseData) in
                
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ProfileViewController {
            let vc = segue.destination as? ProfileViewController
            vc?.user = users[selected_position]
        }  else if segue.destination is LoginAndSignUpViewController{
            let vc = segue.destination as? LoginAndSignUpViewController
            vc?.selected_tab = 0
        }  else if segue.destination is HashTagViewController {
            let vc = segue.destination as? HashTagViewController
            vc?.hash_tag = hashTags[selected_hash_position]
        } else if segue.destination is VideoViewController {
            let vc = segue.destination as? VideoViewController
            vc?.videos = topics
            vc?.selected_position = selected_video
        }  else if segue.destination is HashTagViewController {
            let vc = segue.destination as? HashTagViewController
            vc?.hash_tag = hashTags[selected_hash_position]
        }
    }
}


extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == userView {
            return users.count
        } else {
            return hashTags.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == userView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! FollowerViewCell
            cell.configure(with: users[indexPath.row])
            cell.selected_postion = indexPath.row
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! HashSearchCollectionViewCell
            cell.configure(with: hashTags[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == userView {
            return 100
        } else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == userView {
            tableView.deselectRow(at: indexPath, animated: false)
            selected_position = indexPath.row
            self.performSegue(withIdentifier: "searchUser", sender: self)
        } else if tableView == hashTagView {
            tableView.deselectRow(at: indexPath, animated: false)
            selected_hash_position = indexPath.row
            self.performSegue(withIdentifier: "searchHash", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == userView {
            let lastSectionIndex = tableView.numberOfSections - 1
            let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
            
            if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
                fetchUserData()
            }
        } else if tableView == hashTagView {
            let lastSectionIndex = tableView.numberOfSections - 1
            let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
            
            if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
                fetchHashData()
            }
        }
    }
}

extension SearchViewController: FollowerViewCellDelegate {
    func followUser(with selected_postion: Int) {
        let isLoggedIn = UserDefaults.standard.isLoggedIn() ?? false
        if (!isLoggedIn) {
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.isNavigationBarHidden = true
            performSegue(withIdentifier: "searchLogin", sender: self)
            return
        }
        if users[selected_postion].isFollowing {
            users_following.remove(at: users_following.firstIndex(of: self.users[selected_postion].id)!)
        } else {
            users_following.append(self.users[selected_postion].id)
        }
        self.id = "\(self.users[selected_postion].id)"
        users[selected_postion].isFollowing =  !users[selected_postion].isFollowing
        UserDefaults.standard.setFollowingUsers(value: users_following)
        userView.reloadData()
    }
}


extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selected_video = indexPath.row
        self.tabBarController?.tabBar.isHidden = true
        performSegue(withIdentifier: "searchVideo", sender: self)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserVideoCell", for: indexPath) as! SearchViewVideoCell
        if !self.topic_liked.isEmpty {
            if self.topic_liked.contains(Int(self.topics[indexPath.row].id)!) {
                self.topics[indexPath.row].isLiked = true
            }
        }
        cell.configure(with: topics[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/3.4), height: (collectionView.frame.width/3.4) * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == topics.count - 1 {
            self.fetchVideos()
        }
    }
    
}


class SearchViewVideoCell : UICollectionViewCell {
    
    var video_image =  UIImageView()
    var video_title = UILabel()
    
    var views = UILabel()
    var view_image =  UIImageView()
    var likes = UILabel()
    var like_image =  UIImageView()
    var user_name = UILabel()
    var duration = UILabel()
    
    public func configure(with topic: Topic) {
        let url = URL(string: topic.thumbnail)
        video_image.kf.setImage(with: url)
        video_title.text = topic.title.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        
        views.text = topic.view_count
        view_image.image = UIImage(named: "views")
        
        likes.text = topic.like_count
        like_image.image = UIImage(named: "heart_non_filled")
        if topic.isLiked {
            like_image.image = UIImage(named: "like")
            like_image.image = like_image.image?.withRenderingMode(.alwaysTemplate)
            like_image.tintColor = UIColor.red
        }
        user_name.text = topic.user.username
        duration.text = topic.duration
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(video_image)
        addSubview(video_title)
        
        addSubview(views)
        addSubview(view_image)
        addSubview(likes)
        addSubview(like_image)
        addSubview(duration)
        addSubview(user_name)
        
        setImageView()
        setVideoTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImageView() {
        video_image.translatesAutoresizingMaskIntoConstraints = false
        video_image.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        video_image.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        video_image.layer.cornerRadius = 2.0
        video_image.contentMode = .scaleAspectFill
        video_image.clipsToBounds = true
        video_image.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.8470588235)
    }
    
    func setVideoTitle() {
        
        view_image.translatesAutoresizingMaskIntoConstraints = false
        view_image.heightAnchor.constraint(equalToConstant: 11).isActive = true
        view_image.widthAnchor.constraint(equalToConstant: 11).isActive = true
        view_image.leftAnchor.constraint(equalTo: leftAnchor, constant: 3).isActive = true
        view_image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        
        view_image.layer.cornerRadius = 2.0
        view_image.contentMode = .scaleAspectFill
        view_image.clipsToBounds = true
        
        views.translatesAutoresizingMaskIntoConstraints = false
        views.heightAnchor.constraint(equalToConstant: 11).isActive = true
        views.widthAnchor.constraint(equalToConstant: 40).isActive = true
        views.leftAnchor.constraint(equalTo: view_image.rightAnchor, constant: 2).isActive = true
        views.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        views.textColor = UIColor.white
        
        views.font = UIFont.boldSystemFont(ofSize: 9.0)
        views.numberOfLines = 1
        
        like_image.translatesAutoresizingMaskIntoConstraints = false
        like_image.heightAnchor.constraint(equalToConstant: 11).isActive = true
        like_image.widthAnchor.constraint(equalToConstant: 11).isActive = true
        like_image.rightAnchor.constraint(equalTo: rightAnchor, constant: -2).isActive = true
        like_image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        
        like_image.layer.cornerRadius = 2.0
        like_image.contentMode = .scaleAspectFill
        like_image.clipsToBounds = true
        
        likes.translatesAutoresizingMaskIntoConstraints = false
        likes.heightAnchor.constraint(equalToConstant: 11).isActive = true
        likes.widthAnchor.constraint(equalToConstant: 40).isActive = true
        likes.rightAnchor.constraint(equalTo: like_image.leftAnchor, constant: -2).isActive = true
        likes.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        likes.textColor = UIColor.white
        
        likes.textAlignment = .right
        likes.font = UIFont.boldSystemFont(ofSize: 9.0)
        likes.numberOfLines = 1
        
        
        user_name.translatesAutoresizingMaskIntoConstraints = false
        user_name.heightAnchor.constraint(equalToConstant: 14).isActive = true
        user_name.leftAnchor.constraint(equalTo: leftAnchor, constant: 3).isActive = true
        user_name.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        user_name.bottomAnchor.constraint(equalTo: view_image.topAnchor, constant: 0).isActive = true
        user_name.textColor = UIColor.white
        
        user_name.font = UIFont.boldSystemFont(ofSize: 10.0)
        user_name.numberOfLines = 1
        
        video_title.translatesAutoresizingMaskIntoConstraints = false
        video_title.leftAnchor.constraint(equalTo: leftAnchor, constant: 3).isActive = true
        video_title.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        video_title.bottomAnchor.constraint(equalTo: user_name.topAnchor, constant: 0).isActive = true
        video_title.textColor = UIColor.white
        
        video_title.font = UIFont.boldSystemFont(ofSize: 11.0)
        video_title.numberOfLines = 2
        
        duration.translatesAutoresizingMaskIntoConstraints = false
        duration.heightAnchor.constraint(equalToConstant: 11).isActive = true
        duration.widthAnchor.constraint(equalToConstant: 30).isActive = true
        duration.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        duration.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        duration.textColor = UIColor.white
        
        duration.font = UIFont.boldSystemFont(ofSize: 9.0)
        duration.numberOfLines = 1
        
    }
}

extension SearchViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.search_text_all.resignFirstResponder()
        search_text = "\(search_text_all.text.unsafelyUnwrapped)"
        user_page = 1
        hash_page = 1
        videos_page = 1
        isAtEnd = false
        isAtEndHash = false
        isAtEndVideo = false
        topics.removeAll()
        hashTags.removeAll()
        users.removeAll()
        print(search_text)
        if !videoView.isHidden {
            fetchVideos()
        } else if !userView.isHidden {
            fetchUserData()
        } else if !hashTagView.isHidden {
            fetchHashData()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
}
