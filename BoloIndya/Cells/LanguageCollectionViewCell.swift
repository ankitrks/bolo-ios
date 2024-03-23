//
//  LanguageCollectionViewCell.swift
//  BoloIndya
//
//  Created by apple on 8/2/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

class LanguageCollectionViewCell: UICollectionViewCell {

    var image =  UIImageView()
    var selected_image = UIImageView()
    var title = UILabel()
    
    var identifier: String  = "LanguageCollectionViewCell"
    
    public func configure(with language: Languages) {
        image.image = UIImage(named: language.image)
        title.text = language.title
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(image)
        addSubview(title)
        addSubview(selected_image)
        
        setImageView()
        setVideoTitle()
        setSelected()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImageView() {
        image.translatesAutoresizingMaskIntoConstraints = false
        image.widthAnchor.constraint(equalToConstant: self.frame.width-5).isActive = true
        image.heightAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        image.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        image.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        image.layer.cornerRadius = 10.0
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
    }
    
    func setVideoTitle() {
        title.translatesAutoresizingMaskIntoConstraints = false
        title.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 5).isActive = true
        title.textAlignment = .center
        title.textColor = UIColor.white

        title.font = UIFont.boldSystemFont(ofSize: 13.0)
        title.numberOfLines = 2
    }
    
    func setSelected() {
        
        selected_image.translatesAutoresizingMaskIntoConstraints = false
        selected_image.widthAnchor.constraint(equalToConstant: 20).isActive = true
        selected_image.heightAnchor.constraint(equalToConstant: 20).isActive = true
        selected_image.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        selected_image.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        selected_image.contentMode = .scaleAspectFill
        selected_image.clipsToBounds = true
        
        selected_image.image = UIImage(named: "selected")
    }
}


