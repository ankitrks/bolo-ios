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

    @IBOutlet weak var termView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request("https://www.boloindya.com/get-html-content-app/?name=terms_and_condition", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
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
}
