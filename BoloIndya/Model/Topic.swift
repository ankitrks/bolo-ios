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
    var id: String
    var view_count: String
    var comment_count: String
    var user: User
    
    init(user: User) {
        self.title = ""
        self.thumbnail = ""
        self.duration = ""
        self.id = ""
        self.view_count = ""
        self.comment_count = ""
        self.user = user
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
