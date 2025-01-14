//
//  DiscoverViewController.swift
//  BoloIndya
//
//  Created by apple on 7/10/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class DiscoverViewController: UIViewController, CategoryCellDelegate {
    var discoverView = UITableView()
    var categoryView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var progress = UIActivityIndicatorView()
    
    var hash_tag: [HashTag] = []
    var categories: [Category] = []
    var banners: [BICampaignModel] = []
    var page = 1
    var isLoading = false
    var category_name = "Fitness"
    var category_id = "68"
    var current_hash_tag: HashTag = HashTag()
    var selected_position = 0
    let screenSize = UIScreen.main.bounds.size
    
    var search_text = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
        discoverView.register(SectionCell.self, forCellReuseIdentifier: "Cell")
        discoverView.register(DiscoverBannerTableCell.self, forCellReuseIdentifier: "DiscoverBannerTableCell")
        discoverView.backgroundColor = .clear
        discoverView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 10, right: 0)
        discoverView.isScrollEnabled = true
        discoverView.separatorStyle = .none
        discoverView.showsVerticalScrollIndicator = false
        discoverView.delegate = self
        discoverView.dataSource = self

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.estimatedItemSize = CGSize(width: (screenSize.width/4), height: 20)
        categoryView.collectionViewLayout = layout
        categoryView.frame = CGRect(x: 0, y: getStatusBarHeight()+60, width: screenSize.width, height: 30)
        categoryView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCell")
        categoryView.backgroundColor = .clear
        categoryView.delegate = self
        categoryView.dataSource = self
        categoryView.showsHorizontalScrollIndicator = false

        view.addSubview(search_text)
        view.addSubview(discoverView)
        view.addSubview(categoryView)
        view.addSubview(progress)

        search_text.translatesAutoresizingMaskIntoConstraints = false
        search_text.heightAnchor.constraint(equalToConstant: 40).isActive = true
        search_text.topAnchor.constraint(equalTo: self.view.topAnchor, constant: getStatusBarHeight()+10).isActive = true
        search_text.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 5).isActive = true
        search_text.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5).isActive = true
        search_text.layer.cornerRadius = 10.0
        search_text.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.8470588235)
        
        search_text.textColor = UIColor.white
        search_text.placeholder = "Search"
        search_text.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        let paddingViewFeed = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: search_text.frame.height))
        search_text.leftView = paddingViewFeed
        search_text.leftViewMode = .always
        
        search_text.font = UIFont.boldSystemFont(ofSize: 12.0)
        search_text.delegate = self
        
        progress.center = view.center
        
        progress.color = UIColor.white
        
        let category = Category()
        category.title = "What's New"
        categories.append(category)

        fetchCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
        checkCampaingDeeplionk()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
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
        } else if segue.destination is SearchViewController{
            let vc = segue.destination as? SearchViewController
            vc?.search_text = "\(search_text.text.unsafelyUnwrapped)".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            search_text.text = ""
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func checkCampaingDeeplionk() {
        guard let campaign = BIDeeplinkHandler.campaignHashtag else { return }
        
        fetchBannerHashTags() { [weak self] in
            if let banner = self?.banners.first(where: { $0.hashtagName == campaign }) {
                let vc = BIBannerLandingViewController.loadFromNib()
                vc.banner = banner
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
            BIDeeplinkHandler.campaignHashtag = nil
        }
    }
    
    func fetchCategories() {
        progress.isHidden = false
        progress.startAnimating()
        
        AF.request("https://www.boloindya.com/api/v1/get_sub_category", method: .get, parameters: nil, encoding: URLEncoding.default)
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
                            
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    print(error)
                }
                
                self.fetchBannerHashTags() { [weak self] in
                    if let wSelf = self {
                        let viewInsets = wSelf.view.safeAreaInsets
                        wSelf.discoverView.frame = CGRect(x: 0,
                                                          y: wSelf.getStatusBarHeight() + 100,
                                                          width: wSelf.screenSize.width,
                                                          height: wSelf.screenSize.height - viewInsets.top - wSelf.search_text.bounds.height - (wSelf.tabBarController?.tabBar.frame.size.height ?? 49.0) - viewInsets.bottom)
                    }
                    
                    self?.fetchHashData()
                }
            }
    }
    
    func fetchBannerHashTags(completion: @escaping () -> Void) {
        var headers: HTTPHeaders?
        if let token = UserDefaults.standard.getAuthToken(), !token.isEmpty {
            headers = ["Authorization": "Bearer \(token)"]
        }
        
        AF.request("https://www.boloindya.com/api/v1/get_campaigns/", method: .post, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseString { [weak self] (responseData) in
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                        do {
                            let model = try JSONDecoder().decode(BICamapignStatusMessageModel.self, from: json_data)
                            self?.banners = model.message
                            self?.discoverView.reloadData()
                        } catch {
                            print(error)
                        }
                    }
                case.failure(let error):
                    print(error)
                }
                
                completion()
            }
   }
    
    func fetchHashData() {
        if page == 1 {
            progress.isHidden = false
            discoverView.isHidden = true
        }
        
        let url = "https://www.boloindya.com/api/v1/get_hash_discover/?language_id=\(UserDefaults.standard.getValueForLanguageId().unsafelyUnwrapped)&page=\(page)"
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
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
                            self.discoverView.isHidden = false
                            self.isLoading = false
                            self.page += 1
                            self.discoverView.reloadData()
                            self.progress.isHidden = true
                            self.progress.stopAnimating()
                            self.fetchData()
                        }
                    }
                    catch {
                        self.isLoading = false
                        self.discoverView.isHidden = false
                        self.progress.isHidden = true
                        self.progress.stopAnimating()
                        print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    self.progress.stopAnimating()
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
        
        var headers: HTTPHeaders? = nil
        
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
    
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
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
                                                self.hash_tag[i].videos.append(getTopicFromJson(each: each_data))
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
    
    func goToCategory(with category: Category) {
        category_name = category.title
        category_id = "\(category.id)"
        self.performSegue(withIdentifier: "CategoryView", sender: self)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
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

extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return hash_tag.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if banners.isEmpty {
                return CGFloat.leastNormalMagnitude
            } else {
                return CGFloat(0.3797) * tableView.bounds.width
            }
        }
        
        return ((screenSize.width/3.4)*1.5)+50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverBannerTableCell") as! DiscoverBannerTableCell
            cell.configure(banner: banners)
            cell.delegate = self
            
            return cell
        }
        
        let video_cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SectionCell
        video_cell.setVideo(hash_tag: hash_tag[indexPath.row])
        video_cell.delegate = self
        return video_cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            (cell as? DiscoverBannerTableCell)?.bannerTimer?.invalidate()
            (cell as? DiscoverBannerTableCell)?.bannerTimer = nil
        }
    }
}

extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
        cell.configure(with: categories[indexPath.row])
        if indexPath.row == 0 {
            cell.name.textColor = UIColor(hex: "10A5F9")
        } else {
            cell.name.textColor = UIColor.white
        }
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = categories[indexPath.row].title
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.sizeToFit()
        return CGSize(width: label.frame.width, height: 20)
    }
}

extension DiscoverViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.search_text.resignFirstResponder()
        self.performSegue(withIdentifier: "searchPage", sender: self)
        self.tabBarController?.tabBar.isHidden = true
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
}

extension DiscoverViewController: DiscoverBannerTableCellDelegate {
    func goToBanner(banner: BICampaignModel) {
        let vc = BIBannerLandingViewController.loadFromNib()
        vc.banner = banner
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
