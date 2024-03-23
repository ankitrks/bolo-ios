//
//  BIAudioSelectCell.swift
//  BoloIndya
//
//  Created by Rahul Garg on 13/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

final class BIAudioSelectCell: UICollectionViewCell {
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.cornerRadius = 4
            userImageView.contentMode = .scaleAspectFill
            userImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    
    var result: BIMusicResultModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(music: BIMusicResultModel?) {
        self.result = music
        
        if let image = music?.questionImage, let url = URL(string: image) {
            userImageView.kf.setImage(with: url)
        }
        durationLabel.text = music?.mediaDuration
        titleLabel.text = music?.title.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        viewsLabel.text = music?.viewCount
        likeLabel.text = music?.likesCount
        
        for layer in userImageView.layer.sublayers ?? [] {
            if let layer = layer as? CAGradientLayer {
                layer.removeFromSuperlayer()
                break
            }
        }
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.black.withAlphaComponent(0.6).cgColor,
                           UIColor.clear.cgColor,
                           UIColor.clear.cgColor,
                           UIColor.black.withAlphaComponent(0.8).cgColor]
        gradient.locations = [0.0, 0.2, 0.5, 1.0]
//        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = bounds
        userImageView.layer.insertSublayer(gradient, at: 0)
    }
}
