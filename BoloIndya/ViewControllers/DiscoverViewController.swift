//
//  DiscoverViewController.swift
//  BoloIndya
//
//  Created by apple on 7/10/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Alamofire

class DiscoverViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, CategoryCellDelegate, UICollectionViewDelegateFlowLayout {
    
    func goToCategory(with category: Category) {
        category_name = category.title
        category_id = "\(category.id)"
        self.performSegue(withIdentifier: "CategoryView", sender: self)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
        cell.configure(with: categories[indexPath.row])
        if (indexPath.row == 0) {
            cell.name.textColor = UIColor.red
        } else {
            cell.name.textColor = UIColor.white
        }
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = categories[indexPath.row].title
        label.font = UIFont.boldSystemFont(ofSize: 13.0)
        label.sizeToFit()
        return CGSize(width: label.frame.width, height: 20)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hash_tag.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let video_cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SectionCell
        video_cell.setVideo(hash_tag: hash_tag[indexPath.row])
        video_cell.delegate = self
        return video_cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    var discoverView = UITableView()
    var categoryView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    var progress = UIActivityIndicatorView()
    
    var hash_tag: [HashTag] = []
    var categories: [Category] = []
    var page: Int = 1
    var isLoading: Bool = false
    var category_name: String = "Fitness"
    var category_id: String = "68"
    var current_hash_tag: HashTag = HashTag()
    var selected_position: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Discover")
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
        discoverView.isScrollEnabled = true
        discoverView.isPagingEnabled = true
        
        discoverView.delegate = self
        discoverView.dataSource = self
        discoverView.register(SectionCell.self, forCellReuseIdentifier: "Cell")
        discoverView.backgroundColor = .clear
        
        let screenSize = UIScreen.main.bounds.size
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.estimatedItemSize = CGSize(width: (screenSize.width/4), height:20)
        categoryView.collectionViewLayout = layout
        categoryView.frame = CGRect(x: 0, y: 30, width: screenSize.width, height: 30)
        categoryView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCell")
        categoryView.backgroundColor = .clear
        categoryView.delegate = self
        categoryView.dataSource = self
        
        view.addSubview(discoverView)
        view.addSubview(categoryView)
        
        view.addSubview(progress)
        
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.widthAnchor.constraint(equalToConstant: 60).isActive = true
        progress.heightAnchor.constraint(equalToConstant: 60).isActive = true
        progress.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        progress.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        
        let category = Category()
        category.title = "What's New"
        categories.append(category)
    
        self.discoverView.frame = CGRect(x: 0, y: 60, width: screenSize.width, height: screenSize.height-(self.tabBarController?.tabBar.frame.size.height ?? 49.0))
        
        fetchCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func fetchCategories() {
        
        Alamofire.request("https://www.boloindya.com/api/v1/get_sub_category", method: .get, parameters: nil, encoding: URLEncoding.default)
            .responseString  { (responseData) in
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                    do {
                        if let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [[String: Any]] {
                            for each in json_object {
                                let category = Category()
                                category.title = each["title"] as! String
                                category.id = each["id"] as! Int
                                self.categories.append(category)
                            }
                        }
                        
                        self.categoryView.reloadData()
                        self.fetchHashData()
                    }
                    catch {
                        self.fetchHashData()
                        print(error.localizedDescription)
                    }
                }
            case.failure(let error):
                self.fetchHashData()
                print(error)
            }
        }
    }
    
    func fetchHashData() {
        
        if (page == 1) {
            progress.isHidden = false
            discoverView.isHidden = true
        }
        
        let url = "https://www.boloindya.com/api/v1/get_hash_discover/?language_id=\(UserDefaults.standard.getValueForLanguageId().unsafelyUnwrapped)&page=\(page)"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseString  { (responseData) in
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                    
                    do {
                        let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                        if let content = json_object?["results"] as? [[String:Any]] {
                            for each in content {
                                let hash = HashTag()
                                hash.total_views = each["total_views"] as! String
                                let each_data = each["tongue_twister"] as? [String:Any]
                                hash.id = each_data?["id"] as! Int
                                hash.title = each_data?["hash_tag"] as! String
                                self.hash_tag.append(hash)
                            }

                            self.progress.isHidden = true
                            self.discoverView.isHidden = false
                            self.isLoading = false
                            self.page += 1
                            self.discoverView.reloadData()
                            self.fetchData()
                        }
                    }
                    catch {
                        self.isLoading = false
                        self.progress.isHidden = true
                        self.discoverView.isHidden = false
                        print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    self.isLoading = false
                    self.progress.isHidden = true
                    self.discoverView.isHidden = false
                    print(error)
                }
        }
    }
    
    func fetchData() {
        
        if isLoading {
            return
        }
        
        isLoading = true
        
        var headers: [String: Any]? = nil
        
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
        headers = [
            "Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        
        var hash_ids = ""
        var count = 0
        for i in 0...(self.hash_tag.count-1) {
           if hash_tag[i].videos.count == 0 {
                if count == 2 || i == (self.hash_tag.count-1) {
                    hash_ids = hash_ids + "\(hash_tag[i].id)"
                    break
                }
                hash_ids = hash_ids + "\(hash_tag[i].id)" + ","
                count += 1
            }
        }
        
        if hash_ids.count == 0 {
            return
        }
        
        let url = "https://www.boloindya.com/api/v1/get_popular_hash_tag/?language_id=\(UserDefaults.standard.getValueForLanguageId().unsafelyUnwrapped)&hashtag_ids="+hash_ids
    
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers as? HTTPHeaders)
            .responseString  { (responseData) in
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                    do {
                        let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                        if let content = json_object?["results"] as? [[String:Any]] {
                            for each in content {
                                for i in 0...(self.hash_tag.count-1) {
                                    if self.hash_tag[i].id == (each["id"] as? Int ?? 0) {
                                        if let topic_content = each["topics"] as? [[String:Any]] {
                                            for each_data in topic_content {
                                                let user = User()
                                                let user_obj = each_data["user"] as? [String:Any]
                                                let user_profile_obj = user_obj?["userprofile"] as? [String:Any]
                                                user.setId(id: (user_obj?["id"] as? Int ?? 0))
                                                user.setUserName(username: user_obj?["username"] as? String ?? "")
                                                
                                                user.setName(name: user_profile_obj?["name"] as? String ?? "")
                                                user.setBio(bio: user_profile_obj?["bio"] as? String ?? "")
                                                user.setCoverPic(cover_pic: user_profile_obj?["cover_pic"] as? String ?? "")
                                                user.setProfilePic(profile_pic: user_profile_obj?["profile_pic"] as? String ?? "")
                                                
                                                let topic = Topic(user: user)
                                                topic.setTitle(title: each_data["title"] as? String ?? "")
                                                topic.setThumbnail(thumbail: each_data["question_image"] as? String ?? "")
                                                
                                                topic.video_url = each_data["video_cdn"] as? String ?? ""
                                                self.hash_tag[i].videos.append(topic)
                                            }
                                        }
                                        break
                                    }
                                }
                            }
                            self.isLoading = false
                            self.page += 1
                            self.discoverView.reloadData()
                            self.fetchData()
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
        if segue.destination is HashTagViewController {
            let vc = segue.destination as? HashTagViewController
            vc?.hash_tag = current_hash_tag
        } else if segue.destination is VideoViewController {
            let vc = segue.destination as? VideoViewController
            vc?.videos = current_hash_tag.videos
            vc?.selected_position = selected_position
        } else if segue.destination is CategoryViewController {
            let vc = segue.destination as? CategoryViewController
            vc?.name = category_name
            vc?.id = category_id
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}


extension DiscoverViewController: SectionCellDelegate {
    func goToVideos(with hash_tag: HashTag, position: Int) {
        self.current_hash_tag = hash_tag
        self.selected_position = position
        self.performSegue(withIdentifier: "HashVideoView", sender: self)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func goToHashTag(with hash_tag: HashTag) {
        self.current_hash_tag = hash_tag
        self.performSegue(withIdentifier: "HashTagView", sender: self)
        self.tabBarController?.tabBar.isHidden = true
    }
    
}

protocol SectionCellDelegate {
    func goToHashTag(with hash_tag: HashTag)
    
    func goToVideos(with hash_tag: HashTag, position: Int)
}

class SectionCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var title = UILabel()
    var front_image = UIImageView()
    var views = UILabel()
    var hash_tag: HashTag = HashTag()

    var delegate: SectionCellDelegate?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hash_tag.videos.count == 0 ? 5 : self.hash_tag.videos.count
    }
    
    func setVideo(hash_tag: HashTag) {
        self.hash_tag = hash_tag
        title.text = "#"+self.hash_tag.title
    
        title.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToHashTag(_:)))
        title.addGestureRecognizer(tapGesture)
        views.text = self.hash_tag.total_views
        
        views.isUserInteractionEnabled = true
        
        let tapGestureViews = UITapGestureRecognizer(target: self, action: #selector(goToHashTag(_:)))
        views.addGestureRecognizer(tapGestureViews)
        
        userVideoView.reloadData()
    }
    
    @objc func goToHashTag(_ sender: UITapGestureRecognizer) {
        delegate?.goToHashTag(with: hash_tag)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserVideoCell", for: indexPath) as! UserVideoCollectionViewCell
        if (indexPath.row < hash_tag.videos.count) {
            cell.configure(with: hash_tag.videos[indexPath.row])
        }
        return cell
    }
    
    var userVideoView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.black
        
        addSubview(userVideoView)
        addSubview(title)
        addSubview(front_image)
        addSubview(views)
        
        setOtherViews()
        setTitleAttribute()
        
        let screenSize = UIScreen.main.bounds.size
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: (screenSize.width/3.4), height: 110)
        userVideoView.collectionViewLayout = layout
        userVideoView.frame = CGRect(x: 0, y: 30, width: screenSize.width, height: 120)
        userVideoView.register(UserVideoCollectionViewCell.self, forCellWithReuseIdentifier: "UserVideoCell")
        userVideoView.delegate = self
        userVideoView.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/3.4), height: 120)
    }
    
    func setTitleAttribute() {
    
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        title.rightAnchor.constraint(equalTo: views.leftAnchor, constant: -10).isActive = true
        title.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        title.font = UIFont.boldSystemFont(ofSize: 14.0)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.numberOfLines = 1
        title.textColor = UIColor.white
        title.text = "#"+self.hash_tag.title
    }
    
    func setOtherViews() {
        
        front_image.translatesAutoresizingMaskIntoConstraints = false
        front_image.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        front_image.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        front_image.widthAnchor.constraint(equalToConstant: 20).isActive = true
        front_image.heightAnchor.constraint(equalToConstant: 20).isActive = true
        front_image.image = UIImage(named: "forward")
        front_image.contentMode = .scaleAspectFit
        
        views.translatesAutoresizingMaskIntoConstraints = false
        views.rightAnchor.constraint(equalTo: front_image.leftAnchor, constant: -5).isActive = true
        views.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        views.textAlignment = .right
        views.font = UIFont.boldSystemFont(ofSize: 14.0)
        views.heightAnchor.constraint(equalToConstant: 20).isActive = true
        views.textColor = UIColor.white
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.goToVideos(with: hash_tag, position: indexPath.row)
    }
    
}
