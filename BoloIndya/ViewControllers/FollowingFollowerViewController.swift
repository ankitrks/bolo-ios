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
    
    var users_following: [Int] = []
    var id = ""
    
    var loader = UIActivityIndicatorView()
    
    var no_result = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        users_following = UserDefaults.standard.getFollowingUsers()
        
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
        go_back.topAnchor.constraint(equalTo: self.view.topAnchor, constant: getStatusBarHeight()).isActive = true
        
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
        followerView.separatorStyle = .none
        followerView.delegate = self
        followerView.dataSource = self
        followerView.register(FollowerViewCell.self, forCellReuseIdentifier: "Cell")
        followerView.backgroundColor = .black
        
        followerView.translatesAutoresizingMaskIntoConstraints = false
        followerView.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        followerView.topAnchor.constraint(equalTo: go_back.bottomAnchor, constant: 10).isActive = true
        followerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        view.addSubview(loader)
        
        loader.center = self.view.center
        
        loader.color = UIColor.white
        
        view.addSubview(no_result)
        
        no_result.translatesAutoresizingMaskIntoConstraints = false
        no_result.widthAnchor.constraint(equalToConstant: 150).isActive = true
        no_result.heightAnchor.constraint(equalToConstant: 30).isActive = true
        no_result.topAnchor.constraint(equalTo: go_back.bottomAnchor, constant: 15).isActive = true
        no_result.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: (screenSize.width/2)-65).isActive = true
        
        no_result.textAlignment = .center
        no_result.text = "No Data Found"
        no_result.textColor = UIColor.white
        no_result.layer.borderWidth = 1
        no_result.font = UIFont.boldSystemFont(ofSize: 12.0)
        no_result.layer.borderColor = UIColor.white.cgColor
        no_result.layer.cornerRadius = 5.0
        no_result.sizeToFit()
        no_result.numberOfLines = 1
        
        no_result.isHidden = true
        
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
        
        loader.isHidden = false
        loader.startAnimating()
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
                                    let user = getUserDataFromJson(result: result)
                                
                                    if !self.users_following.isEmpty {
                                        user.isFollowing = self.users_following.contains(user.id)
                                    }
                                    self.users.append(user)
                                }
                                self.page += 1
                                self.followerView.reloadData()
                                self.hideLoaderAndLoading()
                            }
                        }
                        catch {
                            self.hideLoaderAndLoading()
                            print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    self.hideLoaderAndLoading()
                    print(error)
                }
        }
    }
    
    func hideLoaderAndLoading() {
        no_result.isHidden = (users.count != 0)
        loader.isHidden = true
        loader.stopAnimating()
        isLoading = false
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
        cell.selected_postion = indexPath.row
        cell.delegate = self
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

extension FollowingFollowerViewController: FollowerViewCellDelegate {
    func followUser(with selected_postion: Int) {
        let isLoggedIn = UserDefaults.standard.isLoggedIn() ?? false
        if (!isLoggedIn) {
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.isNavigationBarHidden = true
            performSegue(withIdentifier: "followingLogin", sender: self)
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
        followerView.reloadData()
    }
}
