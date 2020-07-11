//
//  NotificationViewController.swift
//  BoloIndya
//
//  Created by apple on 7/10/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Notification")
        // Do any additional setup after loading the view.
        let isLoggedIn = UserDefaults.standard.isLoggedIn() ?? false
        if (!isLoggedIn) {
            goToLoginPage()
        }
    }
    
    func goToLoginPage() {
       let vc = storyboard?.instantiateViewController(withIdentifier: "LoginAndSignUpViewController") as! LoginAndSignUpViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }

}
