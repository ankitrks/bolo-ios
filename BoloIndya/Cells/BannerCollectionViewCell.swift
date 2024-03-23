//
//  BannerCollectionViewCell.swift
//  BoloIndya
//
//  Created by apple on 8/7/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {
    
    var imageView =  UIImageView()
    
    func configure(with hash_tag: HashTag) {
        let url = URL(string: hash_tag.image)
        imageView.kf.setImage(with: url)
    }
    
    func configure(with image: String?) {
        if let image = image, let url = URL(string: image) {
            imageView.kf.setImage(with: url)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        
        setImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: self.frame.width-10).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: self.frame.height-10).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        imageView.layer.cornerRadius = 10.0
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
}
