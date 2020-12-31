//
//  NSObject+Extension.swift
//  BoloIndya
//
//  Created by Rahul Garg on 21/12/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation

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
}

