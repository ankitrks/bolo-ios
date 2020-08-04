//
//  FollowerViewCell.swift
//  BoloIndya
//
//  Created by apple on 8/4/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Kingfisher

class FollowerViewCell: UITableViewCell {

    var pic = UIImageView()
    var username = UILabel()
    var name = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with user: User) {
        pic.layer.cornerRadius = (pic.frame.height / 2)
        
        name.text = user.name
        if !user.profile_pic.isEmpty {
            let url = URL(string: user.profile_pic)
            pic.kf.setImage(with: url)
        } else {
            pic.image = UIImage(named: "user")
        }
        username.text = "@"+user.username
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        backgroundColor = .black
        
        addSubview(pic)
        addSubview(name)
        addSubview(username)
        
        setData()
    }

    func setData() {
        
        pic.translatesAutoresizingMaskIntoConstraints = false
        pic.heightAnchor.constraint(equalToConstant: 80).isActive = true
        pic.widthAnchor.constraint(equalToConstant: 80).isActive = true
        pic.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        pic.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        pic.layer.cornerRadius = 40
        pic.contentMode = .scaleAspectFill
        pic.clipsToBounds = true
        
        name.translatesAutoresizingMaskIntoConstraints = false
        name.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        name.leftAnchor.constraint(equalTo: pic.rightAnchor, constant: 10).isActive = true
        name.rightAnchor.constraint(equalTo: rightAnchor, constant: 10).isActive = true
        name.textColor = .white
        
        name.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        username.translatesAutoresizingMaskIntoConstraints = false
        username.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5).isActive = true
        username.leftAnchor.constraint(equalTo: pic.rightAnchor, constant: 10).isActive = true
        username.rightAnchor.constraint(equalTo: rightAnchor, constant: 10).isActive = true
        username.textColor = .white
        
        username.font = UIFont.boldSystemFont(ofSize: 13.0)
        
    }
    
}
