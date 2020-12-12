//
//  FollowerViewCell.swift
//  BoloIndya
//
//  Created by apple on 8/4/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Kingfisher


protocol FollowerViewCellDelegate {
    func followUser(with selected_postion: Int)
}

class FollowerViewCell: UITableViewCell {

    var pic = UIImageView()
    var username = UILabel()
    var name = UILabel()
    
    var follow_button = UIButton()
    
    var views_label = UILabel()
    var views_count = UILabel()

    var followers_label = UILabel()
    var followers_count = UILabel()
    
    var videos_label = UILabel()
    var videos_count = UILabel()
    
    var delegate: FollowerViewCellDelegate?
    
    var selected_postion: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with user: User) {
        pic.layer.cornerRadius = (pic.frame.height / 2)
        
        name.text = user.name
        if !user.profile_pic.isEmpty {
            let url = URL(string: user.profile_pic)
            pic.kf.setImage(with: url, placeholder: UIImage(named: "user"))
        } else {
            pic.image = UIImage(named: "user")
        }
        username.text = "@"+user.username
        views_count.text = user.view_count
        followers_count.text = user.follower_count
        videos_count.text = "\(user.vb_count)"
        
        if (user.isFollowing) {
            follow_button.setTitle("Following", for: .normal)
            follow_button.layer.backgroundColor = UIColor.white.cgColor
            follow_button.setTitleColor(UIColor.black, for: .normal)
        } else {
            follow_button.setTitle("Follow", for: .normal)
            follow_button.layer.backgroundColor = (UIColor(hex: "10A5F9") ?? UIColor.red).cgColor
            follow_button.setTitleColor(.white, for: .normal)
        }
        follow_button.titleLabel?.font = .systemFont(ofSize: 11.0)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        backgroundColor = .black
        
        addSubview(pic)
        addSubview(follow_button)
        addSubview(name)
        addSubview(username)
        
        addSubview(views_count)
        addSubview(views_label)
        addSubview(followers_count)
        addSubview(followers_label)
        addSubview(videos_label)
        addSubview(videos_count)

        setData()
    }

    func setData() {
        
        pic.translatesAutoresizingMaskIntoConstraints = false
        pic.heightAnchor.constraint(equalToConstant: 70).isActive = true
        pic.widthAnchor.constraint(equalToConstant: 70).isActive = true
        pic.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        pic.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        pic.layer.cornerRadius = 40
        pic.contentMode = .scaleAspectFill
        pic.clipsToBounds = true
        
        follow_button.translatesAutoresizingMaskIntoConstraints = false
        follow_button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        follow_button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        follow_button.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        follow_button.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true

        follow_button.layer.cornerRadius = 10.0

        name.translatesAutoresizingMaskIntoConstraints = false
        name.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        name.leftAnchor.constraint(equalTo: pic.rightAnchor, constant: 5).isActive = true
        name.rightAnchor.constraint(equalTo: follow_button.leftAnchor, constant: -10).isActive = true
        name.textColor = .white

        name.font = UIFont.boldSystemFont(ofSize: 13.0)

        username.translatesAutoresizingMaskIntoConstraints = false
        username.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5).isActive = true
        username.leftAnchor.constraint(equalTo: pic.rightAnchor, constant: 5).isActive = true
        username.rightAnchor.constraint(equalTo: follow_button.leftAnchor, constant: -10).isActive = true
        username.textColor = .white

        username.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        followers_count.translatesAutoresizingMaskIntoConstraints = false
        followers_count.heightAnchor.constraint(equalToConstant: 20).isActive = true
        followers_count.widthAnchor.constraint(equalToConstant: 60).isActive = true
        followers_count.leftAnchor.constraint(equalTo: pic.rightAnchor, constant: 5).isActive = true
        followers_count.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 0).isActive = true

        followers_count.textColor = UIColor.white
        followers_count.textAlignment = .center
        followers_count.font = UIFont.boldSystemFont(ofSize: 11.0)

        followers_label.translatesAutoresizingMaskIntoConstraints = false
        followers_label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        followers_label.widthAnchor.constraint(equalToConstant: 60).isActive = true
        followers_label.topAnchor.constraint(equalTo: followers_count.bottomAnchor, constant: 0).isActive = true
        followers_label.leftAnchor.constraint(equalTo: pic.rightAnchor, constant: 5).isActive = true
        followers_label.textColor = UIColor.white
        followers_label.textAlignment = .center
        followers_label.font = UIFont.boldSystemFont(ofSize: 11.0)

        followers_label.text = "Followers"

        videos_count.translatesAutoresizingMaskIntoConstraints = false
        videos_count.widthAnchor.constraint(equalToConstant: 50).isActive = true
        videos_count.heightAnchor.constraint(equalToConstant: 20).isActive = true
        videos_count.leftAnchor.constraint(equalTo: followers_count.rightAnchor, constant: 5).isActive = true
        videos_count.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 0).isActive = true
        videos_count.textColor = UIColor.white
        videos_count.textAlignment = .center
        videos_count.font = UIFont.boldSystemFont(ofSize: 11.0)

        videos_label.translatesAutoresizingMaskIntoConstraints = false
        videos_label.widthAnchor.constraint(equalToConstant: 50).isActive = true
        videos_label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        videos_label.topAnchor.constraint(equalTo: videos_count.bottomAnchor, constant: 0).isActive = true
        videos_label.leftAnchor.constraint(equalTo: followers_label.rightAnchor, constant: 5).isActive = true
        videos_label.textColor = UIColor.white
        videos_label.textAlignment = .center
        videos_label.font = UIFont.boldSystemFont(ofSize: 11.0)

        videos_label.text = "Videos"
        
        views_count.translatesAutoresizingMaskIntoConstraints = false
        views_count.widthAnchor.constraint(equalToConstant: 50).isActive = true
        views_count.heightAnchor.constraint(equalToConstant: 20).isActive = true
        views_count.leftAnchor.constraint(equalTo: videos_count.rightAnchor, constant: 5).isActive = true
        views_count.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 0).isActive = true
        views_count.textColor = UIColor.white
        views_count.textAlignment = .center
        views_count.font = UIFont.boldSystemFont(ofSize: 11.0)

        views_label.translatesAutoresizingMaskIntoConstraints = false
        views_label.widthAnchor.constraint(equalToConstant: 50).isActive = true
        views_label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        views_label.topAnchor.constraint(equalTo: views_count.bottomAnchor, constant: 0).isActive = true
        views_label.leftAnchor.constraint(equalTo: videos_label.rightAnchor, constant: 5).isActive = true
        views_label.textColor = UIColor.white
        views_label.textAlignment = .center
        views_label.font = UIFont.boldSystemFont(ofSize: 11.0)

        views_label.text = "Views"
        
        follow_button.isUserInteractionEnabled = true
        let followGesture = UITapGestureRecognizer(target: self, action: #selector(followUser(_:)))
        follow_button.addGestureRecognizer(followGesture)
    }
    
    @objc func followUser(_ sender: UITapGestureRecognizer) {
        delegate?.followUser(with: selected_postion)
    }
    
}
