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

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var bio: UILabel!
    
    @IBOutlet weak var profile_pic: UIImageView!
    
    @IBOutlet weak var cover_pic: UIImageView!
    
    var user = User()
            
    var selected_position: Int = 0
    var isLoading: Bool = false
    var page: Int = 1
    var topics: [Topic] = []
    var isFinished: Bool = false
    
    var userVideoView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserVideoView()
        fetchUserData()
    }
    
    func setUserVideoView() {
        let screenSize = UIScreen.main.bounds.size
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: (screenSize.width/3.4), height: 120)
        userVideoView.collectionViewLayout = layout
        
        userVideoView.delegate = self
        userVideoView.dataSource = self
        userVideoView.backgroundColor = UIColor.clear
        userVideoView.register(UserVideoCollectionViewCell.self, forCellWithReuseIdentifier: "UserVideoCell")
        self.view.addSubview(userVideoView)
        
        self.userVideoView.frame = CGRect(x: 0, y: 340, width: screenSize.width, height: screenSize.height-((self.tabBarController?.tabBar.frame.size.height ?? 49.0)+298))
    }
    
    func fetchData() {
        
        if page == 1 {
            
            profile_pic.layer.cornerRadius = (profile_pic.frame.height / 2)
            
            name.text = user.name
            bio.text = user.bio
            
            let url = URL(string: user.profile_pic)
            profile_pic.kf.setImage(with: url)
            
            let url1 = URL(string: user.cover_pic)
            cover_pic.kf.setImage(with: url1)
        }
        
        if (isLoading || isFinished) {
            return
        }
        
        isLoading = true
        
        let headers: [String: Any] = [
            "Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        
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
                                return
                            }
                            for each in content {
                                let user_obj = each["user"] as? [String:Any]
                                let user_profile_obj = user_obj?["userprofile"] as? [String:Any]
                            
                                let topic = Topic(user: self.user)
                                topic.setTitle(title: each["title"] as? String ?? "")
                                topic.setThumbnail(thumbail: each["question_image"] as? String ?? "")
                                topic.video_url = each["question_video"] as? String ?? ""
                                self.topics.append(topic)
                            }
                            self.isLoading = false
                            self.page += 1
                            self.userVideoView.reloadData()
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
    
    func fetchUserData() {
        
        if (isLoading) {
            return
        }
        
        isLoading = true
        
        let paramters: [String: Any] = [
            "user_id": "\(user.id)"
        ]
        
        let url = "https://www.boloindya.com/api/v1/get_userprofile/"
        
        Alamofire.request(url, method: .post, parameters: paramters, encoding: URLEncoding.default, headers: nil)
            .responseString  { (responseData) in
                print(responseData)
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                    
                    do {
                        let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                        if let result = json_object?["result"] as? [String:Any] {
                            let user_profile_obj = result["userprofile"] as? [String:Any]
                            self.user.setUserName(username: user_profile_obj?["slug"] as? String ?? "")
                                
                            self.user.setName(name: user_profile_obj?["name"] as? String ?? "")
                            self.user.setBio(bio: user_profile_obj?["bio"] as? String ?? "")
                            self.user.setCoverPic(cover_pic: user_profile_obj?["cover_pic"] as? String ?? "")
                            self.user.setProfilePic(profile_pic: user_profile_obj?["profile_pic"] as? String ?? "")
                                
                            self.isLoading = false
                            self.fetchData()
                        }
                    }
                    catch {
                        self.isLoading = false
                        self.fetchData()
                        print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    self.isLoading = false
                    self.fetchData()
                    print(error)
                }
        }
    }
    
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.destination is VideoViewController {
          let vc = segue.destination as? VideoViewController
          vc?.videos = topics
          vc?.selected_position = selected_position
      }
  }
    
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected_position = indexPath.row
        performSegue(withIdentifier: "VideoViewOtherUser", sender: self)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserVideoCell", for: indexPath) as! UserVideoCollectionViewCell
        cell.configure(with: topics[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/3.4), height: (collectionView.frame.width/3.4) * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if indexPath.row == topics.count - 1 {
                self.fetchData()
        }
    }
}
