//
//  NSObject+Extension.swift
//  BoloIndya
//
//  Created by Rahul Garg on 21/12/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

extension NSObject: ClassNameProtocol { }

extension NSObject {
    var asDictionary: [String:Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
            guard let label = label else { return nil }
            return (label, value)
        }).compactMap { $0 })
        return dict
    }
    
    var safeAreaBottom: CGFloat {
         if #available(iOS 11, *), let window = UIApplication.shared.keyWindowInConnectedScenes {
            return window.safeAreaInsets.bottom
         }
         return 0
    }

    var safeAreaTop: CGFloat {
         if #available(iOS 11, *), let window = UIApplication.shared.keyWindowInConnectedScenes {
            return window.safeAreaInsets.top
         }
         return 0
    }
    
    func getDictionary() -> NSMutableDictionary {
        return NSMutableDictionary(dictionary: asDictionary)
    }
    
    func getStatusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 25
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 20
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    
    func isLoggedIn() -> Bool {
        var isLoggedin: Bool
        if let guest = UserDefaults.standard.getGuestLoggedIn(), !guest {
            isLoggedin = true
        } else if let name = UserDefaults.standard.getName(), !name.isEmpty, let gender = UserDefaults.standard.getGender(), !gender.isEmpty, let dob = UserDefaults.standard.getDOB(), !dob.isEmpty {
            isLoggedin = true
        } else {
            isLoggedin = false
        }
        
        return isLoggedin
    }
}

