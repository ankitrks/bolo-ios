//
//  TermsPagesViewController.swift
//  BoloIndya
//
//  Created by apple on 7/13/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Alamofire
import WebKit

class TermsPagesViewController: UIViewController {

    var termView = WKWebView()
    
    var current_page = "terms_and_condition"
    
    var upper_tab = UIView()
    var back_image = UIImageView()
    var label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        upper_tab.addSubview(back_image)
        upper_tab.addSubview(label)
        
        view.addSubview(upper_tab)
        view.addSubview(termView)
        
        upper_tab.translatesAutoresizingMaskIntoConstraints = false
        upper_tab.heightAnchor.constraint(equalToConstant: 40).isActive = true
        upper_tab.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 0).isActive = true
        upper_tab.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: 0).isActive = true
        upper_tab.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        
        upper_tab.layer.backgroundColor = #colorLiteral(red: 0.7098039216, green: 0.1568627451, blue: 0.1568627451, alpha: 0.8470588235)
        
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
        
        if current_page == "terms_and_condition" {
            label.text = "Terms and Conditions"
        } else if current_page == "privacy_poilcy" {
            label.text = "Privacy Policy"
        } else if current_page == "bolo_action" {
            label.text = "Earn money with Video bytes"
        }
        label.textColor = UIColor.white
        
        back_image.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goBack(_:)))
        back_image.addGestureRecognizer(tapGesture)
        
        termView.translatesAutoresizingMaskIntoConstraints = false
        termView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        termView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        termView.topAnchor.constraint(equalTo: upper_tab.bottomAnchor, constant: 0).isActive = true
        termView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        Alamofire.request("https://www.boloindya.com/get-html-content-app/?name=\(current_page)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
                   .responseString  { (responseData) in
                       switch responseData.result {
                       case.success(let data):
                           if let json_data = data.data(using: .utf8) {
                           
                           do {
                               let json_object = try
                                JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                            
                            self.termView.loadHTMLString((json_object?["description"] as? String ?? ""), baseURL: nil)
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
    
    @objc func goBack(_ sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
}
