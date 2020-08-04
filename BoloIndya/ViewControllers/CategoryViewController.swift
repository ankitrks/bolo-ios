//
//  CategoryViewController.swift
//  BoloIndya
//
//  Created by apple on 7/24/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class CategoryViewController: UIViewController {

    var topics: [Topic] = []
    var selected_ids: [Int] = []
    var isLoading: Bool = false
    var isFinished: Bool = false
    var page: Int = 1
    var id: String = "68"
    var name: String = ""
    var selected_position: Int = 0
    
    var category_label =  UILabel()
    var category_videos =  UILabel()
    var category_image =  UIImageView()
    var follow_button = UIButton()
    var progress = UIActivityIndicatorView()
    
    var upper_tab = UIView()
    var back_image = UIImageView()
    var label = UILabel()
    
    var videoView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.getCategories() == nil {
            selected_ids = UserDefaults.standard.getFollowingUsers()
        } else {
            selected_ids = []
        }
        
        upper_tab.addSubview(back_image)
        upper_tab.addSubview(label)
        
        view.addSubview(upper_tab)
        
        upper_tab.translatesAutoresizingMaskIntoConstraints = false
        upper_tab.heightAnchor.constraint(equalToConstant: 40).isActive = true
        upper_tab.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 0).isActive = true
        upper_tab.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: 0).isActive = true
        upper_tab.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        
        upper_tab.layer.backgroundColor = #colorLiteral(red: 0.7098039216, green: 0.1568627451, blue: 0.1568627451, alpha: 0.8470588235)
        
        back_image.translatesAutoresizingMaskIntoConstraints = false
        back_image.heightAnchor.constraint(equalToConstant: 25).isActive = true
        back_image.widthAnchor.constraint(equalToConstant: 40).isActive = true
        back_image.centerYAnchor.constraint(equalTo: upper_tab.centerYAnchor,constant: 0).isActive = true
        back_image.leftAnchor.constraint(equalTo: upper_tab.leftAnchor,constant: 10).isActive = true
        
        back_image.image = UIImage(named: "back")
        back_image.contentMode = .scaleAspectFit
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.centerYAnchor.constraint(equalTo: upper_tab.centerYAnchor,constant: 0).isActive = true
        label.leftAnchor.constraint(equalTo: back_image.rightAnchor,constant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: -10).isActive = true
        
        label.text = ""
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        back_image.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goBack(_:)))
        back_image.addGestureRecognizer(tapGesture)
        
        self.view.addSubview(category_label)
        self.view.addSubview(category_videos)
        self.view.addSubview(category_image)
        self.view.addSubview(follow_button)
        view.addSubview(progress)
        
        let screenSize = UIScreen.main.bounds.size
        
        category_label.translatesAutoresizingMaskIntoConstraints = false
        category_label.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        category_label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        category_label.leftAnchor.constraint(equalTo: category_image.rightAnchor, constant: 10).isActive = true
        category_label.topAnchor.constraint(equalTo: upper_tab.bottomAnchor, constant: 10).isActive = true
        
        category_videos.translatesAutoresizingMaskIntoConstraints = false
        category_videos.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        category_videos.heightAnchor.constraint(equalToConstant: 20).isActive = true
        category_videos.leftAnchor.constraint(equalTo: category_image.rightAnchor, constant: 10).isActive = true
        category_videos.topAnchor.constraint(equalTo: category_label.bottomAnchor, constant: 5).isActive = true
        
        category_image.translatesAutoresizingMaskIntoConstraints = false
        category_image.widthAnchor.constraint(equalToConstant: 90).isActive = true
        category_image.heightAnchor.constraint(equalToConstant: 90).isActive = true
        category_image.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        category_image.topAnchor.constraint(equalTo: upper_tab.bottomAnchor, constant: 10).isActive = true
        
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.widthAnchor.constraint(equalToConstant: 60).isActive = true
        progress.heightAnchor.constraint(equalToConstant: 60).isActive = true
        progress.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        progress.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        
        category_label.text = name
        category_label.textColor = UIColor.white
        
        category_videos.textColor = UIColor.white
        
        follow_button.translatesAutoresizingMaskIntoConstraints = false
        follow_button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        follow_button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        follow_button.leftAnchor.constraint(equalTo: category_image.rightAnchor, constant: 10).isActive = true
        follow_button.topAnchor.constraint(equalTo: category_videos.bottomAnchor, constant: 5).isActive = true
        
        follow_button.setTitle("Follow", for: .normal)
        
        follow_button.layer.cornerRadius = 10.0
        follow_button.layer.backgroundColor = UIColor.red.cgColor
        follow_button.setTitleColor(.white, for: .normal)
        
        follow_button.isHidden = true
        
        follow_button.addTarget(self, action: #selector(followUser), for: .touchUpInside)
        
        setUserVideoView()
        fetchCategory()
    }
    
    @objc func followUser(_ sender: UITapGestureRecognizer) {
       let isLoggedIn = UserDefaults.standard.isLoggedIn() ?? false
       if (!isLoggedIn) {
           self.tabBarController?.tabBar.isHidden = true
           self.navigationController?.isNavigationBarHidden = true
           performSegue(withIdentifier: "categoryLogin", sender: self)
           return
       }
   }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setUserVideoView() {
        let screenSize = UIScreen.main.bounds.size
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: (screenSize.width/3) - 10, height: 120)
        videoView.collectionViewLayout = layout
        
        videoView.delegate = self
        videoView.dataSource = self
        videoView.backgroundColor = UIColor.clear
        videoView.register(UserVideoCollectionViewCell.self, forCellWithReuseIdentifier: "UserVideoCell")
        self.view.addSubview(videoView)
        
        videoView.translatesAutoresizingMaskIntoConstraints = false
        videoView.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        videoView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        videoView.topAnchor.constraint(equalTo: category_image.bottomAnchor, constant: 5).isActive = true
        videoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
    
    }
    
    func fetchCategory() {
    
        if (isLoading) {
            return
        }
              
        progress.isHidden = false
        videoView.isHidden = true
        
        isLoading = true
    
         var headers: [String: Any]? = nil
               
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
            headers = ["Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        
        let parameters: [String: Any] = [
            "category_id": id,
            "language_id":"\(UserDefaults.standard.getValueForLanguageId().unsafelyUnwrapped)"
        ]
    
        let url = "https://www.boloindya.com/api/v1/get_category_detail_with_views/"
       
    
       Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers as? HTTPHeaders)
           .responseString  { (responseData) in
               switch responseData.result {
               case.success(let data):
                   if let json_data = data.data(using: .utf8) {
                   
                   do {
                       let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                    
                    let desc = json_object?["category_details"] as? [String:Any]
                    if !self.selected_ids.isEmpty {
                        if (self.selected_ids.contains(desc?["id"] as! Int)) {
                                self.follow_button.setTitle("Following", for: .normal)
                                self.follow_button.setTitleColor(UIColor.black, for: .normal)
                                self.follow_button.layer.backgroundColor = UIColor.white.cgColor
                        }
                    }
                    self.category_videos.text = (desc?["total_view"] as? String ?? "") + " Views * " + (desc?["current_language_view"] as? String ?? "") + " Videos"
                    if (!(desc?["category_image"] as? String ?? "").isEmpty) {
                        let pic_url = URL(string: (desc?["category_image"] as? String ?? ""))
                        self.category_image.kf.setImage(with: pic_url)
                    }
                    if  let content = desc?["topics"] as? [[String:Any]] {
                        if (content.count == 0) {
                            self.isFinished = true
                            return
                        }
                        for each in content {
                            let user = User()
                            let user_obj = each["user"] as? [String:Any]
                            
                            user.setUserName(username: user_obj?["username"] as? String ?? "")
                            let topic = Topic(user: user)
                            topic.setTitle(title: each["title"] as? String ?? "")
                            topic.setThumbnail(thumbail: each["question_image"] as? String ?? "")
                            topic.video_url = each["video_cdn"] as? String ?? ""
                            self.topics.append(topic)
                        }
                        self.isLoading = false
                        self.page += 1

                        self.progress.isHidden = true
                        self.videoView.isHidden = false
                        self.videoView.reloadData()
                    }
                    self.follow_button.isHidden = false
                    self.isLoading = false
                   }
                   catch {
                       self.follow_button.isHidden = false
                       self.isLoading = false
                       self.progress.isHidden = true
                       self.videoView.isHidden = false
                       self.fetchData()
                       print(error.localizedDescription)
                       }
                   }
               case.failure(let error):
                   self.follow_button.isHidden = false
                   self.isLoading = false
                   self.progress.isHidden = true
                   self.videoView.isHidden = false
                   self.fetchData()
                   print(error)
               }
        }
        
    }
    
    func fetchData() {

        if (isLoading || isFinished) {
            return
        }
           
        isLoading = true
           
        var headers: [String: Any]? = nil
               
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
        headers = [
           "Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
           
        
        let parameters: [String: Any] = [
            "page": "\(page)",
            "category_id": id,
            "page_next": "\(page)",
            "language_id":"\(UserDefaults.standard.getValueForLanguageId().unsafelyUnwrapped)"
        ]
        
        let url = "https://www.boloindya.com/api/v1/get_category_video_bytes/"
           
           print(url)
           
           Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers as? HTTPHeaders)
               .responseString  { (responseData) in
                   switch responseData.result {
                   case.success(let data):
                       if let json_data = data.data(using: .utf8) {
                       
                       do {
                           let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                           if let content = json_object?["topics"] as? [[String:Any]] {
                               if (content.count == 0) {
                                   self.isFinished = true
                                   return
                               }
                               for each in content {
                                   let user = User()
                                   let user_obj = each["user"] as? [String:Any]
                                   
                                   user.setUserName(username: user_obj?["username"] as? String ?? "")
                                   let topic = Topic(user: user)
                                   topic.setTitle(title: each["title"] as? String ?? "")
                                   topic.setThumbnail(thumbail: each["question_image"] as? String ?? "")
                                   topic.video_url = each["question_video"] as? String ?? ""
                                   self.topics.append(topic)
                               }
                               self.isLoading = false
                               self.page += 1
                               self.videoView.reloadData()
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
        if segue.destination is VideoViewController {
            let vc = segue.destination as? VideoViewController
            vc?.videos = topics
            vc?.selected_position = selected_position
        } else if segue.destination is LoginAndSignUpViewController{
              let vc = segue.destination as? LoginAndSignUpViewController
              vc?.selected_tab = 0
        }
    }
    
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selected_position = indexPath.row
        self.tabBarController?.tabBar.isHidden = true
        performSegue(withIdentifier: "CategoryVideoView", sender: self)
        collectionView.deselectItem(at: indexPath, animated: true)
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
        return CGSize(width: (collectionView.frame.width/3) - 10, height: ((collectionView.frame.width/3) - 10) * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if indexPath.row == topics.count - 1 {
                self.fetchData()
        }
    }
    
}

