//
//  HashUploadCollectionViewCell.swift
//  BoloIndya
//
//  Created by apple on 8/6/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

class HashUploadCollectionViewCell: UICollectionViewCell {
    
    var title = UILabel()
      
    public func configure(with hash_tag: String) {
        title.text = hash_tag
    }

    override init(frame: CGRect) {
         super.init(frame: frame)
         addSubview(title)
         
         setVideoTitle()
    }
     
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    func setVideoTitle() {
        title.translatesAutoresizingMaskIntoConstraints = false
        title.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        title.heightAnchor.constraint(equalToConstant: 20).isActive = true
        title.textAlignment = .center
        title.textColor = UIColor.white

        title.font = UIFont.boldSystemFont(ofSize: 13.0)
        title.numberOfLines = 1
    }
}
