//
//  UploadVideoDetailsViewController.swift
//  BoloIndya
//
//  Created by apple on 8/5/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Alamofire

class UploadVideoDetailsViewController: UIViewController {
    
    var image: UIImage!
    var video_url: URL!
    
    var upper_tab = UIView()
    var back_image = UIImageView()
    var label = UILabel()
    var tick_image = UIImageView()
    
    var thumb = UIImageView()
    var topic_title = UITextView()
    
    var choose_category = UILabel()
    var add_hashtag = UILabel()
    var choose_language = UILabel()
    
    var languages: [Languages]!
    var categories: [Category] = []
    
    var transparentView = UIView()
    var selected_language: Languages!
    var selected_categories: [Int] = []
    var category_name = ""
    
    var languageView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    var categoryView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        let screenSize = UIScreen.main.bounds.size
        
        upper_tab.addSubview(back_image)
        upper_tab.addSubview(label)
        upper_tab.addSubview(tick_image)
        
        view.addSubview(upper_tab)
        view.addSubview(thumb)
        view.addSubview(topic_title)
        view.addSubview(choose_category)
        view.addSubview(add_hashtag)
        view.addSubview(choose_language)
        
        upper_tab.translatesAutoresizingMaskIntoConstraints = false
        upper_tab.heightAnchor.constraint(equalToConstant: 40).isActive = true
        upper_tab.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 0).isActive = true
        upper_tab.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: 0).isActive = true
        upper_tab.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        
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
        
        topic_title.isEditable = true
        topic_title.text = "What is this video about?"
        topic_title.textColor = UIColor.white
        topic_title.backgroundColor =  #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.8470588235)
        topic_title.font = UIFont.boldSystemFont(ofSize: 12.0)
        
        choose_category.translatesAutoresizingMaskIntoConstraints = false
        choose_category.widthAnchor.constraint(equalToConstant: (screenSize.width)-20).isActive = true
        choose_category.heightAnchor.constraint(equalToConstant: 30).isActive = true
        choose_category.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        choose_category.topAnchor.constraint(equalTo: thumb.bottomAnchor, constant: 10).isActive = true
        choose_category.textColor = UIColor.white
        choose_category.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.8470588235)
        choose_category.text = "Choose Category"
        choose_category.font = UIFont.boldSystemFont(ofSize: 12.0)
        
        choose_category.isUserInteractionEnabled = true
        let hideGestureCategory = UITapGestureRecognizer(target: self, action: #selector(hideUnhideCategory))
        choose_category.addGestureRecognizer(hideGestureCategory)
        
        add_hashtag.translatesAutoresizingMaskIntoConstraints = false
        add_hashtag.widthAnchor.constraint(equalToConstant: (screenSize.width)-20).isActive = true
        add_hashtag.heightAnchor.constraint(equalToConstant: 30).isActive = true
        add_hashtag.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        add_hashtag.topAnchor.constraint(equalTo: choose_category.bottomAnchor, constant: 10).isActive = true
        add_hashtag.textColor = UIColor.white
        add_hashtag.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.8470588235)
        add_hashtag.font = UIFont.boldSystemFont(ofSize: 12.0)
        
        add_hashtag.text = "Add HashTags"
        
        choose_language.translatesAutoresizingMaskIntoConstraints = false
        choose_language.widthAnchor.constraint(equalToConstant: (screenSize.width)-20).isActive = true
        choose_language.heightAnchor.constraint(equalToConstant: 30).isActive = true
        choose_language.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        choose_language.topAnchor.constraint(equalTo: add_hashtag.bottomAnchor, constant: 10).isActive = true
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
        layout.itemSize = CGSize(width: (languageView.frame.width/2.4), height: 20)
        languageView.collectionViewLayout = layout

        languageView.register(UploadLanguageCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        languageView.translatesAutoresizingMaskIntoConstraints = false
        languageView.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 0).isActive = true
        languageView.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: 0).isActive = true
        languageView.heightAnchor.constraint(equalToConstant: 210).isActive = true
        languageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
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
    }

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func uploadVideo(_ sender: Any) {
    
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
    
}


extension UploadVideoDetailsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == languageView {
            self.selected_language = languages[indexPath.row]
            choose_language.text = selected_language.title
        } else {
            if !selected_categories.contains(categories[indexPath.row].id) && selected_categories.count < 2 {
                selected_categories.append(categories[indexPath.row].id)
                category_name +=  categories[indexPath.row].title + " "
                choose_category.text = category_name
            }
        }
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
        }
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == languageView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! UploadLanguageCollectionViewCell
            cell.configure(with: languages[indexPath.row])
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryUploadCollectionViewCell
        cell.configure(with: categories[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == languageView {
            return CGSize(width: (collectionView.frame.width/2.4), height: 20)
        }
        return CGSize(width: (collectionView.frame.width/2.4), height: 50)
    }
}
