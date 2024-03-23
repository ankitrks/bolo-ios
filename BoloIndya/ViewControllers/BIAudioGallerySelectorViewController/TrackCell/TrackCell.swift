//
//  TrackCell.swift
//  BoloIndya
//
//  Created by Rahul Garg on 15/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation

final class TrackCell: UITableViewCell {
    @IBOutlet private weak var thumbnailImageView: UIImageView! {
        didSet {
            thumbnailImageView.layer.cornerRadius = 4
            thumbnailImageView.contentMode = .scaleAspectFill
            thumbnailImageView.clipsToBounds = true
        }
    }
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    var model: BIMusicTrackModel? {
        didSet {
            guard let model = model else { return }
            
            if let image = model.imagePath, let url = URL(string: image) {
                thumbnailImageView.kf.setImage(with: url)
            }
            playButton.setImage(UIImage(named: "play"), for: .normal)
            titleLabel.text = model.title
            subtitleLabel.text = model.authorName
        }
    }
    
    var player: AVPlayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    @IBAction private func didTapPlayButton(_ sender: UIButton) {
        if playButton.imageView?.image == UIImage(named: "play") {
            guard let path = model?.s3FilePath, let url = URL(string: path) else { return }
            
            let playerItem = AVPlayerItem(url: url)
            
            player = AVPlayer(playerItem: playerItem)
            player?.volume = 1.0
            player?.play()
            
            playButton.setImage(UIImage(named: "pause"), for: .normal)
            
        } else {
            playButton.setImage(UIImage(named: "play"), for: .normal)
            
            player?.pause()
            player = nil
        }
    }
}
