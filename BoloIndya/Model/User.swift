//
//  User.swift
//  BoloIndya
//
//  Created by apple on 7/10/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation

class User {
    
    var id: String
    var username: String
    
    init() {
        self.id = ""
        self.username = ""
    }
    
    func setId(id: String) {
        self.id = id
    }
    
    func setUserName(username: String) {
        self.username = username
    }
}
