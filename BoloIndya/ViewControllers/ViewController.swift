//
//  ViewController.swift
//  BoloIndya
//
//  Created by apple on 7/9/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Main")
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if let languageId = UserDefaults.standard.getValueForLanguageId(), languageId == 0 {
            chooseLanguage()
        } else {
            sentToTrending()
        }
    }
    
    func chooseLanguage() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChooseLanguageController") as! ChooseLanguageController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
    
    func sentToTrending() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
}

