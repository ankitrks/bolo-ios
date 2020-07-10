//
//  DiscoverViewController.swift
//  BoloIndya
//
//  Created by apple on 7/10/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {

    @IBOutlet weak var home: UIButton!
    
    @IBOutlet weak var profile: UIButton!
    
    @IBOutlet weak var notification: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Discover")
    }
    
    @IBAction func goToNextScreens(_ sender: UIButton) {
        let isLoggedIn = UserDefaults.standard.isLoggedIn() ?? false
        switch(sender) {
        case profile:
            if (isLoggedIn) {
                goToCurrentUSerProfile()
            } else {
                goToLoginPage()
            }
            break
        case notification:
            if (isLoggedIn) {
                goToNotification()
            } else {
                goToLoginPage()
            }
            break
        case home:
            goToHomePage()
            break
        default:
            break
        }
    }
    
    func goToNotification() {
        let vc = storyboard?.instantiateViewController(identifier: "NotificationViewController") as! NotificationViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
    
    func goToCurrentUSerProfile() {
        let vc = storyboard?.instantiateViewController(identifier: "CurrentUserViewController") as! CurrentUserViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
    
    func goToHomePage() {
        let vc = storyboard?.instantiateViewController(identifier: "TrendingAndFollowingViewController") as! TrendingAndFollowingViewController;       vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
    
    func goToLoginPage() {
       let vc = storyboard?.instantiateViewController(identifier: "LoginAndSignUpViewController") as! LoginAndSignUpViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
}
