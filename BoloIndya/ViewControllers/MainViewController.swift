//
//  MainViewController.swift
//  BoloIndya
//
//  Created by apple on 7/11/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Kingfisher

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
}

extension MainViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if tabBarController.selectedIndex == 2 {
//            let vc = BIVideoEditorViewController.loadFromNib()
//            vc.modalPresentationStyle = .fullScreen
//            (viewControllers?.first as? UINavigationController)?.viewControllers.first?.present(vc, animated: true, completion: nil)
//
//            return false
//        }
        
        return true
    }
}
