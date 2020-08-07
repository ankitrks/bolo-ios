//
//  HashTagViewController.swift
//  BoloIndya
//
//  Created by apple on 7/24/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Alamofire

class HashTagViewController: UIViewController {

    var hash_tag: HashTag = HashTag()
    var topics: [Topic] = []
    var isLoading: Bool = false
    var isFinished: Bool = false
    var page: Int = 1
    var selected_position: Int = 0
    
    var hash_tag_label =  UILabel()
    var views_and_videos =  UILabel()
    var hash_image =  UIImageView()
    var share_button = UIButton()
    
    var upper_tab = UIView()
    var back_image = UIImageView()
    var label = UILabel()
    
    var videoView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        upper_tab.addSubview(back_image)
        upper_tab.addSubview(label)
        
        view.addSubview(upper_tab)
        
        upper_tab.translatesAutoresizingMaskIntoConstraints = false
        upper_tab.heightAnchor.constraint(equalToConstant: 40).isActive = true
        upper_tab.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 0).isActive = true
        upper_tab.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: 0).isActive = true
        upper_tab.topAnchor.constraint(equalTo: self.view.topAnchor, constant: getStatusBarHeight()).isActive = true
        
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
        
        self.view.addSubview(hash_tag_label)
        self.view.addSubview(views_and_videos)
        self.view.addSubview(hash_image)
        self.view.addSubview(share_button)
        
        let screenSize = UIScreen.main.bounds.size
        
        hash_tag_label.translatesAutoresizingMaskIntoConstraints = false
        hash_tag_label.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        hash_tag_label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        hash_tag_label.leftAnchor.constraint(equalTo: hash_image.rightAnchor, constant: 10).isActive = true
        hash_tag_label.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70).isActive = true
        
        views_and_videos.translatesAutoresizingMaskIntoConstraints = false
        views_and_videos.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        views_and_videos.heightAnchor.constraint(equalToConstant: 20).isActive = true
        views_and_videos.leftAnchor.constraint(equalTo: hash_image.rightAnchor, constant: 10).isActive = true
        views_and_videos.topAnchor.constraint(equalTo: hash_tag_label.bottomAnchor, constant: 5).isActive = true
        
        hash_image.translatesAutoresizingMaskIntoConstraints = false
        hash_image.widthAnchor.constraint(equalToConstant: 90).isActive = true
        hash_image.heightAnchor.constraint(equalToConstant: 90).isActive = true
        hash_image.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        hash_image.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70).isActive = true
        
        share_button.translatesAutoresizingMaskIntoConstraints = false
        share_button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        share_button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        share_button.leftAnchor.constraint(equalTo: hash_image.rightAnchor, constant: 10).isActive = true
        share_button.topAnchor.constraint(equalTo: views_and_videos.bottomAnchor, constant: 5).isActive = true
        
        hash_image.image = UIImage(named: "hash")
        
        hash_tag_label.text = "#"+hash_tag.title
        hash_tag_label.textColor = UIColor.white
        
        views_and_videos.textColor = UIColor.white
        
        share_button.setTitle("Share", for: .normal)
               
        share_button.layer.cornerRadius = 10.0
        share_button.layer.backgroundColor = UIColor.blue.cgColor
        share_button.setTitleColor(.white, for: .normal)
        
        share_button.addTarget(self, action: #selector(shareHash), for: .touchUpInside)
        
        setUserVideoView()
        fetchHashTag()
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
    
    @objc func shareHash(_ sender: UITapGestureRecognizer) {
        let destinationUrl = "https://www.boloindya.com/trending/"+hash_tag.title
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
    
    func setUserVideoView() {
        let screenSize = UIScreen.main.bounds.size
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: (screenSize.width/3.4), height: (screenSize.width/3.4) * 1.5)
        videoView.collectionViewLayout = layout
        
        videoView.delegate = self
        videoView.dataSource = self
        videoView.backgroundColor = UIColor.clear
        videoView.register(UserVideoCollectionViewCell.self, forCellWithReuseIdentifier: "UserVideoCell")
        self.view.addSubview(videoView)
        
        videoView.translatesAutoresizingMaskIntoConstraints = false
        videoView.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        videoView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        videoView.topAnchor.constraint(equalTo: hash_image.bottomAnchor, constant: 5).isActive = true
        videoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
    
    }
    
    func fetchHashTag() {
        
        if (isLoading) {
            return
        }
                  
        isLoading = true
        
        var headers: [String: Any]? = nil
               
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
            headers = ["Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        
        let parameters: [String: Any] = [
            "ChallengeHash": hash_tag.title,
            "language_id":"\(UserDefaults.standard.getValueForLanguageId().unsafelyUnwrapped)"
        ]
        
        let url = "https://www.boloindya.com/api/v1/get_challenge_details/"
           
           print(url)
           
           Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers as? HTTPHeaders)
               .responseString  { (responseData) in
                   switch responseData.result {
                   case.success(let data):
                       if let json_data = data.data(using: .utf8) {
                       
                       do {
                           let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                        if let count = (json_object?["vb_count"]) {
                            self.views_and_videos.text = (json_object?["all_seen"] as? String ?? "") + " Views * \(count) Videos"
                        } else {
                            self.views_and_videos.text = (json_object?["all_seen"] as? String ?? "") + " Views * " + (json_object?["vb_count"] as? String ?? "") + " Videos"
                        }
                            self.isLoading = false
                            self.fetchData()
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
    
    func fetchData() {

        if (isLoading || isFinished) {
            return
        }
           
        isLoading = true
           
        var headers: [String: Any]? = nil
               
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
            headers = ["Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        
        let url = "https://www.boloindya.com/api/v1/get_challenge/?challengehash="+hash_tag.title+"&page=\(page)&language_id=\(UserDefaults.standard.getValueForLanguageId().unsafelyUnwrapped)"
           
           print(url)
           
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
                                   let user = User()
                                   let user_obj = each["user"] as? [String:Any]
                                   
                                   user.setUserName(username: user_obj?["username"] as? String ?? "")
                                   let topic = Topic(user: user)
                                   topic.setTitle(title: each["title"] as? String ?? "")
                                   topic.setThumbnail(thumbail: each["question_image"] as? String ?? "")
                                   topic.id = "\(each["id"] as! Int)"
                                   topic.video_url = each["video_cdn"] as? String ?? ""
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
        }
    }
      
}

extension HashTagViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selected_position = indexPath.row
        self.tabBarController?.tabBar.isHidden = true
        performSegue(withIdentifier: "HashVideoView", sender: self)
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
        return CGSize(width: (collectionView.frame.width/3.4), height: (collectionView.frame.width/3.4) * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if indexPath.row == topics.count - 1 {
                self.fetchData()
        }
    }
    
}

