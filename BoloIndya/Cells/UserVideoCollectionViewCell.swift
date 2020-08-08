//
//  UserVideoCollectionViewCell.swift
//  BoloIndya
//
//  Created by apple on 7/14/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Kingfisher

class UserVideoCollectionViewCell: UICollectionViewCell {
    
    var video_image =  UIImageView()
    var video_title = UILabel()
    
    var views = UILabel()
    var view_image =  UIImageView()
    var likes = UILabel()
    var duration = UILabel()
    var like_image =  UIImageView()
    
    public func configure(with topic: Topic) {
        let url = URL(string: topic.thumbnail)
        video_image.kf.setImage(with: url)
        video_title.text = topic.title.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        
        views.text = topic.view_count
        view_image.image = UIImage(named: "views")
        
        likes.text = topic.like_count
        like_image.image = UIImage(named: "heart_non_filled")
        if topic.isLiked {
            like_image.image = UIImage(named: "like")
            like_image.image = like_image.image?.withRenderingMode(.alwaysTemplate)
            like_image.tintColor = UIColor.red
        }
        duration.text = topic.duration
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(video_image)
        addSubview(video_title)
        
        addSubview(views)
        addSubview(view_image)
        addSubview(likes)
        addSubview(like_image)
        addSubview(duration)
        
        setImageView()
        setVideoTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImageView() {
        video_image.translatesAutoresizingMaskIntoConstraints = false
        video_image.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        video_image.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        video_image.layer.cornerRadius = 2.0
        video_image.contentMode = .scaleAspectFill
        video_image.clipsToBounds = true
        video_image.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.8470588235)
    }
    
    func setVideoTitle() {
        
        view_image.translatesAutoresizingMaskIntoConstraints = false
        view_image.heightAnchor.constraint(equalToConstant: 11).isActive = true
        view_image.widthAnchor.constraint(equalToConstant: 11).isActive = true
        view_image.leftAnchor.constraint(equalTo: leftAnchor, constant: 2).isActive = true
        view_image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        
        view_image.layer.cornerRadius = 2.0
        view_image.contentMode = .scaleAspectFill
        view_image.clipsToBounds = true
        
        views.translatesAutoresizingMaskIntoConstraints = false
        views.heightAnchor.constraint(equalToConstant: 11).isActive = true
        views.widthAnchor.constraint(equalToConstant: 40).isActive = true
        views.leftAnchor.constraint(equalTo: view_image.rightAnchor, constant: 2).isActive = true
        views.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        views.textColor = UIColor.white
        
        views.font = UIFont.boldSystemFont(ofSize: 9.0)
        views.numberOfLines = 1
        
        like_image.translatesAutoresizingMaskIntoConstraints = false
        like_image.heightAnchor.constraint(equalToConstant: 11).isActive = true
        like_image.widthAnchor.constraint(equalToConstant: 11).isActive = true
        like_image.rightAnchor.constraint(equalTo: rightAnchor, constant: -2).isActive = true
        like_image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        
        like_image.layer.cornerRadius = 2.0
        like_image.contentMode = .scaleAspectFill
        like_image.clipsToBounds = true
        
        likes.translatesAutoresizingMaskIntoConstraints = false
        likes.heightAnchor.constraint(equalToConstant: 11).isActive = true
        likes.widthAnchor.constraint(equalToConstant: 40).isActive = true
        likes.rightAnchor.constraint(equalTo: like_image.leftAnchor, constant: -2).isActive = true
        likes.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        likes.textColor = UIColor.white
        likes.textAlignment = .right
        likes.font = UIFont.boldSystemFont(ofSize: 9.0)
        likes.numberOfLines = 1
        
        duration.translatesAutoresizingMaskIntoConstraints = false
        duration.heightAnchor.constraint(equalToConstant: 11).isActive = true
        duration.widthAnchor.constraint(equalToConstant: 40).isActive = true
        duration.leftAnchor.constraint(equalTo: leftAnchor, constant: 2).isActive = true
        duration.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        duration.textColor = UIColor.white
        
        duration.font = UIFont.boldSystemFont(ofSize: 9.0)
        duration.numberOfLines = 1
        
        video_title.translatesAutoresizingMaskIntoConstraints = false
        video_title.heightAnchor.constraint(equalToConstant: 40).isActive = true
        video_title.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        video_title.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        video_title.bottomAnchor.constraint(equalTo: view_image.topAnchor, constant: 0).isActive = true
        video_title.textColor = UIColor.white
        
        video_title.font = UIFont.boldSystemFont(ofSize: 13.0)
        video_title.numberOfLines = 2
        
    }
}
