//
//  Topic.swift
//  BoloIndya
//
//  Created by apple on 7/10/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation

class Topic {
    var title: String
    var thumbnail: String
    var duration: String
    var video_url: String
    var id: String
    var view_count: String
    var comment_count: String
    var user: User
    var isLiked: Bool
    var like_count: String
    var share_count: String
    var whatsapp_share_count: String
    
    init(user: User) {
        self.title = ""
        self.thumbnail = ""
        self.duration = ""
        self.id = ""
        self.view_count = ""
        self.comment_count = ""
        self.video_url = ""
        self.user = user
        self.isLiked = false
        self.like_count = ""
        self.comment_count = ""
        self.share_count = ""
        self.whatsapp_share_count = ""
    }
    
    func setTitle(title: String) {
        self.title=title
    }
    
    func setThumbnail(thumbail: String) {
        self.thumbnail=thumbail
    }
    
    func setDuration(duration: String) {
        self.duration=duration
    }
    
    func setId(id: String) {
        self.id=id
    }
    
    func setViewCount(view_count: String) {
        self.view_count=view_count
    }
    
    func setCommentCount(comment_count: String) {
        self.comment_count=comment_count
    }
}

func getTopicFromJson(each: [String:Any]) -> Topic{
    let user = User()
    let user_obj = each["user"] as? [String:Any]
    let user_profile_obj = user_obj?["userprofile"] as? [String:Any]
    user.setId(id: (user_obj?["id"] as? Int ?? 0))
    user.setUserName(username: user_obj?["username"] as? String ?? "")
    
    user.setName(name: user_profile_obj?["name"] as? String ?? "")
    user.setBio(bio: user_profile_obj?["bio"] as? String ?? "")
    user.setCoverPic(cover_pic: user_profile_obj?["cover_pic"] as? String ?? "")
    user.setProfilePic(profile_pic: user_profile_obj?["profile_pic"] as? String ?? "")
    
    let topic = Topic(user: user)
    topic.setTitle(title: each["title"] as? String ?? "")
    topic.setThumbnail(thumbail: each["question_image"] as? String ?? "")
    topic.id = "\(each["id"] as! Int)"
    topic.video_url = each["video_cdn"] as? String ?? ""
    if (each["linkedin_share_count"] as? Int) != nil {
       topic.share_count = "\(each["linkedin_share_count"] as! Int)"
    } else {
       topic.share_count = "\(each["linkedin_share_count"] as! String)"
    }
    if (each["whatsapp_share_count"] as? Int) != nil {
       topic.whatsapp_share_count = "\(each["whatsapp_share_count"] as! Int)"
    } else {
       topic.whatsapp_share_count = "\(each["whatsapp_share_count"] as! String)"
    }
    if (each["likes_count"] as? Int) != nil {
       topic.like_count = "\(each["likes_count"] as! Int)"
    } else {
       topic.like_count = "\(each["likes_count"] as! String)"
    }
    if (each["comment_count"] as? Int) != nil {
        topic.comment_count = "\(each["comment_count"] as! Int)"
    } else {
        topic.comment_count = "\(each["comment_count"] as! String)"
    }
    
    return topic
}
