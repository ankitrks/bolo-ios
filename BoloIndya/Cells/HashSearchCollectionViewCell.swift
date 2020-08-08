//
//  HashSearchCollectionViewCell.swift
//  BoloIndya
//
//  Created by apple on 8/9/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

class HashSearchCollectionViewCell: UITableViewCell {
    
    var title = UILabel()
    
    var videos_and_view_count = UILabel()
    
    var actor_profile_pic = UIImageView()
    
    var share_button = UIImageView()
    
    public func configure(with hash_tag: HashTag) {
       
        title.text = "#" + hash_tag.title
        videos_and_view_count.text = hash_tag.total_views + " Views * " + hash_tag.videos_count + " Videos"
        
        actor_profile_pic.image = UIImage(named: "hash")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        backgroundColor = .black
        
        addSubview(title)
        addSubview(videos_and_view_count)
        addSubview(actor_profile_pic)
        addSubview(share_button)
        
        setData()
    }
    
    func setData() {
        
        actor_profile_pic.translatesAutoresizingMaskIntoConstraints = false
        actor_profile_pic.heightAnchor.constraint(equalToConstant: 50).isActive = true
        actor_profile_pic.widthAnchor.constraint(equalToConstant: 50).isActive = true
        actor_profile_pic.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        actor_profile_pic.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        actor_profile_pic.layer.cornerRadius = 25
        actor_profile_pic.contentMode = .scaleAspectFill
        actor_profile_pic.clipsToBounds = true
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        title.leftAnchor.constraint(equalTo: actor_profile_pic.rightAnchor, constant: 5).isActive = true
        title.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        title.numberOfLines = 2
        title.textColor = .white
        
        title.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        videos_and_view_count.translatesAutoresizingMaskIntoConstraints = false
        videos_and_view_count.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5).isActive = true
        videos_and_view_count.leftAnchor.constraint(equalTo: actor_profile_pic.rightAnchor, constant: 5).isActive = true
        videos_and_view_count.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        videos_and_view_count.textColor = .white
        
        videos_and_view_count.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        share_button.translatesAutoresizingMaskIntoConstraints = false
        share_button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        share_button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        share_button.topAnchor.constraint(equalTo: videos_and_view_count.bottomAnchor, constant: 5).isActive = true
        share_button.leftAnchor.constraint(equalTo: actor_profile_pic.rightAnchor, constant: 5).isActive = true
        
        share_button.layer.cornerRadius = 10.0
        
        share_button.layer.backgroundColor = UIColor.systemBlue.cgColor
        share_button.image = UIImage(named: "share_url")
    }
    
}
