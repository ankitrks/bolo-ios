//
//  BIVideoCollectionCell.swift
//  BoloIndya
//
//  Created by Rahul Garg on 05/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

final class BIVideoCollectionCell: UICollectionViewCell {
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.contentMode = .scaleAspectFill
            userImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var viewsLabel: UILabel!
    
    var topic: Topic?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(topic: Topic?) {
        self.topic = topic
        
        if let image = topic?.thumbnail, let url = URL(string: image) {
            userImageView.kf.setImage(with: url)
        }
        
        viewsLabel.text = topic?.view_count
        
        for layer in userImageView.layer.sublayers ?? [] {
            if let layer = layer as? CAGradientLayer {
                layer.removeFromSuperlayer()
                break
            }
        }
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor,
                           UIColor.clear.cgColor,
                           UIColor.black.withAlphaComponent(0.6).cgColor]
        gradient.locations = [0.0, 0.6, 1.0]
//        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = bounds
        userImageView.layer.insertSublayer(gradient, at: 0)
    }
}
