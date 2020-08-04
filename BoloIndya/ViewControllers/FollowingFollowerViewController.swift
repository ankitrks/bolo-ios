//
//  FollowingFollowerViewController.swift
//  BoloIndya
//
//  Created by apple on 8/4/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Alamofire

class FollowingFollowerViewController: UIViewController {

    var go_back =  UIImageView()
    
    var following = UILabel()
    var label = UILabel()
    
    var user_id: Int = 0
    var followerView = UITableView()
    
    var users: [User] = []
    var isLoading: Bool = false
    var follower = "Followers"
    var selected_position: Int = 0
    var page = 0
    var isAtEnd: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize = UIScreen.main.bounds.size
        
        view.addSubview(go_back)
    
        view.addSubview(following)
        view.addSubview(followerView)
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        go_back.translatesAutoresizingMaskIntoConstraints = false
        go_back.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        go_back.heightAnchor.constraint(equalToConstant: 40).isActive = true
        go_back.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5).isActive = true
        go_back.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        
        go_back.image = UIImage(named: "close_white")
        go_back.tintColor = UIColor.white
        
        go_back.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goBack(_:)))
        go_back.addGestureRecognizer(tapGesture)
        
        following.translatesAutoresizingMaskIntoConstraints = false
        following.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        following.heightAnchor.constraint(equalToConstant: 20).isActive = true
        following.centerYAnchor.constraint(equalTo: self.go_back.centerYAnchor, constant: 0).isActive = true
        
        following.text = follower
        following.textAlignment = .center
        following.textColor = UIColor.white
        
        followerView.isScrollEnabled = true
        followerView.delegate = self
        followerView.dataSource = self
        followerView.register(FollowerViewCell.self, forCellReuseIdentifier: "Cell")
        followerView.backgroundColor = .black
        
        followerView.translatesAutoresizingMaskIntoConstraints = false
        followerView.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        followerView.topAnchor.constraint(equalTo: go_back.bottomAnchor, constant: 10).isActive = true
        followerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        fetchUserData()
    }
    
    @objc func goBack(_ sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func fetchUserData() {
        
        if (isLoading || isAtEnd) {
            return
        }
        
        isLoading = true
        
        var url = "https://www.boloindya.com/api/v1/get_following_list/?user_id=\(user_id)&offset=\(page*15)"
        
        if follower == "Following" {
            url = "https://www.boloindya.com/api/v1/get_follower_list/?user_id=\(user_id)&offset=\(page*15)"
        }
        
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
                                self.users.append(user)
                            }
                            self.page += 1
                            self.followerView.reloadData()
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ProfileViewController {
            let vc = segue.destination as? ProfileViewController
            vc?.user = users[selected_position]
        }
    }
}

extension FollowingFollowerViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! FollowerViewCell
        cell.configure(with: users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        selected_position = indexPath.row
        self.performSegue(withIdentifier: "userFollowingProfile", sender: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           
           let lastSectionIndex = tableView.numberOfSections - 1
           let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
           
           if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
               fetchUserData()
           }
       }
}
