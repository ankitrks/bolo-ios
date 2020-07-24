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
    
    init(user: User) {
        self.title = ""
        self.id = ""
        self.user = user
        self.date = ""
    }
    
    func setTitle(title: String) {
        self.title=title
    }
    
    func setId(id: String) {
        self.id=id
    }

}
