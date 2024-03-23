//
//  CategoryViewCell.swift
//  BoloIndya
//
//  Created by apple on 7/13/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

class CategoryViewCell: UICollectionViewCell {

    var image =  UIImageView()
    var title = UILabel()
    var selected_image = UIImageView()
    
    public func configure(with category: Category) {
        let url = URL(string: category.image)
        image.kf.setImage(with: url)
        title.text = category.title
        if category.isSelected {
            selected_image.isHidden = false
        } else {
            selected_image.isHidden = true
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(image)
        addSubview(title)
        addSubview(selected_image)
        
        layer.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.8470588235)
        
        setImageView()
        setVideoTitle()
        setSelected()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImageView() {
        image.translatesAutoresizingMaskIntoConstraints = false
        image.heightAnchor.constraint(equalToConstant: 50).isActive = true
        image.widthAnchor.constraint(equalToConstant: 50).isActive = true
        image.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        image.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        image.layer.cornerRadius = 2.0
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
    }
    
    func setVideoTitle() {
        title.translatesAutoresizingMaskIntoConstraints = false
        title.heightAnchor.constraint(equalToConstant: 50).isActive = true
        title.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10).isActive = true
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

