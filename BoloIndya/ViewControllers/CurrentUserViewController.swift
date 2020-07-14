//
//  CurrentUserViewController.swift
//  BoloIndya
//
//  Created by apple on 7/10/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Alamofire

class CurrentUserViewController: UIViewController {
    
    @IBOutlet weak var more: UIButton!
    
    @IBOutlet weak var cover_pic: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var bio: UILabel!
    
    @IBOutlet weak var profile_pic: UIImageView!
        
    var isLoading: Bool = false
    var page: Int = 1
    var topics: [Topic] = []
    var selected_position: Int = 0
    var isFinished: Bool = false

    var transparentView = UIView()
    var tableView = UITableView()
    
    var userVideoView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    let menuArray = ["Refer And Earn", "Bolo Action Insights", "Update Interests", "Choose Language", "Send Feedback", "Terms and Conditions", "Log Out"]
    
    let height = CGFloat(400)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Current User")
        self.navigationController?.isNavigationBarHidden = true
        setUserData()
        setTableView()
        setUserVideoView()
        fetchData()
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
    

    func setUserData() {
        if (!(UserDefaults.standard.getCoverPic() ?? "").isEmpty) {
            let url = URL(string: UserDefaults.standard.getCoverPic() ?? "")
            self.cover_pic.kf.setImage(with: url)
        }
        if (!(UserDefaults.standard.getProfilePic() ?? "").isEmpty) {
            let url = URL(string: UserDefaults.standard.getProfilePic() ?? "")
            self.profile_pic.layer.cornerRadius = 45.0
            
            self.profile_pic.kf.setImage(with: url)
        }
        
        self.name.text = UserDefaults.standard.getName()
        self.bio.text = UserDefaults.standard.getBio()
    }
    
    func setUserVideoView() {
        let screenSize = UIScreen.main.bounds.size
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: (screenSize.width/3.4), height: (screenSize.width/3.4) * 1.5)
        userVideoView.collectionViewLayout = layout
        
        userVideoView.delegate = self
        userVideoView.dataSource = self
        userVideoView.backgroundColor = UIColor.clear
        userVideoView.register(UserVideoCollectionViewCell.self, forCellWithReuseIdentifier: "UserVideoCell")
        self.view.addSubview(userVideoView)
        
        self.userVideoView.frame = CGRect(x: 0, y: 310, width: screenSize.width, height: screenSize.height-((self.tabBarController?.tabBar.frame.size.height ?? 49.0)+298))
    }
    
    func setTableView() {
        tableView.isScrollEnabled = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    @IBAction func onMoreOptionClick(_ sender: Any) {
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparentView.frame = self.view.frame
        self.view.addSubview(transparentView)
        
        let screenSize = UIScreen.main.bounds.size
        tableView.frame = CGRect(x: 0, y: screenSize.height - self.height, width: screenSize.width, height: height)
        self.view.addSubview(tableView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickTransparentView))
        transparentView.addGestureRecognizer(tapGesture)
        
        transparentView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: 0, y: screenSize.height - self.height, width: screenSize.width, height: self.height)}, completion: nil)
    }
    
    @objc func onClickTransparentView() {
        let screenSize = UIScreen.main.bounds.size
        transparentView.alpha = 0
        self.tableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.height)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is VideoViewController {
            let vc = segue.destination as? VideoViewController
            vc?.videos = topics
            vc?.selected_position = selected_position
        }
    }
    
    func fetchData() {

        if (isLoading || isFinished) {
            return
        }
        
        isLoading = true
        
        let headers: [String: Any] = [
            "Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        
        let url = "https://www.boloindya.com/api/v1/get_vb_list/?user_id=\(UserDefaults.standard.getUserId().unsafelyUnwrapped)&page=\(page)"
        
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
}

extension CurrentUserViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menucell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MenuViewCell
        menucell.settingLabel.text = menuArray[indexPath.row]
        menucell.settingImage.image = UIImage(named: "notification")
        return menucell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        self.onClickTransparentView()
        switch indexPath.row {
        case 2:
            self.tabBarController?.tabBar.isHidden = true
            performSegue(withIdentifier: "updateInterset", sender: self)
            break
        case 3:
            self.tabBarController?.tabBar.isHidden = true
            performSegue(withIdentifier: "chooseLanguage", sender: self)
            break
        case 4:
            self.tabBarController?.tabBar.isHidden = true
            performSegue(withIdentifier: "feedbackUser", sender: self)
            break
        case 5:
            self.tabBarController?.tabBar.isHidden = true
            performSegue(withIdentifier: "termsPages", sender: self)
            break
        case 6:
            let defaults = UserDefaults.standard
            let language_id = defaults.getValueForLanguageId()
            let dictionary = defaults.dictionaryRepresentation()
            dictionary.keys.forEach {key in
                defaults.removeObject(forKey: key)
            }
            UserDefaults.standard.setValueForLanguageId(value: language_id)
            self.tabBarController?.selectedIndex = 0
            break
        default:
            break
        }
    }
}

extension CurrentUserViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.tabBarController?.tabBar.isHidden = true
        performSegue(withIdentifier: "VideoView", sender: self)
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

