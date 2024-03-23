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
    
    var title = UILabel()

    var created_at = UILabel()
    
    var actor_profile_pic = UIImageView()
    
    public func configure(with notification: Notification) {
        self.title.text = notification.title.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        self.title.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.created_at.text = notification.created_at
        self.actor_profile_pic.layer.cornerRadius = (self.actor_profile_pic.frame.height / 2)
        
        if (!notification.actor_profile_pic.isEmpty) {
            let url = URL(string: notification.actor_profile_pic)
            self.actor_profile_pic.kf.setImage(with: url, placeholder: UIImage(named: "user"))
        } else {
            self.actor_profile_pic.image = UIImage(named: "user")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        backgroundColor = .black
        
        addSubview(title)
        addSubview(created_at)
        addSubview(actor_profile_pic)

        setData()
    }
    
    func setData() {
        
        actor_profile_pic.translatesAutoresizingMaskIntoConstraints = false
        actor_profile_pic.heightAnchor.constraint(equalToConstant: 30).isActive = true
        actor_profile_pic.widthAnchor.constraint(equalToConstant: 30).isActive = true
        actor_profile_pic.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        actor_profile_pic.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        actor_profile_pic.layer.cornerRadius = 35/2
        actor_profile_pic.contentMode = .scaleAspectFill
        actor_profile_pic.clipsToBounds = true
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        title.leftAnchor.constraint(equalTo: actor_profile_pic.rightAnchor, constant: 10).isActive = true
        title.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        title.numberOfLines = 2
        title.textColor = .white
        title.font = UIFont.systemFont(ofSize: 13.0, weight: .medium)

        created_at.translatesAutoresizingMaskIntoConstraints = false
        created_at.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 3).isActive = true
        created_at.leftAnchor.constraint(equalTo: actor_profile_pic.rightAnchor, constant: 10).isActive = true
        created_at.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        created_at.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        created_at.textColor = .white

        created_at.font = UIFont.systemFont(ofSize: 11.0)
    }
    
}
