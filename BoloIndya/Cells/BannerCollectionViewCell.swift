//
//  BannerCollectionViewCell.swift
//  BoloIndya
//
//  Created by apple on 8/7/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {
    
    var image =  UIImageView()
    
    public func configure(with hash_tag: HashTag) {
        let url = URL(string: hash_tag.image)
        image.kf.setImage(with: url)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(image)
        
        setImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImageView() {
        image.translatesAutoresizingMaskIntoConstraints = false
        image.widthAnchor.constraint(equalToConstant: self.frame.width-10).isActive = true
        image.heightAnchor.constraint(equalToConstant: self.frame.height-10).isActive = true
        image.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        image.layer.cornerRadius = 10.0
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
    }
}
