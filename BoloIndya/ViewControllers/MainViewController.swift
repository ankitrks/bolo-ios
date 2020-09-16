//
//  MainViewController.swift
//  BoloIndya
//
//  Created by apple on 7/11/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Kingfisher



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




class MainViewController: UITabBarController,UITabBarControllerDelegate {
    
    var button = UIButton(type: .custom)
    
    var bgView:UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
       // tabBar.barTintColor = UIColor.white
        self.tabBar.isTranslucent = true
        
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
         //UITabBar.appearance().tintColor = UIColor.red
        UITabBar.appearance().backgroundColor = UIColor.init(displayP3Red:  0.71, green: 0.16, blue: 0.15, alpha: 1.0)
        UITabBar.appearance()
        
        
        //self.tabBar.alpha = 0.3
//        self.tabBar.backgroundColor = UIColor.clear.withAlphaComponent(0.0)
//        self.tabBar.layer.backgroundColor = UIColor.clear.withAlphaComponent(0.0).cgColor
        
//        UITabBar.appearance().shadowImage = UIImage()
//        UITabBar.appearance().backgroundImage = UIImage()
        
        
//        self.tabBar.unselectedItemTintColor = UIColor.white
//        UITabBar.appearance().barTintColor = UIColor.init(red:33/225, green: 25/225, blue: 22/225, alpha: 1.0)
//
        
        
//        self.bgView?.removeFromSuperview()
//        let screenSize = UIScreen.main.bounds
//        let screenWidth = screenSize.width
//        let screenHeight = screenSize.height
//        bgView = UIImageView(image: UIImage(named: "Untitled drawing"))
//        bgView!.frame = CGRect(x: 0, y: screenHeight-60, width:screenWidth, height: 60)//you might need to modify this frame to your tabbar frame
//        self.view.addSubview(bgView!)
        


    }
    
    
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.bringSubviewToFront(self.tabBar)
        self.addCenterButton()
        
      
        
           
        
    }
    
    // Add Custom video making button in tabbar
    private func addCenterButton() {
        
        button.setImage(UIImage(named: "add"), for: .normal)
        let square = self.tabBar.frame.size.height
        button.frame = CGRect(x: 0, y: 0, width: square, height: square)
        button.center = self.tabBar.center
        self.view.addSubview(button)
        self.view.bringSubviewToFront(button)
        tabBar.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        tabBar.topAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        button.addTarget(self, action: #selector(didTouchCenterButton(_:)), for: .touchUpInside)
    }
    @objc
    private func didTouchCenterButton(_ sender: AnyObject) {
            let vc = ActionViewContoller()
           vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
    }
}
