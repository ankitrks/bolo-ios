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
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
         //UITabBar.appearance().tintColor = UIColor.red
        UITabBar.appearance().backgroundColor = UIColor.init(displayP3Red:  0.71, green: 0.16, blue: 0.15, alpha: 1.0)
        UITabBar.appearance()



//        var uu = UserDefaults.standard.getProfilePic()
//        let pic_url:URL? = URL(string: UserDefaults.standard.getProfilePic() ?? "")
//        if pic_url != nil  {
//            ImageDownloader.default.downloadImage(with: pic_url!, options: [], progressBlock: nil) {
//                    (image, error, url, data) in
//              //  self.tabBarController?.tabBar.items?[3].image = image
//                self.tabBar.items?[3].image = UIImage(na)
//                }
//            //var image = UIImageView().kf.setImage(with: pic_url, placeholder: UIImage(named: "user"))
//
//
//
//        }


    }
}
