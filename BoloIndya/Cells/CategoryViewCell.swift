//
//  CategoryViewCell.swift
//  BoloIndya
//
//  Created by apple on 7/13/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

class CategoryViewCell: UITableViewCell {

    lazy var name: UIButton = {
       let labelView = UIButton(frame: CGRect(x: 30, y: 10, width: self.frame.width, height: 30))
        labelView.layer.borderColor = UIColor.darkGray.cgColor
        labelView.layer.borderWidth = 1.0
        labelView.layer.cornerRadius = 10.0
        labelView.setTitleColor(UIColor.darkGray, for: .normal)
       return labelView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubview(name)
    }
}
