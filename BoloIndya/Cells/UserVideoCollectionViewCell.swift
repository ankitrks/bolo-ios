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
    
    public func configure(with topic: Topic) {
        let url = URL(string: topic.thumbnail)
        video_image.kf.setImage(with: url)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(video_image)
        
        setImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImageView() {
        video_image.translatesAutoresizingMaskIntoConstraints = false
        video_image.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        video_image.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        video_image.layer.cornerRadius = 5.0
        video_image.contentMode = .scaleAspectFit
        video_image.clipsToBounds = true
        video_image.backgroundColor = .black
    }
}
