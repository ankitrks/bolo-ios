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
    
    var categoryView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        categoryView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        categoryView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        fetchNotifications()
    }

    func fetchNotifications() {
        
        Alamofire.request("https://www.boloindya.com/api/v1/get_sub_category", method: .get, parameters: nil, encoding: URLEncoding.default)
            .responseString  { (responseData) in
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                    
                    do {
                        
                        if let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [[String: Any]] {
                        for each in json_object {
                            let each_categroy = Category()
                            each_categroy.title = each["title"] as! String
                            each_categroy.image = each["dark_category_image"] as! String
                            self.category.append(each_categroy)
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

extension UpdateIntersetViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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

