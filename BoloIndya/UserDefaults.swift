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
    
    func getValueForLanguageId() -> Int? {
       return value(forKey: "language_id") as? Int
   }
    
    func setLoggedIn(value: Bool?) {
        if value != nil {
            set(value, forKey: "is_logged_in")
        } else {
            removeObject(forKey: "is_logged_in")
        }
    }

    func isLoggedIn() -> Bool? {
       return value(forKey: "is_logged_in") as? Bool ?? false
    }
    
    func setAuthToken(value: String?) {
        if value != nil {
            set(value, forKey: "auth_key")
        } else {
            removeObject(forKey: "auth_key")
        }
    }
    
    func getAuthToken() -> String? {
        return value(forKey: "auth_key") as? String
    }
    
    func setUsername(value: String?) {
        if value != nil {
            set(value, forKey: "username")
        } else {
            removeObject(forKey: "username")
        }
        synchronize()
    }
    
    func getUsername() -> String? {
        return value(forKey: "username") as? String
    }
    
    func setName(value: String?) {
        if value != nil {
            set(value, forKey: "name")
        } else {
            removeObject(forKey: "name")
        }
        synchronize()
    }
    
    func getName() -> String? {
        return value(forKey: "name") as? String
    }
    
    func setUserId(value: Int?) {
        if value != nil {
            set(value, forKey: "user_id")
        } else {
            removeObject(forKey: "user_id")
        }
        synchronize()
    }
    
    func getUserId() -> Int? {
        return value(forKey: "user_id") as? Int
    }
    
    func setCoverPic(value: String?) {
        if value != nil {
            set(value, forKey: "cover_pic")
        } else {
            removeObject(forKey: "cover_pic")
        }
        synchronize()
    }
    
    func getCoverPic() -> String? {
        return value(forKey: "cover_pic") as? String
    }
    
    func setProfilePic(value: String?) {
        if value != nil {
            set(value, forKey: "profile_pic")
        } else {
            removeObject(forKey: "profile_pic")
        }
        synchronize()
    }
    
    func getProfilePic() -> String? {
        return value(forKey: "profile_pic") as? String
    }
    
    func setIsPopular(value: Bool?) {
       if value != nil {
           set(value, forKey: "is_popular")
       } else {
           removeObject(forKey: "is_popular")
       }
   }
    
    func isPopular() -> Bool? {
        return value(forKey: "is_popular") as? Bool
    }
    
    func setIsSuperStar(value: Bool?) {
        if value != nil {
            set(value, forKey: "is_superstar")
        } else {
            removeObject(forKey: "is_superstar")
        }
    }
    
    func isSuperStar() -> Bool? {
        return value(forKey: "is_superstar") as? Bool
    }
    
    func setIsBusiness(value: Bool?) {
        if value != nil {
            set(value, forKey: "is_business")
        } else {
            removeObject(forKey: "is_business")
        }
    }
    
    func isBusiness() -> Bool? {
        return value(forKey: "is_business") as? Bool
    }
    
    func setBio(value: String?) {
        if value != nil {
            set(value, forKey: "bio")
        } else {
            removeObject(forKey: "bio")
        }
        synchronize()
    }
    
    func getBio() -> String? {
        return value(forKey: "bio") as? String
    }
}
