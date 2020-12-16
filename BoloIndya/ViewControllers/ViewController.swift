//
//  ViewController.swift
//  BoloIndya
//
//  Created by apple on 7/9/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: BaseVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Main")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.isLoggedIn() == true && (UserDefaults.standard.getAuthToken() == nil || (UserDefaults.standard.getAuthToken() ?? "").isEmpty) {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginAndSignUpViewController") as! LoginAndSignUpViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        } else if UserDefaults.standard.isLanguageSet() ?? false {
            sentToTrending()
            self.navigationController?.isNavigationBarHidden = true
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

