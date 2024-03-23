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
    var topic_liked: [Int] = []
    
    var videoView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())

    var loader = UIActivityIndicatorView()
    
    var no_result = UILabel()
    
    var retry = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topic_liked = UserDefaults.standard.getLikeTopic()
        
        upper_tab.addSubview(back_image)
        upper_tab.addSubview(label)
        
        view.addSubview(upper_tab)
        
        upper_tab.translatesAutoresizingMaskIntoConstraints = false
        upper_tab.heightAnchor.constraint(equalToConstant: 40).isActive = true
        upper_tab.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 0).isActive = true
        upper_tab.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: 0).isActive = true
        upper_tab.topAnchor.constraint(equalTo: self.view.topAnchor, constant: getStatusBarHeight()).isActive = true
        
        upper_tab.layer.backgroundColor = (UIColor(hex: "222020") ?? UIColor.red).cgColor
        
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
        
        view.addSubview(hash_tag_label)
        view.addSubview(views_and_videos)
        view.addSubview(hash_image)
        view.addSubview(share_button)
        
        let screenSize = UIScreen.main.bounds.size
        
        hash_tag_label.translatesAutoresizingMaskIntoConstraints = false
        hash_tag_label.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        hash_tag_label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        hash_tag_label.leftAnchor.constraint(equalTo: hash_image.rightAnchor, constant: 10).isActive = true
        hash_tag_label.topAnchor.constraint(equalTo: self.upper_tab.bottomAnchor, constant: 5).isActive = true
        
        views_and_videos.translatesAutoresizingMaskIntoConstraints = false
        views_and_videos.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        views_and_videos.heightAnchor.constraint(equalToConstant: 20).isActive = true
        views_and_videos.leftAnchor.constraint(equalTo: hash_image.rightAnchor, constant: 10).isActive = true
        views_and_videos.topAnchor.constraint(equalTo: hash_tag_label.bottomAnchor, constant: 5).isActive = true
        
        hash_image.translatesAutoresizingMaskIntoConstraints = false
        hash_image.widthAnchor.constraint(equalToConstant: 90).isActive = true
        hash_image.heightAnchor.constraint(equalToConstant: 90).isActive = true
        hash_image.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        hash_image.topAnchor.constraint(equalTo: self.upper_tab.bottomAnchor, constant: 5).isActive = true
        
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
        share_button.layer.backgroundColor = (UIColor(hex: "10A5F9") ?? UIColor.black).cgColor
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
        activityController.completionWithItemsHandler = { (type, completed, _, error) in
            if type == UIActivity.ActivityType.instagram, let instagramUrl = URL(string: "instagram://app"), UIApplication.shared.canOpenURL(instagramUrl) {
                UIApplication.shared.open(instagramUrl, options: [:], completionHandler: nil)
            }
            
            if completed {
                print("completed")
            } else {
                print("error")
            }
        }
        self.present(activityController, animated: true)
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
        videoView.register(HashTagViewCell.self, forCellWithReuseIdentifier: "UserVideoCell")
        self.view.addSubview(videoView)
        
        videoView.translatesAutoresizingMaskIntoConstraints = false
        videoView.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        videoView.topAnchor.constraint(equalTo: hash_image.bottomAnchor, constant: 5).isActive = true
        videoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        view.addSubview(loader)
        
        loader.center = self.view.center
        
        loader.color = UIColor.white
        
        view.addSubview(no_result)
        
        no_result.translatesAutoresizingMaskIntoConstraints = false
        no_result.widthAnchor.constraint(equalToConstant: 150).isActive = true
        no_result.heightAnchor.constraint(equalToConstant: 30).isActive = true
        no_result.topAnchor.constraint(equalTo: hash_image.bottomAnchor, constant: 15).isActive = true
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
        
        view.addSubview(retry)
               
        retry.translatesAutoresizingMaskIntoConstraints = false
        retry.heightAnchor.constraint(equalToConstant: 30).isActive = true
        retry.widthAnchor.constraint(equalToConstant: 150).isActive = true
        retry.topAnchor.constraint(equalTo: self.view.topAnchor, constant: (screenSize.height/2)).isActive = true
        retry.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: (screenSize.width/2)-65).isActive = true

        retry.setTitle("Retry", for: .normal)
        retry.setTitleColor(UIColor(hex: "10A5F9"), for: .normal)
        retry.layer.borderWidth = 1
        retry.layer.borderColor = UIColor(hex: "10A5F9")?.cgColor
        retry.layer.cornerRadius = 5.0

        retry.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        retry.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12.0)
        retry.isHidden = true
    }
    
    
    @objc func refresh() {
         self.retry.isHidden = true
         fetchHashTag()
    }
    
    func fetchHashTag() {
        
        if (isLoading) {
            return
        }
        
        isLoading = true
        loader.isHidden = false
        loader.startAnimating()
        
        var headers: HTTPHeaders?
        
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
            headers = ["Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        
        let parameters: [String: Any] = [
            "ChallengeHash": hash_tag.title,
            "language_id":"\(UserDefaults.standard.getValueForLanguageId().unsafelyUnwrapped)"
        ]
        
        let url = "https://www.boloindya.com/api/v1/get_challenge_details/"
        
        print(url)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
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
                            self.retry.isHidden = false
                            self.isLoading = false
                            print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    self.retry.isHidden = false
                    self.isLoading = false
                    print(error)
                }
        }
        
    }
    
    func fetchData() {
        
        if (isLoading || isFinished) {
            return
        }
        
        isLoading = true
        
        var headers: HTTPHeaders? = nil
        
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
            headers = ["Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        
        let url = "https://www.boloindya.com/api/v1/get_challenge/?challengehash="+hash_tag.title+"&page=\(page)&language_id=\(UserDefaults.standard.getValueForLanguageId().unsafelyUnwrapped)"
        
        print(url)
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
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
                                self.videoView.reloadData()
                            }
                            if self.topics.count == 0 {
                                self.no_result.isHidden = false
                            }
                            self.loader.isHidden = true
                            self.loader.stopAnimating()
                        }
                        catch {
                            if self.page == 1 {
                                self.retry.isHidden = false
                            }
                            self.loader.isHidden = true
                            self.loader.stopAnimating()
                            self.isLoading = false
                            print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    if self.page == 1 {
                        self.retry.isHidden = false
                    }
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserVideoCell", for: indexPath) as! HashTagViewCell
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
            self.fetchData()
        }
    }
    
}

class HashTagViewCell: UICollectionViewCell {
    
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

        
        video_title.translatesAutoresizingMaskIntoConstraints = false
        video_title.heightAnchor.constraint(equalToConstant: 40).isActive = true
        video_title.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        video_title.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        video_title.bottomAnchor.constraint(equalTo: view_image.topAnchor, constant: 0).isActive = true
        video_title.textColor = UIColor.white
        
        video_title.font = UIFont.boldSystemFont(ofSize: 13.0)
        video_title.numberOfLines = 2
        
    }
}
