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
import SVProgressHUD

class CategoryViewController: BaseVC {
    
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
    
    var upper_tab = UIView()
    var back_image = UIImageView()
    var label = UILabel()
    var topic_liked: [Int] = []
    
    var videoView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())

    var loader = UIActivityIndicatorView()
    var no_result = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topic_liked = UserDefaults.standard.getLikeTopic()
        selected_ids = UserDefaults.standard.getCategories()
        
        upper_tab.addSubview(back_image)
        upper_tab.addSubview(label)
        
        view.addSubview(upper_tab)
        
        upper_tab.translatesAutoresizingMaskIntoConstraints = false
        upper_tab.heightAnchor.constraint(equalToConstant: 40).isActive = true
        upper_tab.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 0).isActive = true
        upper_tab.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: 0).isActive = true
        upper_tab.topAnchor.constraint(equalTo: self.view.topAnchor, constant: getStatusBarHeight()).isActive = true
        
        upper_tab.layer.backgroundColor = (UIColor(hex: "222020") ?? UIColor.black).cgColor
        
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
        
        
        category_label.text = name
        category_label.textColor = UIColor.white
        
        category_videos.textColor = UIColor.white
        category_videos.font = UIFont.systemFont(ofSize: 12)
        
        follow_button.translatesAutoresizingMaskIntoConstraints = false
        follow_button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        follow_button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        follow_button.leftAnchor.constraint(equalTo: category_image.rightAnchor, constant: 10).isActive = true
        follow_button.topAnchor.constraint(equalTo: category_videos.bottomAnchor, constant: 5).isActive = true
        
        follow_button.setTitle("Follow", for: .normal)
        
        follow_button.layer.cornerRadius = 10.0
        follow_button.layer.backgroundColor = (UIColor(hex: "10A5F9") ?? UIColor.red).cgColor
        follow_button.setTitleColor(.white, for: .normal)
        
        follow_button.isHidden = true
        
        follow_button.addTarget(self, action: #selector(followUser(_:)), for: .touchUpInside)
        
        setUserVideoView()
        fetchCategory()
    }
    
    @objc func followUser(_ sender: UIButton) {
        if isLogin() {
            guard let idInt = Int(id) else { return }
            
            SVProgressHUD.show()
            
            var headers: HTTPHeaders?
            
            if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
                headers = ["Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
            }
            
            var isFollow: Bool
            if selected_ids.contains(idInt) {
                if let index = selected_ids.firstIndex(of: idInt) {
                    selected_ids.remove(at: index)
                }
                isFollow = false
            } else {
                selected_ids.append(idInt)
                isFollow = true
            }
            
            var ids = ""
            for each in selected_ids {
                if each == selected_ids[selected_ids.count-1] {
                    ids += "\(each)"
                } else {
                    ids += "\(each),"
                }
            }
            
            let parameters: [String: Any] = [
                "activity": "settings_changed",
                "language": "\(UserDefaults.standard.getValueForLanguageId() ?? 2)",
                "categories": ids
            ]
            
            UserDefaults.standard.setCategories(value: selected_ids)
            
            let url = "https://www.boloindya.com/api/v1/fb_profile_settings/"
            
            
            AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
                .responseString  { [weak self] (responseData) in
                    SVProgressHUD.dismiss()
                    
                    switch responseData.result {
                    case.success(let data):
                        if let json_data = data.data(using: .utf8) {
                            
                            do {
                                let _ = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                                
                                if isFollow {
                                    self?.follow_button.setTitle("Following", for: .normal)
                                    self?.follow_button.setTitleColor(UIColor.black, for: .normal)
                                    self?.follow_button.layer.backgroundColor = UIColor.white.cgColor
                                } else {
                                    self?.follow_button.setTitle("Follow", for: .normal)
                                    self?.follow_button.layer.backgroundColor = (UIColor(hex: "10A5F9") ?? UIColor.red).cgColor
                                    self?.follow_button.setTitleColor(.white, for: .normal)
                                }
                            }
                            catch {
                                print(error.localizedDescription)
                                SVProgressHUD.show(withStatus: "Something went wrong")
                            }
                        }
                    case.failure(let error):
                        print(error)
                        SVProgressHUD.show(withStatus: "Something went wrong")
                    }
                }
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
        videoView.register(CategoryTagViewCell.self, forCellWithReuseIdentifier: "UserVideoCell")
        self.view.addSubview(videoView)
        
        videoView.translatesAutoresizingMaskIntoConstraints = false
        videoView.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        videoView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        videoView.topAnchor.constraint(equalTo: category_image.bottomAnchor, constant: 5).isActive = true
        videoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        view.addSubview(loader)
        
        loader.center = self.view.center
        
        loader.color = UIColor.white
        
        view.addSubview(no_result)
        
        no_result.translatesAutoresizingMaskIntoConstraints = false
        no_result.widthAnchor.constraint(equalToConstant: 150).isActive = true
        no_result.heightAnchor.constraint(equalToConstant: 30).isActive = true
        no_result.topAnchor.constraint(equalTo: category_image.bottomAnchor, constant: 15).isActive = true
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
    
    func fetchCategory() {
        
        if (isLoading) {
            return
        }
        
        videoView.isHidden = true
        loader.isHidden = false
        loader.startAnimating()
        isLoading = true
        
        var headers: HTTPHeaders?
        
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
            headers = ["Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        
        let parameters: [String: Any] = [
            "category_id": id,
            "language_id":"\(UserDefaults.standard.getValueForLanguageId().unsafelyUnwrapped)"
        ]
        
        let url = "https://www.boloindya.com/api/v1/get_category_detail_with_views/"
        
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
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
                                }
                                for each in content {
                                    self.topics.append(getTopicFromJson(each: each))
                                }
                                self.isLoading = false
                                self.page += 1
                                
                                self.videoView.isHidden = false
                                self.videoView.reloadData()
                            }
                            if self.topics.count == 0 {
                                self.no_result.isHidden = false
                            }
                            self.loader.isHidden = true
                            self.loader.stopAnimating()
                            self.follow_button.isHidden = false
                            self.isLoading = false
                        }
                        catch {
                            self.follow_button.isHidden = false
                            self.isLoading = false
                            self.videoView.isHidden = false
                            self.fetchData()
                            print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    self.follow_button.isHidden = false
                    self.isLoading = false
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
        
        var headers: HTTPHeaders?
        
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
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
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
                                    self.topics.append(getTopicFromJson(each: each))
                                }
                                self.isLoading = false
                                self.page += 1
                                self.videoView.reloadData()
                            }
                            if self.topics.count == 0 {
                                self.no_result.isHidden = false
                            }
                            self.loader.isHidden = true
                            self.loader.stopAnimating()
                        }
                        catch {
                            self.isLoading = false
                            self.loader.isHidden = true
                            self.loader.stopAnimating()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserVideoCell", for: indexPath) as! CategoryTagViewCell
        if !topic_liked.isEmpty {
            if topic_liked.contains(Int(self.topics[indexPath.row].id)!) {
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
    
}


class CategoryTagViewCell: UICollectionViewCell {
    
    var video_image =  UIImageView()
    var video_title = UILabel()
    
    var views = UILabel()
    var view_image =  UIImageView()
    var likes = UILabel()
    var like_image =  UIImageView()
    
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
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(video_image)
        addSubview(video_title)
        
        addSubview(views)
        addSubview(view_image)
        addSubview(likes)
        addSubview(like_image)
        
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
        view_image.leftAnchor.constraint(equalTo: leftAnchor, constant: 2).isActive = true
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
        like_image.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        
        like_image.layer.cornerRadius = 2.0
        like_image.contentMode = .scaleAspectFill
        like_image.clipsToBounds = true
        
        likes.translatesAutoresizingMaskIntoConstraints = false
        likes.heightAnchor.constraint(equalToConstant: 11).isActive = true
        likes.widthAnchor.constraint(equalToConstant: 40).isActive = true
        likes.rightAnchor.constraint(equalTo: like_image.leftAnchor, constant: -2).isActive = true
        likes.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        likes.textColor = UIColor.white
        
        likes.textAlignment = .right
        likes.font = UIFont.boldSystemFont(ofSize: 9.0)
        likes.numberOfLines = 1
        
        video_title.translatesAutoresizingMaskIntoConstraints = false
        video_title.heightAnchor.constraint(equalToConstant: 40).isActive = true
        video_title.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        video_title.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        video_title.bottomAnchor.constraint(equalTo: views.topAnchor, constant: 5).isActive = true
        video_title.textColor = UIColor.white
        
        video_title.font = UIFont.boldSystemFont(ofSize: 13.0)
        video_title.numberOfLines = 2
        
    }
}
