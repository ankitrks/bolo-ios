//
//  UpdateIntersetViewController.swift
//  BoloIndya
//
//  Created by apple on 7/13/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Alamofire

class UpdateIntersetViewController: UIViewController {
    
    var category: [Category] = []
    var selected_ids: [Int] = []
    
    var categoryView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    var upper_tab = UIView()
    var back_image = UIImageView()
    var label = UILabel()
    var tick_image = UIImageView()
    
    var loader = UIActivityIndicatorView()
    
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selected_ids = UserDefaults.standard.getCategories()
        
        upper_tab.addSubview(back_image)
        upper_tab.addSubview(label)
        upper_tab.addSubview(tick_image)
        
        view.addSubview(upper_tab)
        
        upper_tab.translatesAutoresizingMaskIntoConstraints = false
        upper_tab.heightAnchor.constraint(equalToConstant: 40).isActive = true
        upper_tab.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 0).isActive = true
        upper_tab.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: 0).isActive = true
        upper_tab.topAnchor.constraint(equalTo: self.view.topAnchor, constant: getStatusBarHeight()).isActive = true
        
        upper_tab.layer.backgroundColor = UIColor(hex: "10A5F9")?.cgColor
        
        back_image.translatesAutoresizingMaskIntoConstraints = false
        back_image.heightAnchor.constraint(equalToConstant: 25).isActive = true
        back_image.widthAnchor.constraint(equalToConstant: 40).isActive = true
        back_image.centerYAnchor.constraint(equalTo: upper_tab.centerYAnchor,constant: 0).isActive = true
        back_image.leftAnchor.constraint(equalTo: upper_tab.leftAnchor,constant: 10).isActive = true
        
        back_image.image = UIImage(named: "back")
        back_image.contentMode = .scaleAspectFit
        
        back_image.isUserInteractionEnabled = true
        let tapGestureBack = UITapGestureRecognizer(target: self, action: #selector(goBack(_:)))
        back_image.addGestureRecognizer(tapGestureBack)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.centerYAnchor.constraint(equalTo: upper_tab.centerYAnchor,constant: 0).isActive = true
        label.leftAnchor.constraint(equalTo: back_image.rightAnchor,constant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: tick_image.leftAnchor,constant: -10).isActive = true
        
        label.text = ""
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        tick_image.translatesAutoresizingMaskIntoConstraints = false
        tick_image.heightAnchor.constraint(equalToConstant: 30).isActive = true
        tick_image.widthAnchor.constraint(equalToConstant: 40).isActive = true
        tick_image.centerYAnchor.constraint(equalTo: upper_tab.centerYAnchor,constant: 0).isActive = true
        tick_image.rightAnchor.constraint(equalTo: upper_tab.rightAnchor,constant: -10).isActive = true
        
        tick_image.image = UIImage(named: "tick")
        tick_image.contentMode = .scaleAspectFit
        
        tick_image.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(setLanguage(_:)))
        tick_image.addGestureRecognizer(tapGesture)
        
        categoryView.isScrollEnabled = true
        categoryView.delegate = self
        categoryView.dataSource = self
        categoryView.backgroundColor = UIColor.clear
        
        let screenSize = UIScreen.main.bounds.size
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: (screenSize.width/3.4), height: (screenSize.width/3.4) * 1.2)
        categoryView.collectionViewLayout = layout
        
        categoryView.register(CategoryViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        view.addSubview(categoryView)
        
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        categoryView.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        categoryView.topAnchor.constraint(equalTo: upper_tab.bottomAnchor, constant: 10).isActive = true
        categoryView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        view.addSubview(loader)
        
        loader.center = self.view.center
        
        loader.color = UIColor.white
        
        fetchCategories()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func fetchCategories() {
        
        loader.isHidden = false
        loader.startAnimating()
        
        Alamofire.request("https://www.boloindya.com/api/v1/get_sub_category", method: .get, parameters: nil, encoding: URLEncoding.default)
            .responseString  { (responseData) in
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                        
                        do {
                            
                            if let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [[String: Any]] {
                                for each in json_object {
                                    let each_categroy = Category()
                                    each_categroy.id = each["id"] as! Int
                                    each_categroy.title = each["title"] as! String
                                    each_categroy.image = each["dark_category_image"] as! String
                                    if let id = each["id"] as? Int {
                                        if self.selected_ids.contains(id) {
                                            each_categroy.isSelected = true
                                        }
                                    }
                                    self.category.append(each_categroy)
                                }
                            }
                            self.loader.isHidden = true
                            self.loader.stopAnimating()
                            self.categoryView.reloadData()
                        }
                        catch {
                            self.loader.isHidden = true
                            self.loader.stopAnimating()
                            print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    self.loader.isHidden = true
                    self.loader.stopAnimating()
                    print(error)
                }
        }
    }
    
    @IBAction func setLanguage(_ sender: Any) {
        
        if isLoading {
            return
        }
        
        if selected_ids.count < 3 {
            let alert = UIAlertController(title: "Please Select Atleast 3 Interests To Start", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        var ids = ""
        for each in selected_ids {
            if each == selected_ids[selected_ids.count-1] {
                ids += "\(each)"
            } else {
                ids += "\(each),"
            }
        }
        
        let paramters: [String: Any] = [
            "activity": "settings_changed",
            "language": "\(UserDefaults.standard.getValueForLanguageId() ?? 2)",
            "categories": ids
        ]
        
        
        
        var headers: [String: Any]? = nil
        
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
            headers = ["Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        
        loader.isHidden = false
        loader.startAnimating()
        isLoading = true
        
        let url = "https://www.boloindya.com/api/v1/fb_profile_settings/"
        
        Alamofire.request(url, method: .post, parameters: paramters, encoding: URLEncoding.default, headers: headers as? HTTPHeaders)
            .responseString  { (responseData) in
                
                self.loader.isHidden = true
                self.loader.stopAnimating()
                self.navigationController?.popViewController(animated: true)
        }
        
    }
}

extension UpdateIntersetViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !self.isLoading {
            if category[indexPath.row].isSelected {
                selected_ids.remove(at: selected_ids.firstIndex(of:category[indexPath.row].id)!)
            } else {
                selected_ids.append(category[indexPath.row].id)
            }
            category[indexPath.row].isSelected = !category[indexPath.row].isSelected
            UserDefaults.standard.setCategories(value: selected_ids)
            self.categoryView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryViewCell
        cell.configure(with: category[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/3.4), height: (collectionView.frame.width/3.4) * 1.2)
    }
}

