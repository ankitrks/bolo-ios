//
//  VideoCell.swift
//  BoloIndya
//
//  Created by apple on 7/10/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {
    
    var title = UILabel()

    var username = UILabel()
    
    var video_image =  UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(video_image)
        addSubview(title)
        addSubview(username)
        
        setTitleAttribute()
        setUsernameAttribute()
        setImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitleAttribute() {
        
        let screenSize = UIScreen.main.bounds.size
        title.translatesAutoresizingMaskIntoConstraints = false
        title.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        
        title.font = UIFont.boldSystemFont(ofSize: 16.0)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.numberOfLines = 4
        title.textColor = UIColor.white
    }
    
    func setUsernameAttribute() {
           
       let screenSize = UIScreen.main.bounds.size
       username.translatesAutoresizingMaskIntoConstraints = false
       username.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        username.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        username.bottomAnchor.constraint(equalTo: title.topAnchor, constant: 0).isActive = true
       
       username.font = UIFont.boldSystemFont(ofSize: 14.0)
       username.lineBreakMode = NSLineBreakMode.byWordWrapping
       username.numberOfLines = 1
       username.textColor = UIColor.white
    }
    
    func setImageView() {
        video_image.translatesAutoresizingMaskIntoConstraints = false
        video_image.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        video_image.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        video_image.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        video_image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        video_image.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        video_image.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        
        video_image.contentMode = .scaleAspectFit
        video_image.clipsToBounds = true
        video_image.backgroundColor = .black
    }
} 
