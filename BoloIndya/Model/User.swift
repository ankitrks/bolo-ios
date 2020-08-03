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
    var vb_count: Int
    var view_count: String
    var follow_count: String
    var follower_count: String
    
    init() {
        self.id = 0
        self.username = ""
        self.name = ""
        self.bio = ""
        self.cover_pic = ""
        self.profile_pic = ""
        self.vb_count = 0
        self.view_count = ""
        self.follow_count = ""
        self.follower_count = ""
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
    
    func setProfilePic(profile_pic: String) {
        self.profile_pic = profile_pic
    }
    
}
