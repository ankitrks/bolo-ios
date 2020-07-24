//
//  CategoryCollectionViewCell.swift
//  BoloIndya
//
//  Created by apple on 7/24/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

protocol CategoryCellDelegate {
    func goToCategory(with category: Category)
}

class CategoryCollectionViewCell: UICollectionViewCell {
    
    var name =  UILabel()
    var category: Category?
    var delegate: CategoryCellDelegate?
    
    public func configure(with category: Category) {
        name.text = category.title
        self.category = category
        name.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToCategory(_:)))
        name.addGestureRecognizer(tapGesture)
    }

    @objc func goToCategory(_ sender: UITapGestureRecognizer) {
        delegate?.goToCategory(with: category ?? Category())
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(name)
        
        setName()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setName() {
        name.translatesAutoresizingMaskIntoConstraints = false
        name.heightAnchor.constraint(equalToConstant: 20).isActive = true
        name.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        name.textColor = .black
    }
    
}
