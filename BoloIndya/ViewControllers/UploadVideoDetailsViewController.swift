//
//  UploadVideoDetailsViewController.swift
//  BoloIndya
//
//  Created by apple on 8/5/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import SVProgressHUD

class UploadVideoDetailsViewController: UIViewController {
    
    var image: UIImage!
    var video_url: URL!
    
    var upper_tab = UIView()
    var back_image = UIImageView()
    var label = UILabel()
    var tick_image = UIImageView()
    
    var thumb = UIImageView()
    var topic_title = UITextField()
    
    var choose_category = UILabel()
    var add_hashtag = UILabel()
    
    var choose_category_label = UILabel()
    var add_hashtag_label = UILabel()
    
    var choose_language = UILabel()
    
    var actions_stack = UIStackView()
    
    var hash_tag = UIView()
    var enter_hash = UITextField()
    var hashView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    var languages: [Languages]!
    var categories: [Category] = []
    var hash_tags: [String] = []
    var selected_hash: [String] = []
    
    var transparentView = UIView()
    var selected_language: Languages!
    var selected_categories: [Int] = []
    var selected_categories_title: [String] = []
    var category_name = ""
    var add_hashtag_text = ""
    var isLoading: Bool = false
    var thumnail_url_upload = ""
    var video_url_upload = ""
    var time = ""
    
    var languageView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    var categoryView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    weak var contrain: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        NotificationCenter.default.addObserver(self, selector:  #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        let screenSize = UIScreen.main.bounds.size
        
        upper_tab.addSubview(back_image)
        upper_tab.addSubview(label)
        upper_tab.addSubview(tick_image)
        
        actions_stack.addArrangedSubview(choose_category)
        actions_stack.addArrangedSubview(choose_category_label)
        actions_stack.addArrangedSubview(add_hashtag)
        actions_stack.addArrangedSubview(add_hashtag_label)
        
        view.addSubview(upper_tab)
        view.addSubview(thumb)
        view.addSubview(topic_title)
        
        view.addSubview(actions_stack)
        
        view.addSubview(choose_language)
        
        upper_tab.translatesAutoresizingMaskIntoConstraints = false
        upper_tab.heightAnchor.constraint(equalToConstant: 40).isActive = true
        upper_tab.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 0).isActive = true
        upper_tab.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: 0).isActive = true
        upper_tab.topAnchor.constraint(equalTo: self.view.topAnchor, constant: getStatusBarHeight()).isActive = true
        
        upper_tab.layer.backgroundColor = #colorLiteral(red: 0.7098039216, green: 0.1568627451, blue: 0.1568627451, alpha: 0.8470588235)
        
        back_image.translatesAutoresizingMaskIntoConstraints = false
        back_image.heightAnchor.constraint(equalToConstant: 20).isActive = true
        back_image.widthAnchor.constraint(equalToConstant: 40).isActive = true
        back_image.centerYAnchor.constraint(equalTo: upper_tab.centerYAnchor,constant: 0).isActive = true
        back_image.leftAnchor.constraint(equalTo: upper_tab.leftAnchor,constant: 10).isActive = true
        
        back_image.isUserInteractionEnabled = true
        let tapGestureBack = UITapGestureRecognizer(target: self, action: #selector(goBack(_:)))
        back_image.addGestureRecognizer(tapGestureBack)
        
        back_image.image = UIImage(named: "back")
        back_image.contentMode = .scaleAspectFit
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.centerYAnchor.constraint(equalTo: upper_tab.centerYAnchor,constant: 0).isActive = true
        label.leftAnchor.constraint(equalTo: back_image.rightAnchor,constant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: tick_image.leftAnchor,constant: -10).isActive = true
        
        label.text = "Reach your audience"
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        tick_image.translatesAutoresizingMaskIntoConstraints = false
        tick_image.heightAnchor.constraint(equalToConstant: 20).isActive = true
        tick_image.widthAnchor.constraint(equalToConstant: 40).isActive = true
        tick_image.centerYAnchor.constraint(equalTo: upper_tab.centerYAnchor,constant: 0).isActive = true
        tick_image.rightAnchor.constraint(equalTo: upper_tab.rightAnchor,constant: -10).isActive = true
        
        tick_image.image = UIImage(named: "tick")
        tick_image.contentMode = .scaleAspectFit
        
        tick_image.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(uploadVideo(_:)))
        tick_image.addGestureRecognizer(tapGesture)
        
        thumb.translatesAutoresizingMaskIntoConstraints = false
        thumb.widthAnchor.constraint(equalToConstant: (screenSize.width*0.3)-10).isActive = true
        thumb.heightAnchor.constraint(equalToConstant: 130).isActive = true
        thumb.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        thumb.topAnchor.constraint(equalTo: upper_tab.bottomAnchor, constant: 10).isActive = true
        
        thumb.image = image
        thumb.layer.cornerRadius = (thumb.frame.height / 2)
        thumb.backgroundColor =  #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.8470588235)
        thumb.contentMode = .scaleAspectFit
        thumb.clipsToBounds = true
        
        topic_title.translatesAutoresizingMaskIntoConstraints = false
        topic_title.widthAnchor.constraint(equalToConstant: (screenSize.width*0.7)-20).isActive = true
        topic_title.heightAnchor.constraint(equalToConstant: 130).isActive = true
        topic_title.leftAnchor.constraint(equalTo: thumb.rightAnchor, constant: 10).isActive = true
        topic_title.topAnchor.constraint(equalTo: upper_tab.bottomAnchor, constant: 10).isActive = true
        
        topic_title.placeholder = "What is this video about?"
        topic_title.textColor = UIColor.white
        topic_title.backgroundColor =  #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.8470588235)
        topic_title.font = UIFont.boldSystemFont(ofSize: 12.0)
        
        topic_title.delegate = self
        topic_title.attributedPlaceholder = NSAttributedString(string: "What is this video about?", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        actions_stack.translatesAutoresizingMaskIntoConstraints = false
        actions_stack.widthAnchor.constraint(equalToConstant: (screenSize.width)-20).isActive = true
        actions_stack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        actions_stack.topAnchor.constraint(equalTo: thumb.bottomAnchor, constant: 10).isActive = true
        
        actions_stack.axis = .vertical
        actions_stack.spacing = CGFloat(15)
        
        choose_category.translatesAutoresizingMaskIntoConstraints = false
        choose_category.widthAnchor.constraint(equalToConstant: (screenSize.width)-20).isActive = true
        choose_category.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        choose_category.textColor = UIColor.white
        choose_category.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.8470588235)
        choose_category.text = "Choose Category"
        choose_category.font = UIFont.boldSystemFont(ofSize: 12.0)
        
        choose_category_label.translatesAutoresizingMaskIntoConstraints = false
        choose_category_label.widthAnchor.constraint(equalToConstant: (screenSize.width)-20).isActive = true
        choose_category_label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        choose_category_label.textColor = UIColor.white
        choose_category_label.font = UIFont.boldSystemFont(ofSize: 12.0)
        choose_category_label.numberOfLines = 1
        choose_category_label.isHidden = true
        
        choose_category.isUserInteractionEnabled = true
        let hideGestureCategory = UITapGestureRecognizer(target: self, action: #selector(hideUnhideCategory))
        choose_category.addGestureRecognizer(hideGestureCategory)
        
        add_hashtag.translatesAutoresizingMaskIntoConstraints = false
        add_hashtag.widthAnchor.constraint(equalToConstant: (screenSize.width)-20).isActive = true
        add_hashtag.heightAnchor.constraint(equalToConstant: 30).isActive = true
        add_hashtag.textColor = UIColor.white
        add_hashtag.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.8470588235)
        add_hashtag.font = UIFont.boldSystemFont(ofSize: 12.0)
        
        add_hashtag.text = "Add HashTags"
        
        add_hashtag_label.translatesAutoresizingMaskIntoConstraints = false
        add_hashtag_label.widthAnchor.constraint(equalToConstant: (screenSize.width)-20).isActive = true
        add_hashtag_label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        add_hashtag_label.textColor = UIColor.white
        add_hashtag_label.font = UIFont.boldSystemFont(ofSize: 12.0)
        add_hashtag_label.numberOfLines = 2
        add_hashtag_label.isHidden = true
        
        add_hashtag.isUserInteractionEnabled = true
        let hideGestureHash = UITapGestureRecognizer(target: self, action: #selector(hideUnhideHashTag(_:)))
        add_hashtag.addGestureRecognizer(hideGestureHash)
        
        choose_language.translatesAutoresizingMaskIntoConstraints = false
        choose_language.widthAnchor.constraint(equalToConstant: (screenSize.width)-20).isActive = true
        choose_language.heightAnchor.constraint(equalToConstant: 30).isActive = true
        choose_language.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        choose_language.topAnchor.constraint(equalTo: actions_stack.bottomAnchor, constant: 10).isActive = true
        choose_language.textColor = UIColor.white
        choose_language.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.8470588235)
        choose_language.font = UIFont.boldSystemFont(ofSize: 12.0)
        choose_language.numberOfLines = 2
        choose_language.text = "Choose Language"
        
        choose_language.isUserInteractionEnabled = true
        let hideGestureLanguage = UITapGestureRecognizer(target: self, action: #selector(hideUnhideLanguage))
        choose_language.addGestureRecognizer(hideGestureLanguage)
        
        languages = getLanguages()
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        transparentView.frame = self.view.frame
        
        view.addSubview(transparentView)
        
        let tapGestureTransparent = UITapGestureRecognizer(target: self, action: #selector(onClickTransparentView))
        transparentView.addGestureRecognizer(tapGestureTransparent)
        
        transparentView.isHidden = true
        
        view.addSubview(languageView)
        
        languageView.isScrollEnabled = true
        languageView.delegate = self
        languageView.dataSource = self
        languageView.backgroundColor = #colorLiteral(red: 0.7098039216, green: 0.1568627451, blue: 0.1568627451, alpha: 0.8470588235)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (languageView.frame.width/2.4), height: 30)
        languageView.collectionViewLayout = layout
        
        languageView.register(UploadLanguageCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        languageView.translatesAutoresizingMaskIntoConstraints = false
        languageView.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 0).isActive = true
        languageView.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: 0).isActive = true
        languageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        languageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10).isActive = true
        languageView.layer.cornerRadius = 10
        
        languageView.isHidden = true
        
        view.addSubview(categoryView)
        
        categoryView.isScrollEnabled = true
        categoryView.delegate = self
        categoryView.dataSource = self
        categoryView.backgroundColor = #colorLiteral(red: 0.7098039216, green: 0.1568627451, blue: 0.1568627451, alpha: 0.8470588235)
        
        let layout_cat = UICollectionViewFlowLayout()
        layout_cat.itemSize = CGSize(width: (categoryView.frame.width/2.4), height: 50)
        categoryView.collectionViewLayout = layout_cat
        
        categoryView.register(CategoryUploadCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        categoryView.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 0).isActive = true
        categoryView.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: 0).isActive = true
        categoryView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        categoryView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10).isActive = true
        categoryView.layer.cornerRadius = 10
        
        categoryView.isHidden = true
        
        hash_tag.addSubview(enter_hash)
        hash_tag.addSubview(hashView)
        
        view.addSubview(hash_tag)
        
        hash_tag.translatesAutoresizingMaskIntoConstraints = false
        hash_tag.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 0).isActive = true
        hash_tag.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: 0).isActive = true
        hash_tag.heightAnchor.constraint(equalToConstant: 230).isActive = true
        contrain = hash_tag.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10)
        contrain.isActive = true
        hash_tag.layer.cornerRadius = 10
        
        enter_hash.translatesAutoresizingMaskIntoConstraints = false
        enter_hash.leftAnchor.constraint(equalTo: hash_tag.leftAnchor,constant: 10).isActive = true
        enter_hash.rightAnchor.constraint(equalTo: hash_tag.rightAnchor,constant: 10).isActive = true
        enter_hash.heightAnchor.constraint(equalToConstant: 20).isActive = true
        enter_hash.bottomAnchor.constraint(equalTo: hash_tag.bottomAnchor, constant: -20).isActive = true
        
        enter_hash.placeholder = "Enter HashTag"
        enter_hash.textColor = UIColor.white
        enter_hash.attributedPlaceholder = NSAttributedString(string: "Enter HashTag", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        enter_hash.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        enter_hash.delegate = self
        enter_hash.addTarget(self, action: #selector(didChange(_:)), for: .editingChanged)
        
        hashView.isScrollEnabled = true
        hashView.delegate = self
        hashView.dataSource = self
        hashView.backgroundColor = .clear
        hash_tag.layer.backgroundColor = #colorLiteral(red: 0.7098039216, green: 0.1568627451, blue: 0.1568627451, alpha: 0.8470588235)
        
        let layout_hash = UICollectionViewFlowLayout()
        layout_hash.itemSize = CGSize(width: (hashView.frame.width/2.4), height: 50)
        hashView.collectionViewLayout = layout_hash
        
        hashView.register(HashUploadCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        hashView.translatesAutoresizingMaskIntoConstraints = false
        hashView.leftAnchor.constraint(equalTo: hash_tag.leftAnchor,constant: 10).isActive = true
        hashView.rightAnchor.constraint(equalTo: hash_tag.rightAnchor,constant: -10).isActive = true
        hashView.topAnchor.constraint(equalTo: hash_tag.topAnchor, constant: 10).isActive = true
        hashView.bottomAnchor.constraint(equalTo: enter_hash.topAnchor, constant: -10).isActive = true
        hashView.layer.cornerRadius = 10
        
        hash_tag.isHidden = true
        
        let asset = AVAsset(url: video_url)
        let duration = asset.duration
        let durationTime = Int(duration.seconds)
        time = String(format: "%02d:%02d", durationTime/60 , durationTime % 60)
    }
    
    @objc internal func keyboardWillShow(_ notification: NSNotification?) {
        var _kbSize: CGSize!
        
        if let info = notification?.userInfo {
            let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
            if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
                let screenSize = UIScreen.main.bounds
                let intersectRect = kbFrame.intersection(screenSize)
                if intersectRect.isNull {
                    _kbSize = CGSize(width: screenSize.size.width, height: 0)
                } else {
                    _kbSize = intersectRect.size
                    contrain.constant = -(_kbSize.height)
                    
                }
            }
        }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func uploadVideo(_ sender: Any) {
        
        if (self.topic_title.text ?? "").isEmpty {
            let alert = UIAlertController(title: "Please enter title to proceed.", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        if self.selected_language == nil {
            let alert = UIAlertController(title: "Please select language to proceed.", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        if self.selected_categories.count == 0 {
            let alert = UIAlertController(title: "Please select category to proceed.", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        var headers: HTTPHeaders!
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
            headers = [
                "Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        
        let timeStamp = Int(NSDate().timeIntervalSince1970)
        
        let file_name = "\(timeStamp).mp4"
        
        DispatchQueue.main.async {
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.setContainerView(self.view)
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(self.video_url, withName: "media", fileName: file_name, mimeType: "video/mp4")
        }, to: "https://www.boloindya.com/api/v1/upload_video_to_s3_for_app/", headers: headers) {
            (result) in
            switch result {
            case .success( let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    DispatchQueue.main.async {
                        SVProgressHUD.setDefaultMaskType(.black)
                        SVProgressHUD.showProgress(Float(progress.fractionCompleted), status: "Uploading \(Int(Float(progress.fractionCompleted)*100))%")
                        
                    }
                })
                
                upload.responseString  { (responseData) in
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                    }
                    switch responseData.result {
                    case.success(let data):
                        if let json_data = data.data(using: .utf8) {
                            do {
                                if let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: Any] {
                                    if !(json_object["body"] as? String ?? "").isEmpty {
                                        self.video_url_upload = json_object["body"] as! String
                                        self.uploadImage()
                                    } else {
                                        DispatchQueue.main.async {
                                            SVProgressHUD.dismiss()
                                        }
                                        DispatchQueue.main.async {
                                            SVProgressHUD.showError(withStatus: "Please Try Again")
                                        }
                                    }
                                }
                                
                            }
                            catch {
                                DispatchQueue.main.async {
                                    SVProgressHUD.dismiss()
                                }
                                DispatchQueue.main.async {
                                    SVProgressHUD.showError(withStatus: "Please Try Again")
                                }
                                print(error.localizedDescription)
                            }
                        }
                    case.failure(let error):
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                        }
                        DispatchQueue.main.async {
                            SVProgressHUD.showError(withStatus: "Please Try Again")
                        }
                        print(error)
                    }
                }
                
            case .failure(let encodingError):
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
                DispatchQueue.main.async {
                    SVProgressHUD.showError(withStatus: "Please Try Again")
                }
                print(encodingError)
            }
        }
        
    }
    
    func uploadImage() {
        
        var headers: HTTPHeaders!
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
            headers = [
                "Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        
        let imageData = image.jpegData(compressionQuality: 1)
        
        let timeStamp = Int(NSDate().timeIntervalSince1970)
        
        let file_name = "\(timeStamp).jpeg"
        
        DispatchQueue.main.async {
            SVProgressHUD.show(withStatus: "Getting Ready")
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData!, withName: "media", fileName: file_name, mimeType: "image/jpg")
        }, to: "https://www.boloindya.com/api/v1/upload_video_to_s3_for_app/", headers: headers) {
            (result) in
            switch result {
            case .success( let upload, _, _):
                
                upload.responseString  { (responseData) in
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                    }
                    switch responseData.result {
                    case.success(let data):
                        if let json_data = data.data(using: .utf8) {
                            do {
                                if let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: Any] {
                                    if !(json_object["body"] as? String ?? "").isEmpty {
                                        self.thumnail_url_upload = json_object["body"] as! String
                                        self.create_topic()
                                    } else {
                                        self.thumnail_url_upload = ""
                                        self.create_topic()
                                    }
                                }
                                
                            }
                            catch {
                                self.thumnail_url_upload = ""
                                self.create_topic()
                                print(error.localizedDescription)
                            }
                        }
                        case.failure(let error):
                        self.thumnail_url_upload = ""
                        self.create_topic()
                        print(error)
                    }
                }
                
            case .failure(let encodingError):
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
                self.thumnail_url_upload = ""
                self.create_topic()
                print(encodingError)
            }
        }
    }
    
    func create_topic() {
        
        DispatchQueue.main.async {
            SVProgressHUD.show(withStatus: "Getting Ready")
        }
        
        video_url_upload = video_url_upload.replacingOccurrences(of: "s3.ap-south-1.amazonaws.com/in-boloindya", with: "in-boloindya.s3.ap-south-1.amazonaws.com", options: .regularExpression, range: nil)
        thumnail_url_upload = thumnail_url_upload.replacingOccurrences(of: "s3.ap-south-1.amazonaws.com/in-boloindya", with: "in-boloindya.s3.ap-south-1.amazonaws.com", options: .regularExpression, range: nil)
        
        var ids = ""
        for each in selected_categories {
            if each == selected_categories[selected_categories.count-1] {
                ids += "\(each)"
            } else {
                ids += "\(each),"
            }
        }
        
        let paramters: [String: Any] = [
            "question_video": "\(video_url_upload)",
            "language_id": "\(UserDefaults.standard.getValueForLanguageId().unsafelyUnwrapped)",
            "question_image": "\(thumnail_url_upload)",
            "title": "\(topic_title.text.unsafelyUnwrapped)" + add_hashtag_text,
            "category_id": "58",
            "media_duration": time,
            "is_vb": "1",
            "location_array": "[]",
            "categ_list": ids,
            "vb_width": "1280",
            "vb_height": "720",
            "selected_language": "\(self.selected_language.id)",
            "token": "\( UserDefaults.standard.getAuthToken().unsafelyUnwrapped)"
        ]
        
        var headers: [String: Any]? = nil
        
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
            headers = ["Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        
        let url = "https://www.boloindya.com/api/v1/create_topic"
        
        Alamofire.request(url, method: .post, parameters: paramters, encoding: URLEncoding.default, headers: headers as? HTTPHeaders)
            .responseString  { (responseData) in
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false)
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func hideUnhideLanguage(_ sender: Any) {
        if languageView.isHidden {
            languageView.isHidden = false
            transparentView.isHidden = false
        } else {
            languageView.isHidden = true
        }
    }
    
    @IBAction func onClickTransparentView(_ sender: Any) {
        languageView.isHidden = true
        categoryView.isHidden = true
        transparentView.isHidden = true
        hash_tag.isHidden = true
        self.enter_hash.resignFirstResponder()
        self.topic_title.resignFirstResponder()
    }
    
    @IBAction func hideUnhideCategory(_ sender: Any) {
        if categories.count == 0 {
            fetchCategories()
        }
        if categoryView.isHidden {
            categoryView.isHidden = false
            transparentView.isHidden = false
        } else {
            categoryView.isHidden = true
        }
    }
    
    @IBAction func hideUnhideHashTag(_ sender: Any) {
        if hash_tag.isHidden {
            hash_tag.isHidden = false
            transparentView.isHidden = false
            self.hash_tags.removeAll()
            self.hashView.reloadData()
        } else {
            hash_tag.isHidden = true
        }
    }
    
    @objc func didChange(_ sender: Any) {
        fetchHashTag()
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
                                    category.image = each["category_image"] as! String
                                    self.categories.append(category)
                                }
                            }
                            
                            self.categoryView.reloadData()
                        }
                        catch {
                            print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    print(error)
                }
        }
    }
    
    func fetchHashTag() {
        
        if isLoading {
            return
        }
        
        isLoading = true
        
        let parameters: [String: Any] = [ "term": "\(enter_hash.text.unsafelyUnwrapped)"]
        
        Alamofire.request("https://www.boloindya.com/api/v1/hashtag_suggestion/", method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseString  { (responseData) in
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                        do {
                            let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                            if let content = json_object?["hash_data"] as? [[String:Any]] {
                                self.hash_tags.removeAll()
                                for each in content {
                                    self.hash_tags.append(each["hash_tag"] as! String)
                                }
                                self.hashView.reloadData()
                            }
                            self.isLoading = false
                        } catch {
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


extension UploadVideoDetailsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == languageView {
            self.selected_language = languages[indexPath.row]
            choose_language.text = selected_language.title
        } else if collectionView == categoryView {
            choose_category_label.isHidden = false
            if !selected_categories.contains(categories[indexPath.row].id) {
                if (selected_categories.count < 2) {
                    selected_categories.append(categories[indexPath.row].id)
                    selected_categories_title.append((categories[indexPath.row].title))
                    category_name = ""
                    for each in selected_categories_title {
                        category_name +=  each + " "
                    }
                    choose_category_label.text = category_name
                } else {
                    let alert = UIAlertController(title: "You Can Select Upto 2 Categories Only.", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
            } else {
                selected_categories_title.remove(at: selected_categories.firstIndex(of:categories[indexPath.row].id)!)
                selected_categories.remove(at: selected_categories.firstIndex(of:categories[indexPath.row].id)!)
                category_name = ""
                for each in selected_categories_title {
                    category_name +=  each + " "
                }
                if selected_categories_title.isEmpty {
                    choose_category_label.isHidden = true
                }
                choose_category_label.text = category_name
            }
        } else {
            enter_hash.resignFirstResponder()
            contrain.constant = 10
            topic_title.resignFirstResponder()
            if !selected_hash.contains(hash_tags[indexPath.row]) {
                add_hashtag_label.isHidden = false
                if  (selected_hash.count < 4) {
                    selected_hash.append(hash_tags[indexPath.row])
                    add_hashtag_text +=  "#" + hash_tags[indexPath.row] + " "
                    add_hashtag_label.text = add_hashtag_text
                } else {
                    let alert = UIAlertController(title: "You Can Select Upto 4 Hashtags, make sure they are relevant.", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
            }
            enter_hash.text = ""
        }
        hash_tag.isHidden = true
        languageView.isHidden = true
        categoryView.isHidden = true
        transparentView.isHidden = true
    }
    
    private func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == languageView {
            return languages.count
        } else if collectionView == hashView {
            return hash_tags.count
        }
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == languageView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! UploadLanguageCollectionViewCell
            cell.configure(with: languages[indexPath.row])
            return cell
        } else if collectionView == hashView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HashUploadCollectionViewCell
            cell.configure(with: hash_tags[indexPath.row])
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryUploadCollectionViewCell
        cell.configure(with: categories[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryView {
            return CGSize(width: (collectionView.frame.width/2.4), height: 50)
        }
        return CGSize(width: (collectionView.frame.width/2.4), height: 30)
    }
}

extension UploadVideoDetailsViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.enter_hash.resignFirstResponder()
        contrain.constant = 10
        self.topic_title.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
}
