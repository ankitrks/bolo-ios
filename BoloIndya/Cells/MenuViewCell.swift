//
//  MenuViewCell.swift
//  BoloIndya
//
//  Created by apple on 7/13/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

class MenuViewCell: UITableViewCell {

    lazy var backViewL: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        return view
    }()
    
    lazy var settingImage: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 15, y: 10, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var settingLabel: UILabel = {
        let labelView = UILabel(frame: CGRect(x: 60, y: 10, width: self.frame.width - 80, height: 30))
        return labelView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubview(backViewL)
        addSubview(settingImage)
        addSubview(settingLabel)
    }

}
