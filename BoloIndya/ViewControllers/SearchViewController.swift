//
//  SearchViewController.swift
//  BoloIndya
//
//  Created by apple on 8/8/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: BaseVC {
    
    var search_text = ""
    
    var user_id: Int = 0
    var userView = UITableView()
    var hashTagView = UITableView()
    var videoView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    var users: [User] = []
    var data: [Search] = []
    var hashTags: [HashTag] = []
    var topics: [Topic] = []
    var top_users: [User] = []
    var top_hashTags: [HashTag] = []
    var top_topics: [Topic] = []
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
    
    var topic_liked: [Int] = []
    
    var serach_upper_tab = UIView()
    var top_label = UILabel()
    var videos_label = UILabel()
    var users_label = UILabel()
    var hash_label = UILabel()
    
    var allView = UITableView()
    
    var loader = UIActivityIndicatorView()
    
    var no_result = UILabel()
    
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
        
        serach_upper_tab.addSubview(top_label)
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
        search_text_all.heightAnchor.constraint(equalToConstant: 30).isActive = true
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
        
        let paddingViewFeed = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: search_text_all.frame.height))
        search_text_all.leftView = paddingViewFeed
        search_text_all.leftViewMode = .always
        
        serach_upper_tab.translatesAutoresizingMaskIntoConstraints = false
        serach_upper_tab.heightAnchor.constraint(equalToConstant: 30).isActive = true
        serach_upper_tab.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        serach_upper_tab.topAnchor.constraint(equalTo: search_text_all.bottomAnchor, constant: 10).isActive = true
        
        serach_upper_tab.backgroundColor = UIColor.white
        
        top_label.translatesAutoresizingMaskIntoConstraints = false
        top_label.heightAnchor.constraint(equalToConstant: 11).isActive = true
        top_label.widthAnchor.constraint(equalToConstant: screenSize.width/4 - 10).isActive = true
        top_label.leftAnchor.constraint(equalTo: serach_upper_tab.leftAnchor, constant: 5).isActive = true
        top_label.centerYAnchor.constraint(equalTo: serach_upper_tab.centerYAnchor, constant: 0).isActive = true
        top_label.textColor = UIColor.red
        
        top_label.font = UIFont.boldSystemFont(ofSize: 10.0)
        top_label.text = "All"
        top_label.textAlignment = .center
        
        top_label.isUserInteractionEnabled = true
        let tapGestureAll = UITapGestureRecognizer(target: self, action: #selector(showAll(_:)))
        top_label.addGestureRecognizer(tapGestureAll)
        
        videos_label.translatesAutoresizingMaskIntoConstraints = false
        videos_label.heightAnchor.constraint(equalToConstant: 11).isActive = true
        videos_label.widthAnchor.constraint(equalToConstant: screenSize.width/4 - 10).isActive = true
        videos_label.leftAnchor.constraint(equalTo: top_label.rightAnchor, constant: 5).isActive = true
        videos_label.centerYAnchor.constraint(equalTo: serach_upper_tab.centerYAnchor, constant: 0).isActive = true
        videos_label.textColor = UIColor.gray
        
        videos_label.font = UIFont.boldSystemFont(ofSize: 10.0)
        videos_label.text = "Videos"
        videos_label.textAlignment = .center
        
        videos_label.isUserInteractionEnabled = true
        let tapGestureVideo = UITapGestureRecognizer(target: self, action: #selector(showVideo(_:)))
        videos_label.addGestureRecognizer(tapGestureVideo)
        
        users_label.translatesAutoresizingMaskIntoConstraints = false
        users_label.heightAnchor.constraint(equalToConstant: 11).isActive = true
        users_label.widthAnchor.constraint(equalToConstant: screenSize.width/4 - 10).isActive = true
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
        hash_label.widthAnchor.constraint(equalToConstant: screenSize.width/4 - 10).isActive = true
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
        
        videoView.isHidden = true
        
        view.addSubview(allView)
        
        allView.isScrollEnabled = true
        allView.separatorStyle = .none
        allView.delegate = self
        allView.dataSource = self
        allView.register(SearchAll.self, forCellReuseIdentifier: "Cell")
        allView.backgroundColor = .black
        
        allView.translatesAutoresizingMaskIntoConstraints = false
        allView.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        allView.topAnchor.constraint(equalTo: serach_upper_tab.bottomAnchor, constant: 10).isActive = true
        allView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        view.addSubview(loader)
        
        loader.center = self.view.center
        
        loader.color = UIColor.white
        
        view.addSubview(no_result)
        
        no_result.translatesAutoresizingMaskIntoConstraints = false
        no_result.widthAnchor.constraint(equalToConstant: 150).isActive = true
        no_result.heightAnchor.constraint(equalToConstant: 30).isActive = true
        no_result.topAnchor.constraint(equalTo: serach_upper_tab.bottomAnchor, constant: 15).isActive = true
        no_result.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: (screenSize.width/2)-65).isActive = true
        
        no_result.textAlignment = .center
        no_result.text = "No Result Found"
        no_result.textColor = UIColor.white
        no_result.layer.borderWidth = 1
        no_result.font = UIFont.boldSystemFont(ofSize: 12.0)
        no_result.layer.borderColor = UIColor.white.cgColor
        no_result.layer.cornerRadius = 5.0
        no_result.sizeToFit()
        no_result.numberOfLines = 1
        
        no_result.isHidden = true
        
        fetchAllTypes()
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showAll(_ sender: Any) {
        settoDefaultAll()
        top_label.textColor = UIColor.red
        
        allView.isHidden = false
        
        if data.count == 0 {
            fetchAllTypes()
        }
    }
    
    @IBAction func showVideo(_ sender: Any) {
        settoDefaultAll()
        videos_label.textColor = UIColor.red
        
        videoView.isHidden = false
        
        if topics.count == 0 {
            fetchVideos()
        }
    }
    
    @IBAction func showUser(_ sender: Any) {
        settoDefaultAll()
        users_label.textColor = UIColor.red
        
        userView.isHidden = false
        
        if users.count == 0 {
            fetchUserData()
        }
    }
    
    @IBAction func showHash(_ sender: Any) {
        settoDefaultAll()
        
        hash_label.textColor = UIColor.red
        
        hashTagView.isHidden = false
        
        if hashTags.count == 0 {
            fetchHashData()
        }
    }
    
    func settoDefaultAll() {
        no_result.isHidden = true
        
        videos_label.textColor = UIColor.gray
        users_label.textColor = UIColor.gray
        hash_label.textColor = UIColor.gray
        top_label.textColor = UIColor.gray
        
        videoView.isHidden = true
        userView.isHidden = true
        hashTagView.isHidden = true
        allView.isHidden = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func fetchUserData() {
        
        if (isLoading || isAtEnd) {
            return
        }
        
        isLoading = true
        
        let url = "https://www.boloindya.com/api/v1/solr/search/users?term=\(search_text.replacingOccurrences(of: " ", with: "", options: .regularExpression, range: nil))&page=\(user_page)"
        
        
        if user_page == 1 {
            startLoader()
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseString  { (responseData) in
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                        
                        do {
                            let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                            if let content = json_object?["results"] as? [[String:Any]] {
                                if content.count == 0 && self.users.count > 0 {
                                    self.isAtEnd = true
                                }
                                for result in content {
                                    let user = getUserDataFromJson(result: result)
                                    
                                    if !self.users_following.isEmpty {
                                        user.isFollowing = self.users_following.contains(user.id)
                                    }
                                    self.users.append(user)
                                }
                                if self.users.count == 0 {
                                    self.no_result.isHidden = false
                                } else {
                                    self.user_page += 1
                                    self.no_result.isHidden = true
                                }
                                self.stopLoader()
                                self.userView.reloadData()
                                self.isLoading = false
                            }
                        }
                        catch {
                            self.isLoading = false
                            self.stopLoader()
                            print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    self.stopLoader()
                    self.isLoading = false
                    print(error)
                }
        }
    }
    
    func fetchHashData() {
        
        if (isLoadingHash || isAtEndHash) {
            return
        }
        
        if hash_page == 1 {
            startLoader()
        }
        
        isLoadingHash = true
        
        let url = "https://www.boloindya.com/api/v1/solr/search/hash_tag?term=\(search_text.replacingOccurrences(of: " ", with: "", options: .regularExpression, range: nil))&page=\(hash_page)"
        
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseString  { (responseData) in
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                        
                        do {
                            let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                            if let content = json_object?["results"] as? [[String:Any]] {
                                if content.count == 0 && self.hashTags.count > 0 {
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
                                if self.hashTags.count == 0 {
                                    self.no_result.isHidden = false
                                } else {
                                    self.hash_page += 1
                                    self.no_result.isHidden = true
                                }
                                self.stopLoader()
                                self.hashTagView.reloadData()
                                self.isLoadingHash = false
                            }
                        }
                        catch {
                            self.stopLoader()
                            self.isLoadingHash = false
                            print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    self.stopLoader()
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
        
        if videos_page == 1 {
            startLoader()
        }

        let url = "https://www.boloindya.com/api/v1/solr/search/?term=\(search_text.replacingOccurrences(of: " ", with: "+").replacingOccurrences(of: "#", with: "%23"))&language_id=\(UserDefaults.standard.getValueForLanguageId().unsafelyUnwrapped)&page=\(videos_page)"
        print(url)
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseString  { (responseData) in
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                        
                        do {
                            let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                            if let content = json_object?["results"] as? [[String:Any]] {
                                if content.count == 0 && self.topics.count > 0 {
                                    self.isAtEndVideo = true
                                }
                                for result in content {
                                    self.topics.append(getTopicFromJson(each: result))
                                }
                                if self.topics.count == 0 {
                                    self.no_result.isHidden = false
                                } else {
                                    self.videos_page += 1
                                    self.no_result.isHidden = true
                                }
                                self.stopLoader()
                                self.videoView.reloadData()
                                self.isLoadingVideo = false
                            }
                        }
                        catch {
                            self.stopLoader()
                            self.isLoadingVideo = false
                            print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    self.stopLoader()
                    self.isLoadingVideo = false
                    print(error)
                }
        }
    }
    
    func fetchAllTypes() {
        
        let url = "https://www.boloindya.com/api/v1/solr/search/top/?term=\(search_text.replacingOccurrences(of: " ", with: "", options: .regularExpression, range: nil))&language_id=\(UserDefaults.standard.getValueForLanguageId().unsafelyUnwrapped)"
        
        var headers: [String: Any]? = nil
        
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
            headers = [
                "Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        
        startLoader()
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers as? HTTPHeaders)
            .responseString  { (responseData) in
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                        
                        do {
                            let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                            if let content = json_object?["top_vb"] as? [[String:Any]] {
                                for result in content {
                                    let topic = getTopicFromJson(each: result)
                                    if !self.topic_liked.isEmpty {
                                        if self.topic_liked.contains(Int(topic.id)!) {
                                            topic.isLiked = true
                                        }
                                    }
                                    self.top_topics.append(topic)
                                }
                                if self.top_topics.count > 0 {
                                    self.data.append(Search(type: "Videos", data: self.top_topics))
                                }
                            }
                            if let content = json_object?["top_user"] as? [[String:Any]] {
                                for result in content {
                                    let user = getUserDataFromJson(result: result)
                                    
                                    if !self.users_following.isEmpty {
                                        user.isFollowing = self.users_following.contains(user.id)
                                    }
                                    self.top_users.append(user)
                                }
                                if self.top_users.count > 0 {
                                    self.data.append(Search(type: "Users", data: self.top_users))
                                }
                            }
                            if let content = json_object?["top_hash_tag"] as? [[String:Any]] {
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
                                    self.top_hashTags.append(each_hash)
                                }
                                if self.top_hashTags.count > 0 {
                                    self.data.append(Search(type: "HashTags", data: self.top_hashTags))
                                }
                            }
                            if self.data.count == 0 {
                                self.no_result.isHidden = false
                            }else{
                              self.no_result.isHidden = true
                            }
                            self.stopLoader()
                            self.allView.reloadData()
                        }
                        catch {
                            self.stopLoader()
                            print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    self.stopLoader()
                    print(error)
                }
        }
    }
    
    func startLoader() {
        loader.isHidden = false
        loader.startAnimating()
    }
    
    func stopLoader() {
        self.loader.isHidden = true
        self.loader.stopAnimating()
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
            if userView.isHidden {
                vc?.user = top_users[selected_position]
            } else {
                vc?.user = users[selected_position]
            }
        }  else if segue.destination is LoginAndSignUpViewController{
            let vc = segue.destination as? LoginAndSignUpViewController
            vc?.selected_tab = 0
        }  else if segue.destination is HashTagViewController {
            let vc = segue.destination as? HashTagViewController
            if hashTagView.isHidden {
                vc?.hash_tag = top_hashTags[selected_hash_position]
            } else {
                vc?.hash_tag = hashTags[selected_hash_position]
            }
        } else if segue.destination is VideoViewController {
            let vc = segue.destination as? VideoViewController
            if videoView.isHidden {
                vc?.videos = top_topics
            } else {
                vc?.videos = topics
            }
            vc?.selected_position = selected_video
        }
    }
}


extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == userView {
            return users.count
        } else if tableView == allView {
            return data.count
        }  else {
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
        } else if tableView == allView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SearchAll
            cell.configure(with: data[indexPath.row])
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
        } else if tableView == allView {
            if data[indexPath.row].type == "Users" {
                return CGFloat((data[indexPath.row].data.count * 100) + 25)
            } else if data[indexPath.row].type == "Videos" {
                if data[indexPath.row].data.count > 3 {
                    return ((((tableView.frame.width/3.4) * 1.5) + 25)*2)
                } else {
                    return (((tableView.frame.width/3.4) * 1.5) + 25)
                }
            }
            return CGFloat((data[indexPath.row].data.count * 80)+25)
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
        if (isLogin()){
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
        search_text = "\(search_text_all.text.unsafelyUnwrapped)".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        user_page = 1
        hash_page = 1
        videos_page = 1
        isAtEnd = false
        isAtEndHash = false
        isAtEndVideo = false
        topics.removeAll()
        hashTags.removeAll()
        top_users.removeAll()
        top_topics.removeAll()
        top_hashTags.removeAll()
        users.removeAll()
        data.removeAll()
        videoView.reloadData()
        userView.reloadData()
        hashTagView.reloadData()
        allView.reloadData()
        if !allView.isHidden {
            fetchAllTypes()
        } else if !videoView.isHidden {
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

extension SearchViewController: SearchAllDelegate {
    
    func goToHashTag(with position: Int) {
        selected_hash_position = position
        self.performSegue(withIdentifier: "searchHash", sender: self)
    }
    
    func goToVideos(with position: Int) {
        selected_video = position
        self.tabBarController?.tabBar.isHidden = true
        performSegue(withIdentifier: "searchVideo", sender: self)
    }
    
    func goTopProfile(with position: Int) {
        selected_position = position
        self.performSegue(withIdentifier: "searchUser", sender: self)
    }
    
    
    
}

protocol SearchAllDelegate {
    func goToHashTag(with position: Int)
    
    func goToVideos(with position: Int)
    
    func goTopProfile(with position: Int)
}

class SearchAll: UITableViewCell, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FollowerViewCellDelegate {
    
    func followUser(with selected_postion: Int) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        delegate?.goToVideos(with: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data_point.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserVideoCell", for: indexPath) as! SearchViewVideoCell
        cell.configure(with: data_point.data[indexPath.row] as! Topic)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/3.4), height: (collectionView.frame.width/3.4) * 1.5)
    }
    
    var data_point: Search!
    var delegate: SearchAllDelegate!
    
    var title = UILabel()
    var allTableView = UITableView()
    var allVideoView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    public func configure(with data: Search) {
        self.data_point = data
        self.title.text = data_point.type
        if data_point.type != "Videos" {
            self.allVideoView.isHidden = true
            self.allTableView.isHidden = false
            self.allTableView.reloadData()
        } else {
            self.allTableView.isHidden = true
            self.allVideoView.isHidden = false
            self.allVideoView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        backgroundColor = .black
        
        if data_point.type == "Videos" {
            addSubview(allVideoView)
        } else {
            addSubview(allTableView)
        }
        addSubview(title)
        
        setData()
    }
    
    func setData() {
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.heightAnchor.constraint(equalToConstant: 15).isActive = true
        title.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        title.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        
        title.font = UIFont.boldSystemFont(ofSize: 13.0)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.numberOfLines = 1
        title.textColor = UIColor.white
        
        if  data_point.type != "Videos" {
            
            allTableView.isScrollEnabled = true
            allTableView.separatorStyle = .none
            allTableView.delegate = self
            allTableView.dataSource = self
            if data_point.type == "Users" {
                allTableView.register(FollowerViewCell.self, forCellReuseIdentifier: "Cell")
            } else {
                allTableView.register(HashSearchCollectionViewCell.self, forCellReuseIdentifier: "Cell")
            }
            allTableView.backgroundColor = .black
            
            allTableView.translatesAutoresizingMaskIntoConstraints = false
            allTableView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5).isActive = true
            allTableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
            allTableView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
            allTableView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        }
        
        if  data_point.type == "Videos" {
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            layout.itemSize = CGSize(width: (self.frame.width/3.4), height: ((self.frame.width/3.4) * 1.5))
            allVideoView.collectionViewLayout = layout
            
            allVideoView.delegate = self
            allVideoView.dataSource = self
            allVideoView.backgroundColor = UIColor.clear
            allVideoView.register(SearchViewVideoCell.self, forCellWithReuseIdentifier: "UserVideoCell")
            
            allVideoView.translatesAutoresizingMaskIntoConstraints = false
            allVideoView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5).isActive = true
            allVideoView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
            allVideoView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
            allVideoView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.data_point.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.data_point.type == "Users" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! FollowerViewCell
            cell.configure(with: self.data_point.data[indexPath.row] as! User)
            cell.delegate = self
            cell.selected_postion = indexPath.row
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! HashSearchCollectionViewCell
            cell.configure(with: self.data_point.data[indexPath.row] as! HashTag)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.data_point.type == "Users" {
            return 100
        } else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if self.data_point.type == "Users" {
            delegate?.goTopProfile(with: indexPath.row)
        } else {
            delegate?.goToHashTag(with: indexPath.row)
        }
    }
}
