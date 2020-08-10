//
//  ProfileViewController.swift
//  BoloIndya
//
//  Created by apple on 7/14/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class ProfileViewController: UIViewController {
    
    var name = UILabel()
    
    var bio = UILabel()
    
    var profile_pic =  UIImageView()
    
    var cover_pic = UIImageView()
    
    @IBOutlet weak var upper_tab: UIView!
    
    @IBOutlet weak var user_name: UILabel!
    
    var follow_button = UIButton()
    var users_following: [Int] = []
    
    var user = User()
    
    var selected_position: Int = 0
    var isLoading: Bool = false
    var page: Int = 1
    var topics: [Topic] = []
    var isFinished: Bool = false
    
    var userVideoView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    var videos_label = UILabel()
    var videos_count = UILabel()
    
    var views_label = UILabel()
    var views_count = UILabel()
    
    var followers_label = UILabel()
    var followers_count = UILabel()
    
    var following_label = UILabel()
    var following_count = UILabel()
    
    var isFollowing: Bool = false
    var follower: String = "following"
    
    var isFollowingUser: Bool = false
    var topic_liked: [Int] = []
    
    var loader = UIActivityIndicatorView()
    
    var no_result = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topic_liked = UserDefaults.standard.getLikeTopic()
        
        users_following = UserDefaults.standard.getFollowingUsers()
        
        self.navigationController?.isNavigationBarHidden = true
        cover_pic.backgroundColor = UIColor.gray
        setUserVideoView()
        fetchUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setUserVideoView() {
        
        let screenSize = UIScreen.main.bounds.size
        
        view.addSubview(cover_pic)
        
        cover_pic.translatesAutoresizingMaskIntoConstraints = false
        cover_pic.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        cover_pic.heightAnchor.constraint(equalToConstant: 130).isActive = true
        cover_pic.topAnchor.constraint(equalTo: upper_tab.bottomAnchor, constant: 10).isActive = true
        
        cover_pic.clipsToBounds = true
        
        view.addSubview(profile_pic)
        
        profile_pic.translatesAutoresizingMaskIntoConstraints = false
        profile_pic.widthAnchor.constraint(equalToConstant: 90).isActive = true
        profile_pic.heightAnchor.constraint(equalToConstant: 90).isActive = true
        profile_pic.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        profile_pic.topAnchor.constraint(equalTo: cover_pic.bottomAnchor, constant: -55).isActive = true
        
        profile_pic.clipsToBounds = true
        
        view.addSubview(name)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        name.widthAnchor.constraint(equalToConstant: screenSize.width - 20).isActive = true
        name.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        name.topAnchor.constraint(equalTo: profile_pic.bottomAnchor, constant: 10).isActive = true
        
        name.textColor = UIColor.white
        name.textAlignment = .center
        name.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        view.addSubview(bio)
        
        bio.translatesAutoresizingMaskIntoConstraints = false
        bio.widthAnchor.constraint(equalToConstant: screenSize.width - 20).isActive = true
        bio.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        bio.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10).isActive = true
        
        bio.textColor = UIColor.white
        bio.textAlignment = .center
        bio.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        view.addSubview(follow_button)
        
        follow_button.translatesAutoresizingMaskIntoConstraints = false
        follow_button.widthAnchor.constraint(equalToConstant: screenSize.width-20).isActive = true
        follow_button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        follow_button.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        follow_button.topAnchor.constraint(equalTo: bio.bottomAnchor, constant: 10).isActive = true
        
        follow_button.setTitle("Follow", for: .normal)
        
        follow_button.layer.cornerRadius = 10.0
        follow_button.layer.backgroundColor = UIColor.red.cgColor
        follow_button.setTitleColor(.white, for: .normal)
        
        follow_button.isHidden = true
        
        follow_button.addTarget(self, action: #selector(followUser), for: .touchUpInside)
        
        view.addSubview(videos_count)
        
        videos_count.translatesAutoresizingMaskIntoConstraints = false
        videos_count.widthAnchor.constraint(equalToConstant: screenSize.width/4 - 10).isActive = true
        videos_count.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        videos_count.topAnchor.constraint(equalTo: follow_button.bottomAnchor, constant: 10).isActive = true
        
        videos_count.textColor = UIColor.white
        videos_count.textAlignment = .center
        videos_count.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        view.addSubview(videos_label)
        
        videos_label.translatesAutoresizingMaskIntoConstraints = false
        videos_label.widthAnchor.constraint(equalToConstant: screenSize.width/4 - 10).isActive = true
        videos_label.topAnchor.constraint(equalTo: videos_count.bottomAnchor, constant: 5).isActive = true
        videos_label.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        videos_label.textColor = UIColor.white
        videos_label.textAlignment = .center
        videos_label.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        videos_label.text = "Videos"
        
        view.addSubview(views_count)
        
        views_count.translatesAutoresizingMaskIntoConstraints = false
        views_count.widthAnchor.constraint(equalToConstant: screenSize.width/4 - 10).isActive = true
        views_count.leftAnchor.constraint(equalTo: videos_count.rightAnchor, constant: 10).isActive = true
        views_count.topAnchor.constraint(equalTo: follow_button.bottomAnchor, constant: 10).isActive = true
        
        views_count.textColor = UIColor.white
        views_count.textAlignment = .center
        views_count.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        view.addSubview(views_label)
        
        views_label.translatesAutoresizingMaskIntoConstraints = false
        views_label.widthAnchor.constraint(equalToConstant: screenSize.width/4 - 10).isActive = true
        views_label.topAnchor.constraint(equalTo: views_count.bottomAnchor, constant: 5).isActive = true
        views_label.leftAnchor.constraint(equalTo: videos_label.rightAnchor, constant: 10).isActive = true
        views_label.textColor = UIColor.white
        views_label.textAlignment = .center
        views_label.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        views_label.text = "Views"
        
        view.addSubview(followers_count)
        
        followers_count.translatesAutoresizingMaskIntoConstraints = false
        followers_count.widthAnchor.constraint(equalToConstant: screenSize.width/4 - 10).isActive = true
        followers_count.leftAnchor.constraint(equalTo: views_count.rightAnchor, constant: 10).isActive = true
        followers_count.topAnchor.constraint(equalTo: follow_button.bottomAnchor, constant: 10).isActive = true
        
        followers_count.textColor = UIColor.white
        followers_count.textAlignment = .center
        followers_count.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        view.addSubview(followers_label)
        
        followers_label.translatesAutoresizingMaskIntoConstraints = false
        followers_label.widthAnchor.constraint(equalToConstant: screenSize.width/4 - 10).isActive = true
        followers_label.topAnchor.constraint(equalTo: followers_count.bottomAnchor, constant: 5).isActive = true
        followers_label.leftAnchor.constraint(equalTo: views_label.rightAnchor, constant: 10).isActive = true
        followers_label.textColor = UIColor.white
        followers_label.textAlignment = .center
        followers_label.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        followers_label.text = "Followers"
        
        followers_label.isUserInteractionEnabled = true
        followers_count.isUserInteractionEnabled = true
        let tapGestureFollower = UITapGestureRecognizer(target: self, action: #selector(onFollowerClick))
        let tapGestureFollower1 = UITapGestureRecognizer(target: self, action: #selector(onFollowerClick))
        followers_count.addGestureRecognizer(tapGestureFollower)
        followers_label.addGestureRecognizer(tapGestureFollower1)
        
        view.addSubview(following_count)
        
        following_count.translatesAutoresizingMaskIntoConstraints = false
        following_count.widthAnchor.constraint(equalToConstant: screenSize.width/4 - 10).isActive = true
        following_count.leftAnchor.constraint(equalTo: followers_count.rightAnchor, constant: 10).isActive = true
        following_count.topAnchor.constraint(equalTo: follow_button.bottomAnchor, constant: 10).isActive = true
        
        following_count.textColor = UIColor.white
        following_count.textAlignment = .center
        following_count.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        view.addSubview(following_label)
        
        following_label.translatesAutoresizingMaskIntoConstraints = false
        following_label.widthAnchor.constraint(equalToConstant: screenSize.width/4 - 10).isActive = true
        following_label.topAnchor.constraint(equalTo: following_count.bottomAnchor, constant: 5).isActive = true
        following_label.leftAnchor.constraint(equalTo: followers_label.rightAnchor, constant: 10).isActive = true
        following_label.textColor = UIColor.white
        following_label.textAlignment = .center
        following_label.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        following_label.text = "Following"
        
        following_label.isUserInteractionEnabled = true
        following_count.isUserInteractionEnabled = true
        let tapGestureFollowing = UITapGestureRecognizer(target: self, action: #selector(onFollowingClick(_:)))
        let tapGestureFollowing1 = UITapGestureRecognizer(target: self, action: #selector(onFollowingClick(_:)))
        following_label.addGestureRecognizer(tapGestureFollowing)
        following_count.addGestureRecognizer(tapGestureFollowing1)
        
        setUserVideos();
    }
    
    
    @IBAction func onFollowingClick(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        follower = "Following"
        performSegue(withIdentifier: "profileFollowing", sender: self)
    }
    
    @IBAction func onFollowerClick(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        follower = "Followers"
        performSegue(withIdentifier: "profileFollowing", sender: self)
    }
    
    func setUserVideos() {
        
        let screenSize = UIScreen.main.bounds.size
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: (screenSize.width/3) - 10, height: 120)
        userVideoView.collectionViewLayout = layout
        
        userVideoView.delegate = self
        userVideoView.dataSource = self
        userVideoView.backgroundColor = UIColor.black
        userVideoView.register(UserVideoCollectionViewCell.self, forCellWithReuseIdentifier: "UserVideoCell")
        self.view.addSubview(userVideoView)
        
        userVideoView.translatesAutoresizingMaskIntoConstraints = false
        userVideoView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        userVideoView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        userVideoView.topAnchor.constraint(equalTo: following_label.bottomAnchor, constant: 10).isActive = true
        userVideoView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10).isActive = true
        
        view.addSubview(loader)
        
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.topAnchor.constraint(equalTo: following_label.bottomAnchor, constant: 20).isActive = true
        loader.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
    
        loader.color = UIColor.white
        
        view.addSubview(no_result)
        
        no_result.translatesAutoresizingMaskIntoConstraints = false
        no_result.widthAnchor.constraint(equalToConstant: 150).isActive = true
        no_result.heightAnchor.constraint(equalToConstant: 30).isActive = true
        no_result.topAnchor.constraint(equalTo: following_label.bottomAnchor, constant: 20).isActive = true
        no_result.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: (screenSize.width/2)-65).isActive = true
        
        no_result.textAlignment = .center
        no_result.text = "No Video Bytes"
        no_result.textColor = UIColor.white
        no_result.layer.borderWidth = 1
        no_result.font = UIFont.boldSystemFont(ofSize: 12.0)
        no_result.layer.borderColor = UIColor.white.cgColor
        no_result.layer.cornerRadius = 5.0
        no_result.sizeToFit()
        no_result.numberOfLines = 1
        
        no_result.isHidden = true
    }
    
    func fetchData() {
        
        if page == 1 {
            profile_pic.layer.cornerRadius = (profile_pic.frame.height / 2)
            
            name.text = user.name
            bio.text = user.bio
            
            if !user.profile_pic.isEmpty {
                let url = URL(string: user.profile_pic)
                profile_pic.kf.setImage(with: url, placeholder: UIImage(named: "user"))
            } else {
                profile_pic.image = UIImage(named: "user")
            }
            videos_count.text = "\(user.vb_count)"
            views_count.text = "\(user.view_count)"
            following_count.text = user.follow_count
            followers_count.text = user.follower_count
            user_name.text = "@"+user.username
            let url1 = URL(string: user.cover_pic)
            cover_pic.kf.setImage(with: url1)
            profile_pic.contentMode = .scaleAspectFill
            cover_pic.contentMode = .scaleAspectFill
            follow_button.isHidden = false
        }
        
        if (isLoading || isFinished) {
            return
        }
        
        isLoading = true
        
        var headers: [String: Any]? = nil
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
            headers = [
                "Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        
        let url = "https://www.boloindya.com/api/v1/get_vb_list/?user_id=\(user.id)&page=\(page)"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers as? HTTPHeaders)
            .responseString  { (responseData) in
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                        
                        do {
                            let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                            if let content = json_object?["results"] as? [[String:Any]] {
                                if (content.count == 0) {
                                    self.isFinished = true
                                }
                                for each in content {
                                    self.topics.append(getTopicFromJson(each: each))
                                }
                                self.isLoading = false
                                self.page += 1
                                self.userVideoView.reloadData()
                            }
                            if self.topics.count == 0 {
                                self.no_result.isHidden = false
                            }
                            self.loader.isHidden = true
                            self.loader.stopAnimating()
                        }
                        catch {
                            self.loader.isHidden = true
                            self.loader.stopAnimating()
                            self.isLoading = false
                            print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    self.loader.isHidden = true
                    self.loader.stopAnimating()
                    self.isLoading = false
                    print(error)
                }
        }
    }
    
    func fetchUserData() {
        
        if (isLoading) {
            return
        }
        
        loader.isHidden = false
        loader.startAnimating()
        
        isLoading = true
        
        let paramters: [String: Any] = [
            "user_id": "\(user.id)"
        ]
        
        let url = "https://www.boloindya.com/api/v1/get_userprofile/"
        
        Alamofire.request(url, method: .post, parameters: paramters, encoding: URLEncoding.default, headers: nil)
            .responseString  { (responseData) in
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                        
                        do {
                            let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                            if let result = json_object?["result"] as? [String:Any] {
                                let user_profile_obj = result["userprofile"] as? [String:Any]
                                self.user.id = user_profile_obj?["user"] as! Int
                                if !self.users_following.isEmpty {
                                    if self.users_following.contains(self.user.id) {
                                        self.isFollowing = true
                                        self.follow_button.setTitle("Following", for: .normal)
                                        self.follow_button.layer.backgroundColor = UIColor.white.cgColor
                                        self.follow_button.setTitleColor(UIColor.black, for: .normal)
                                    }
                                }
                                self.user.setUserName(username: user_profile_obj?["slug"] as? String ?? "")
                                
                                self.user.setName(name: user_profile_obj?["name"] as? String ?? "")
                                self.user.setBio(bio: user_profile_obj?["bio"] as? String ?? "")
                                self.user.setCoverPic(cover_pic: user_profile_obj?["cover_pic"] as? String ?? "")
                                self.user.setProfilePic(profile_pic: user_profile_obj?["profile_pic"] as? String ?? "")
                                self.user.vb_count = user_profile_obj?["vb_count"] as! Int
                                self.user.view_count = user_profile_obj?["view_count"] as! String
                                if let follow_count = user_profile_obj?["follow_count"] as? Int {
                                    self.user.follow_count = "\(follow_count)"
                                } else {
                                    self.user.follow_count = user_profile_obj?["follow_count"] as! String
                                }
                                if let following_count = user_profile_obj?["follower_count"] as? Int {
                                    self.user.follower_count = "\(following_count)"
                                } else {
                                    self.user.follower_count = user_profile_obj?["follower_count"] as! String
                                }
                                self.dismissLoading()
                            }
                        }
                        catch {
                            self.dismissLoading()
                            print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    self.dismissLoading()
                    print(error)
                }
        }
    }
    
    
    func followingUser() {
        
        if (isFollowingUser) {
            return
        }
        
        isFollowingUser = true
        
        let paramters: [String: Any] = [
            "user_following_id": "\(user.id)"
        ]
        
        var headers: [String: Any]? = nil
        
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
            headers = ["Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        
        let url = "https://www.boloindya.com/api/v1/follow_user/"
        
        Alamofire.request(url, method: .post, parameters: paramters, encoding: URLEncoding.default, headers: headers as? HTTPHeaders)
            .responseString  { (responseData) in
                self.isFollowingUser = false
        }
    }
    
    @objc func followUser(_ sender: UITapGestureRecognizer) {
        let isLoggedIn = UserDefaults.standard.isLoggedIn() ?? false
        if (!isLoggedIn) {
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.isNavigationBarHidden = true
            performSegue(withIdentifier: "userProfileLogin", sender: self)
            return
        }
        if self.isFollowing {
            users_following.remove(at: users_following.firstIndex(of: self.user.id)!)
            follow_button.setTitle("Follow", for: .normal)
            follow_button.layer.backgroundColor = UIColor.red.cgColor
            follow_button.setTitleColor(.white, for: .normal)
        } else {
            follow_button.setTitle("Following", for: .normal)
            follow_button.layer.backgroundColor = UIColor.white.cgColor
            follow_button.setTitleColor(UIColor.black, for: .normal)
            users_following.append(self.user.id)
        }
        self.followingUser()
        self.isFollowing = !self.isFollowing
        UserDefaults.standard.setFollowingUsers(value: users_following)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func dismissLoading() {
        self.isLoading = false
        self.fetchData()
    }
    
    @IBAction func report_user(_ sender: Any) {
        
        let actionSheet =  UIAlertController(title: nil, message:nil, preferredStyle: .actionSheet)
        let report_user = UIAlertAction(title: "Report User", style: .default, handler: {
            (_:UIAlertAction) in
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (_:UIAlertAction) in
        })
        actionSheet.addAction(report_user)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is VideoViewController {
            let vc = segue.destination as? VideoViewController
            vc?.videos = topics
            vc?.self_user = true
            vc?.selected_position = selected_position
        } else if segue.destination is FollowingFollowerViewController {
            let vc = segue.destination as? FollowingFollowerViewController
            vc?.user_id = user.id
            vc?.follower = follower
        } else if segue.destination is LoginAndSignUpViewController{
            let vc = segue.destination as? LoginAndSignUpViewController
            vc?.selected_tab = 0
        }
    }
    
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected_position = indexPath.row
        performSegue(withIdentifier: "VideoViewOtherUser", sender: self)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    private func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserVideoCell", for: indexPath) as! UserVideoCollectionViewCell
        if !self.topic_liked.isEmpty {
            if self.topic_liked.contains(Int(self.topics[indexPath.row].id)!) {
                self.topics[indexPath.row].isLiked = true
            }
        }
        cell.configure(with: topics[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/3) - 10, height: ((collectionView.frame.width/3) - 10) * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == topics.count - 1 {
            self.fetchData()
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareProfile(_ sender: Any) {
        let destinationUrl = "https://www.boloindya.com/user/\(user.id)/"+user.username
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
    }
}
