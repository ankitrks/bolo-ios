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
    var thumbnailHome: String
    var duration: String
    var video_url: String
    var downloaded_url: String
    var id: String
    var view_count: String
    var comment_count: String
    var user: User?
    var isLiked: Bool
    var like_count: String
    var share_count: String
    var whatsapp_share_count: String
    var vb_score:String
    var languageId: String
    var music: Music?
    
    init(user: User) {
        self.title = ""
        self.thumbnail = ""
        self.thumbnailHome = ""
        self.duration = ""
        self.id = ""
        self.view_count = ""
        self.comment_count = ""
        self.video_url = ""
        self.downloaded_url = ""
        self.vb_score = ""
        self.user = user
        self.isLiked = false
        self.like_count = ""
        self.like_count = ""
        self.comment_count = ""
        self.share_count = ""
        self.whatsapp_share_count = ""
        self.languageId = ""
    }
    
    init() {
        self.title = ""
        self.thumbnail = ""
        self.thumbnailHome = ""
        self.duration = ""
        self.id = ""
        self.view_count = ""
        self.comment_count = ""
        self.video_url = ""
        self.downloaded_url = ""
        self.vb_score = ""
        self.user = nil
        self.isLiked = false
        self.like_count = ""
        self.like_count = ""
        self.comment_count = ""
        self.share_count = ""
        self.whatsapp_share_count = ""
        self.languageId = ""
    }
    
    func setTitle(title: String) {
        self.title=title
    }
    
    func setThumbnail(thumbail: String) {
        self.thumbnail=thumbail.replacingOccurrences(of:  "https://in-boloindya.s3.ap-south-1.amazonaws.com/", with: "http://in-boloindya.s3-website.ap-south-1.amazonaws.com/200x300/")

    }
    func setThumbnailHome(thumbail: String) {
          self.thumbnailHome=thumbail

      }
    
    func setDuration(duration: String) {
        self.duration=duration
    }
    
    func setId(id: String) {
        self.id=id
    }

    func setVScore(vb_score :String)  {
        self.vb_score = vb_score
    }
    func setViewCount(view_count: String) {
        self.view_count=view_count
    }
    
    func setCommentCount(comment_count: String) {
        self.comment_count=comment_count
    }
    
    func getCountNum(from countString: String) -> Double {
        var finalCount: Double?
        
        if countString.lowercased().contains("k") || countString.lowercased().contains("m") {
            if countString.count > 2 {
                let substring = (countString as NSString).substring(to: countString.count - 2)
                if let substringDouble = Double(substring) {
                    if countString.lowercased().contains("k") {
                        finalCount = substringDouble * 1000
                    } else if countString.lowercased().contains("m") {
                        finalCount = substringDouble * 1000000
                    }
                }
            }
        }
        
        if finalCount == nil, let substringDouble = Double(countString) {
            finalCount = substringDouble
        }
        
        return finalCount ?? 0
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
    topic.music = getMusicDataFromJson(result: each["music"] as? [String:Any])
    topic.setTitle(title: each["title"] as? String ?? "")
    topic.setThumbnail(thumbail: each["question_image"] as? String ?? "")
     topic.setThumbnail(thumbail: each["question_image"] as? String ?? "")
    topic.duration = each["media_duration"] as? String ?? ""
    topic.id = "\(each["id"] as! Int)"
    topic.video_url = each["video_cdn"] as? String ?? ""
    topic.downloaded_url = each["downloaded_url"] as? String ?? ""
    if (each["view_count"] as? Int) != nil {
       topic.view_count = "\(each["view_count"] as! Int)"
    } else {
       topic.view_count = "\(each["view_count"] as! String)"
    }
//    if (each["linkedin_share_count"] as? Int) != nil {
//       topic.share_count = "\(each["linkedin_share_count"] as! Int)"
//    } else {
       topic.share_count = "\(each["other_share_count"] as! String)"
      topic.vb_score = "\(each["vb_score"] as? String ?? "")"
   // }
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
    
    if let language = each["language_id"] {
        topic.languageId = "\(language)"
    }
    
    return topic
}
