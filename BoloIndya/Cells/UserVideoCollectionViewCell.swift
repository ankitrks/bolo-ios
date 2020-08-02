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
    
    public func configure(with topic: Topic) {
        let url = URL(string: topic.thumbnail)
        video_image.kf.setImage(with: url)
        video_title.text = topic.title.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(video_image)
        addSubview(video_title)
        
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
        video_image.backgroundColor = .white
    }
    
    func setVideoTitle() {
        video_title.translatesAutoresizingMaskIntoConstraints = false
        video_title.heightAnchor.constraint(equalToConstant: 50).isActive = true
        video_title.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        video_title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10).isActive = true
        video_title.textColor = UIColor.white

        video_title.font = UIFont.boldSystemFont(ofSize: 13.0)
        video_title.numberOfLines = 2
    }
}
