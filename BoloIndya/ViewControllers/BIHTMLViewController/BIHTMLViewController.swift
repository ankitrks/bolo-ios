//
//  BIHTMLViewController.swift
//  BoloIndya
//
//  Created by Rahul Garg on 05/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import WebKit

final class BIHTMLViewController: UIViewController {
    @IBOutlet private weak var webView: WKWebView! {
        didSet {
            webView.isOpaque = false
            webView.backgroundColor = UIColor.clear
            webView.scrollView.backgroundColor = UIColor.clear
        }
    }
    
    var url: URL?
    var dataString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = url {
            webView.load(URLRequest(url: url))
        } else if let string = dataString {
            let fontVariable = "<font color= 'white'>"
            let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
            webView.loadHTMLString(fontVariable + headerString + string, baseURL: nil)
        }
        webView.allowsBackForwardNavigationGestures = false
    }
}

extension BIHTMLViewController: WKNavigationDelegate {
}
