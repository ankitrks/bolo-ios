//
//  Comment.swift
//  BoloIndya
//
//  Created by apple on 7/24/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation


class Comment {
    var title: String
    var id: String
    var user: User
    var date: String
    var likes: String
    var isLiked: Bool
    
    init(user: User) {
        self.title = ""
        self.id = ""
        self.user = user
        self.date = ""
        self.likes = ""
        self.isLiked = false
    }
    
    func setTitle(title: String) {
        self.title=title
    }
    
    func setId(id: String) {
        self.id=id
    }

}

func getComment(each: [String:Any]) -> Comment{
    let user = User()
    let user_obj = each["user"] as? [String:Any]
    let user_profile_obj = user_obj?["userprofile"] as? [String:Any]
    user.setId(id: (user_obj?["id"] as? Int ?? 0))
    user.setUserName(username: user_obj?["username"] as? String ?? "")
    
    user.setName(name: user_profile_obj?["name"] as? String ?? "")
    user.setBio(bio: user_profile_obj?["bio"] as? String ?? "")
    user.setCoverPic(cover_pic: user_profile_obj?["cover_pic"] as? String ?? "")
    user.setProfilePic(profile_pic: user_profile_obj?["profile_pic"] as? String ?? "")
    
    let comment = Comment(user: user)
    comment.setTitle(title: each["comment"] as? String ?? "")
    comment.id = "\(each["id"] as! Int)"
    comment.likes = "\(each["likes_count"] as! Int)"
    comment.date = each["date"] as? String ?? ""
    return comment
}
