//
//  DiscoverCell.swift
//  BoloIndya
//
//  Created by apple on 8/8/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

class DiscoverCell: UICollectionViewCell {
 
    var video_image =  UIImageView()
    var views = UILabel()
    var view_image =  UIImageView()
    
    public func configure(with topic: Topic) {
        let url = URL(string: topic.thumbnail)
        video_image.kf.setImage(with: url)
        views.text = topic.view_count
        
        view_image.image = UIImage(named: "views")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(video_image)
        addSubview(views)
        addSubview(view_image)
        
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
        views.translatesAutoresizingMaskIntoConstraints = false
        views.heightAnchor.constraint(equalToConstant: 20).isActive = true
        views.widthAnchor.constraint(equalToConstant: 40).isActive = true
        views.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        views.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        views.textColor = UIColor.white

        views.font = UIFont.boldSystemFont(ofSize: 11.0)
        views.numberOfLines = 1
        
        view_image.translatesAutoresizingMaskIntoConstraints = false
        view_image.heightAnchor.constraint(equalToConstant: 20).isActive = true
        view_image.widthAnchor.constraint(equalToConstant: 20).isActive = true
        view_image.rightAnchor.constraint(equalTo: views.rightAnchor, constant: -45).isActive = true
        view_image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true

        view_image.contentMode = .scaleAspectFill
        view_image.clipsToBounds = true
    }
}
