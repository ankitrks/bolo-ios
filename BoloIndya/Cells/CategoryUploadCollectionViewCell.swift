//
//  CategoryUploadCollectionViewCell.swift
//  BoloIndya
//
//  Created by apple on 8/5/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Kingfisher

protocol CategoryUploadCollectionViewCellDelegate {
    func chooseLanguage(with selected_language: Languages)
}

class CategoryUploadCollectionViewCell: UICollectionViewCell {
 
    var title = UILabel()
    var image =  UIImageView()
          
    public func configure(with category: Category) {
        title.text = category.title
        let url = URL(string: category.image)
        image.kf.setImage(with: url)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(image)
        addSubview(title)
        
        setImageView()
        setVideoTitle()
    }
      
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
      
    func setVideoTitle() {
        title.translatesAutoresizingMaskIntoConstraints = false
        title.widthAnchor.constraint(equalToConstant: self.frame.width-50).isActive = true
        title.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        title.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 5).isActive = true
        title.textAlignment = .center
        title.textColor = UIColor.white

        title.font = UIFont.boldSystemFont(ofSize: 12.0)
        title.numberOfLines = 2
    }
    
    
    func setImageView() {
        image.translatesAutoresizingMaskIntoConstraints = false
        image.widthAnchor.constraint(equalToConstant: 40).isActive = true
        image.heightAnchor.constraint(equalToConstant: 40).isActive = true
        image.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        image.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
    }
}
