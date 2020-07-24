//
//  CommentViewCell.swift
//  BoloIndya
//
//  Created by apple on 7/24/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

class CommentViewCell: UITableViewCell {

    lazy var backViewL: UIView = {
           let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
           return view
       }()
       
       lazy var settingImage: UIImageView = {
           let imageView = UIImageView(frame: CGRect(x: 15, y: 10, width: 30, height: 30))
           imageView.translatesAutoresizingMaskIntoConstraints = false
           imageView.layer.cornerRadius = 15
           imageView.contentMode = .scaleAspectFill
           imageView.clipsToBounds = true
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
