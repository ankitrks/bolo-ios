//
//  Notification.swift
//  BoloIndya
//
//  Created by apple on 7/12/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation
import UIKit

class Notification {
    
    var id: Int
    var title: String
    var read_status: Int
    var notification_type: String
    var actor_profile_pic: String
    var created_at: String
    
    init(id: Int, title: String, read_status: Int, notification_type: String, actor_profile_pic: String, created_at: String) {
        self.id = id
        self.title = title
        self.read_status = read_status
        self.notification_type = notification_type
        self.actor_profile_pic = actor_profile_pic
        self.created_at = created_at
    }
}
