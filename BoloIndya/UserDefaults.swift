//
//  UserDefaults.Extensions.swift
//  BoloIndya
//
//  Created by apple on 7/10/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func setValueForLanguageId(value: Int?) {
        if value != nil {
            set(value, forKey: "language_id")
        } else {
            removeObject(forKey: "language_id")
        }
        synchronize()
    }
    
    func setLoggedIn(value: Bool?) {
        if value != nil {
            set(value, forKey: "is_logged_in")
        } else {
            removeObject(forKey: "is_logged_in")
        }
    }
    
    func setAuthToken(value: String?) {
        if value != nil {
            set(value, forKey: "auth_key")
        } else {
            removeObject(forKey: "auth_key")
        }
    }
    
    func getValueForLanguageId() -> Int? {
        return value(forKey: "language_id") as? Int
    }
    
    func isLoggedIn() -> Bool? {
        return value(forKey: "is_logged_in") as? Bool
    }
    
    func getAuthToken() -> String? {
        return value(forKey: "auth_key") as? String
    }
}
