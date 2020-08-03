//
//  ViewController.swift
//  BoloIndya
//
//  Created by apple on 7/9/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Main")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (UserDefaults.standard.isLanguageSet() ?? false) {
            chooseLanguage()
        } else {
            chooseLanguage()
        }
    }
    
    func chooseLanguage() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChooseLanguageFirstViewController") as! ChooseLanguageFirstViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
    
    func sentToTrending() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
}

