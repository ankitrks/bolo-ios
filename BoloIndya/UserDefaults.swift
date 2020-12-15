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
        guard let id = value(forKey: "language_id") as? Int else {
            return 2
        }
        return id
    }
    
    func getlastUpdateTime() -> String? {
        value(forKey: "last_update_time") as? String ?? ""
    }
    
    func setLastUpdateTime(value: String?) {
        if value != nil {
            set(value, forKey: "last_update_time")
        } else {
            removeObject(forKey: "last_update_time")
        }
        synchronize()
    }
    
    func setLoggedIn(value: Bool?) {
        if value != nil {
            set(value, forKey: "is_logged_in")
        } else {
            removeObject(forKey: "is_logged_in")
        }
        synchronize()
    }
    
    func setLanguageSet(value: Bool?) {
        if value != nil {
            set(value, forKey: "is_language_set")
        } else {
            removeObject(forKey: "is_language_set")
        }
        synchronize()
    }
    
    func isLanguageSet() -> Bool? {
        return value(forKey: "is_language_set") as? Bool ?? false
    }
    
    func isLoggedIn() -> Bool? {
        return value(forKey: "is_logged_in") as? Bool ?? false
    }
    
    func getGuestLoggedIn() -> Bool? {
        return value(forKey: "is_guest_logged_in") as? Bool ?? false
    }
    
    func setGuestLoggedIn(value: Bool?) {
        if value != nil {
            set(value, forKey: "is_guest_logged_in")
        } else {
            removeObject(forKey: "auth_key")
        }
        synchronize()
    }
    
    func setAuthToken(value: String?) {
        if value != nil {
            set(value, forKey: "auth_key")
        } else {
            removeObject(forKey: "auth_key")
        }
        synchronize()
    }
    
    func getAuthToken() -> String? {
        return value(forKey: "auth_key") as? String ?? ""
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
        guard let id = value(forKey: "user_id") as? Int else {
            return 41
        }
        return id
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
        return value(forKey: "profile_pic") as? String ?? ""
    }
    
    func setIsPopular(value: Bool?) {
        if value != nil {
            set(value, forKey: "is_popular")
        } else {
            removeObject(forKey: "is_popular")
        }
        synchronize()
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
        synchronize()
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
        synchronize()
    }
    
    func isBusiness() -> Bool? {
        return value(forKey: "is_business") as? Bool
    }
    
    func setIsExpert(value: Bool?) {
        if value != nil {
            set(value, forKey: "is_expert")
        } else {
            removeObject(forKey: "is_expert")
        }
        synchronize()
    }
    
    func isExpert() -> Bool? {
        return value(forKey: "is_expert") as? Bool
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
    
    func setCategories(value: [Int]) {
        set(value, forKey: "sub_category")
        synchronize()
    }
    
    func getCategories() -> [Int] {
        return value(forKey: "sub_category") as? [Int] ?? [Int]()
    }
    
    func setFollowingUsers(value: [Int]) {
        set(value, forKey: "all_follow")
        synchronize()
    }
    
    func getFollowingUsers() -> [Int] {
        return value(forKey: "all_follow") as? [Int] ?? [Int]()
    }
    
    func setLikeTopic(value: [Int]) {
        set(value, forKey: "topic_like")
        synchronize()
    }
    
    func getLikeTopic() -> [Int] {
        return value(forKey: "topic_like") as? [Int] ?? [Int]()
    }
    
    func setLikeComment(value: [Int]) {
        set(value, forKey: "comment_like")
        synchronize()
    }
    
    func getLikeComment() -> [Int] {
        return value(forKey: "comment_like") as? [Int] ?? [Int]()
    }
}
