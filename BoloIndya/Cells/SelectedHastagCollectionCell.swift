//
//  SelectedHastagCollectionCell.swift
//  BoloIndya
//
//  Created by Rahul Garg on 19/12/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

class SelectedHastagCollectionCell: UICollectionViewCell {
    
    var title = UILabel()
    var button = UIButton()
      
    public func configure(with hash_tag: String) {
        title.text = hash_tag
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(title)
        addSubview(button)
        
        contentView.isUserInteractionEnabled = true
        isUserInteractionEnabled = true
        
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        setTitle()
        addButton()
    }
     
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    func setTitle() {
        title.translatesAutoresizingMaskIntoConstraints = false
        title.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        title.heightAnchor.constraint(equalToConstant: 20).isActive = true
        title.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0).isActive = true
        title.textAlignment = .center
        title.textColor = UIColor.white

        title.font = UIFont.systemFont(ofSize: 12.0, weight: .semibold)
        title.numberOfLines = 1
    }
    
    func addButton() {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 10).isActive = true
        button.heightAnchor.constraint(equalToConstant: 10).isActive = true
        button.leftAnchor.constraint(equalTo: title.rightAnchor, constant: 3).isActive = true
        button.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0).isActive = true
        button.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        button.setImage(UIImage(named: "close_white"), for: .normal)
    }
}
