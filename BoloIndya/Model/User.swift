//
//  User.swift
//  BoloIndya
//
//  Created by apple on 7/10/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation

class User {
    
    var id: Int
    var username: String
    var name: String
    var bio: String
    var cover_pic: String
    var profile_pic: String
    var user_profile_pic: String
    var vb_count: Int
    var view_count: String
    var follow_count: String
    var follower_count: String
    var isFollowing: Bool
    
    var isSuperstar: Bool
    var isPopular: Bool
    var isBusiness: Bool
    var isExpert: Bool
    
    init() {
        self.id = 0
        self.username = ""
        self.name = ""
        self.bio = ""
        self.cover_pic = ""
        self.profile_pic = ""
        self.user_profile_pic = ""
        self.vb_count = 0
        self.view_count = ""
        self.follow_count = ""
        self.follower_count = ""
        self.isFollowing = false
        
        isSuperstar = false
        isPopular = false
        isBusiness = false
        isExpert = false
    }
    
    func setId(id: Int) {
        self.id = id
    }
    
    func setUserName(username: String) {
        self.username = username
    }
    
    func setName(name: String) {
        self.name = name
    }
    
    func setBio(bio: String) {
        self.bio = bio
    }
    
    func setCoverPic(cover_pic: String) {
        self.cover_pic = cover_pic
    }
    
    func setUserProfilePic(profile_pic: String) {
        var tempUrl = profile_pic;
        if(profile_pic.contains("s3.amazonaws.com/boloindyapp-prod")) {
            tempUrl = profile_pic.replacingOccurrences(of: "https://s3.amazonaws.com/boloindyapp-prod", with: "http://boloindyapp-prod.s3-website-us-east-1.amazonaws.com/2000x200")
        } else {
            tempUrl = profile_pic.replacingOccurrences(of:"https://in-boloindya.s3.amazonaws.com", with: "http://in-boloindya.s3-website.ap-south-1.amazonaws.com/200x200")
        }
        self.user_profile_pic = tempUrl
    }
    
    func setProfilePic(profile_pic: String) {
        var tempUrl = profile_pic;
        if(profile_pic.contains("s3.amazonaws.com/boloindyapp-prod")) {
            tempUrl = profile_pic.replacingOccurrences(of: "https://s3.amazonaws.com/boloindyapp-prod", with: "http://boloindyapp-prod.s3-website-us-east-1.amazonaws.com/80x80")
        } else {
            tempUrl = profile_pic.replacingOccurrences(of:"https://in-boloindya.s3.amazonaws.com", with: "http://in-boloindya.s3-website.ap-south-1.amazonaws.com/80x80")
        }
        
        self.profile_pic = tempUrl
    }
    
    func getUserType() -> String {
        var type: String
        
        if isSuperstar {
            type = "Superstar"
        } else if isBusiness {
            type = "Business"
        } else if isPopular {
            type = "Popular"
        } else if isExpert {
            type = "Expert"
        } else {
            type = "General"
        }
        
        return type
    }
}

func getUserDataFromJson(result: [String:Any]) -> User{
    let user = User()
    let user_profile_obj = result["userprofile"] as? [String:Any]
    
    user.id = user_profile_obj?["user"] as! Int
    user.setUserName(username: user_profile_obj?["slug"] as? String ?? "")
    
    user.setName(name: user_profile_obj?["name"] as? String ?? "")
    user.setBio(bio: user_profile_obj?["bio"] as? String ?? "")
    user.setCoverPic(cover_pic: user_profile_obj?["cover_pic"] as? String ?? "")
    user.setProfilePic(profile_pic: user_profile_obj?["profile_pic"] as? String ?? "")
     user.setUserProfilePic(profile_pic: user_profile_obj?["profile_pic"] as? String ?? "")
    user.vb_count = user_profile_obj?["vb_count"] as! Int
    if let view_count = user_profile_obj?["view_count"] as? Int {
        user.view_count = "\(view_count)"
    } else {
        user.view_count = user_profile_obj?["view_count"] as! String
    }
    if let follow_count = user_profile_obj?["follow_count"] as? Int {
        user.follow_count = "\(follow_count)"
    } else {
        user.follow_count = user_profile_obj?["follow_count"] as! String
    }
    if let following_count = user_profile_obj?["follower_count"] as? Int {
        user.follower_count = "\(following_count)"
    } else {
        user.follower_count = user_profile_obj?["follower_count"] as! String
    }
    return user
}
