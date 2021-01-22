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
    
    func getDictionary() -> NSMutableDictionary {
        return NSMutableDictionary(dictionary: asDictionary)
    }
    
    func getStatusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 25
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 25
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
}

