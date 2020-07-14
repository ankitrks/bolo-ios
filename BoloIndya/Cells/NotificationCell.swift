//
//  NotificationCell.swift
//  BoloIndya
//
//  Created by apple on 7/12/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Kingfisher

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!

    @IBOutlet weak var created_at: UILabel!
    
    @IBOutlet weak var actor_profile_pic: UIImageView!
    
    public func configure(with notification: Notification) {
        self.title.text = notification.title.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        self.title.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.created_at.text = notification.created_at
        self.actor_profile_pic.layer.cornerRadius = (self.actor_profile_pic.frame.height / 2)
        
        if (!notification.actor_profile_pic.isEmpty) {
            let url = URL(string: notification.actor_profile_pic)
            self.actor_profile_pic.kf.setImage(with: url)
        } else {
            self.actor_profile_pic.image = UIImage(named: "user")
        }
    }

}
