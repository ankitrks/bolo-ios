//
//  UIApplication+Extension.swift
//  BoloIndya
//
//  Created by Rahul Garg on 28/12/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

extension UIApplication {
    var keyWindowInConnectedScenes: UIWindow? {
        return windows.first(where: { $0.isKeyWindow })
    }
    
    var currentWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return connectedScenes
//                .filter({ $0.activationState == .foregroundActive })
                .map({ $0 as? UIWindowScene })
                .compactMap({ $0 })
                .first?.windows.first
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    // MARK: Choose keyWindow as per your choice
    var keyWindow: UIWindow? {
        UIApplication.shared.windows.first { $0.isKeyWindow }
    }
    
    static func topMostViewController(base: UIViewController? = UIApplication.shared.currentWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topMostViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            
            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topMostViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return topMostViewController(base: selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return topMostViewController(base: presented)
        }
        
        return base
    }
}
