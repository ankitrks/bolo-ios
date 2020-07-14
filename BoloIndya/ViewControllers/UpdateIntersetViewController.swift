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

    var names: [String] = []
    
    var categoryView =  UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryView.isScrollEnabled = true
        categoryView.delegate = self
        categoryView.dataSource = self
        categoryView.separatorStyle = UITableViewCell.SeparatorStyle.none
        categoryView.register(CategoryViewCell.self, forCellReuseIdentifier: "Cell")
    
        view.addSubview(categoryView)
        
        let screenSize = UIScreen.main.bounds.size
        self.categoryView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
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
                            self.self.names.append(each["title"] as! String)
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

extension UpdateIntersetViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category_cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CategoryViewCell
        category_cell.name.setTitle(names[indexPath.row], for: .normal)
        return category_cell
    }

}

