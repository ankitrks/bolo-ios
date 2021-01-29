//
//  BIVideoCell.swift
//  BoloIndya
//
//  Created by Rahul Garg on 22/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import MarqueeLabel
import AVKit

final class BIVideoCell: UITableViewCell {
    @IBOutlet weak var videoPlayerView: UIView! {
        didSet {
            videoPlayerView.backgroundColor = .black
        }
    }
    @IBOutlet weak var thumbnailImageView: UIImageView! {
        didSet {
            thumbnailImageView.contentMode = .scaleAspectFill
            thumbnailImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var userTitleView: UIView!
    @IBOutlet weak var userTitleStackView: UIStackView!
    @IBOutlet weak var usernameLabel: UILabel! {
        didSet {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapUsernameLabel(_:)))
            usernameLabel.addGestureRecognizer(gesture)
            usernameLabel.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var songStackView: UIStackView! {
        didSet {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapSongLabel(_:)))
            songStackView.addGestureRecognizer(gesture)
            songStackView.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var songLabel: MarqueeLabel!
    
    @IBOutlet weak var actionablesStackView: UIStackView!
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.cornerRadius = userImageView.bounds.width/2
            userImageView.contentMode = .scaleAspectFill
            userImageView.clipsToBounds = true
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapUserImageView(_:)))
            userImageView.addGestureRecognizer(gesture)
            userImageView.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var likeButton: UIButton! {
        didSet {
            likeButton.setImage(UIImage(named: "like"), for: .normal)
            likeButton.setImage(UIImage(named: "like_blue"), for: .selected)
        }
    }
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var whatsappButton: UIButton!
    @IBOutlet weak var whatsappLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    var playerView: PlayerViewClass?
    
    weak var delegate: VideoCellDelegate?
    var selected_postion = 0
    private var topic: Topic?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    private func setUpPlayerView() {
        playerView = PlayerViewClass()
        playerView?.delegate = self
        playerView?.frame = videoPlayerView.bounds
        playerView?.tag = Constants.viewTags.trendingPlayer
        videoPlayerView.addSubview(playerView!)
        
        playerView?.player?.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        
//        NotificationCenter.default.addObserver(self, selector: #selector(playerItemReachedEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(playerItemReachedEnd), name: Notification.Name.UIApplicationWillResignActive, object: player.currentItem)
    }
    
    func configure(topic: Topic?) {
        self.topic = topic
        
        subtitleLabel.text = topic?.title.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        
        if let music = topic?.music?.title, !music.isEmpty {
            let attributedText = NSMutableAttributedString()
            
            if let name = topic?.user?.username, !name.isEmpty {
                let attrbutedText2 = NSAttributedString(string: "Original Sound by ")
                attributedText.append(attrbutedText2)
                
                let attrbutedText3 = NSAttributedString(string: "\(name)", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: "10A5F9") ?? .white])
                attributedText.append(attrbutedText3)
                
                let attrbutedText4 = NSAttributedString(string: " - ")
                attributedText.append(attrbutedText4)
            }
            
            let attrbutedText5 = NSAttributedString(string: music)
            attributedText.append(attrbutedText5)
            
            songLabel.attributedText = attributedText
            songStackView.isHidden = false
            
            songLabel.fadeLength = 5
            songLabel.speed = MarqueeLabel.SpeedLimit.rate(50)
            songLabel.animationDelay = 2
            songLabel.trailingBuffer = 50
            
            songLabel.restartLabel()
        } else {
            songStackView.isHidden = true
        }
        
        if let image = topic?.thumbnail {
            setThumbnailImage(urlString: image)
            setThumbnailImageHidden(isHidden: false)
            setVideoPlayerViewHidden(isHidden: true)
        } else {
            setThumbnailImageHidden(isHidden: true)
            setVideoPlayerViewHidden(isHidden: false)
        }
        
        if let name = topic?.user?.username, !name.isEmpty {
            usernameLabel.text = "@\(name)"
            usernameLabel.isHidden = false
        } else {
            usernameLabel.isHidden = true
        }
        
        likeLabel.text = topic?.like_count
        commentLabel.text = topic?.comment_count
        shareLabel.text = topic?.share_count
        whatsappLabel.text = topic?.whatsapp_share_count

        if let userImage = topic?.user?.profile_pic, !userImage.isEmpty {
            let userImageUrl = URL(string: userImage)
            userImageView.kf.setImage(with: userImageUrl, placeholder: UIImage(named: "user"))
        } else {
            userImageView.image = UIImage(named: "user")
        }

        likeButton.isSelected = topic?.isLiked ?? false
        
        setUpPlayerView()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.playerView?.frame = self.videoPlayerView.bounds
        }
        
        for layer in userTitleView.layer.sublayers ?? [] {
            if let layer = layer as? CAGradientLayer {
                layer.removeFromSuperlayer()
                break
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            let gradient = CAGradientLayer()
            gradient.colors = [UIColor.clear.cgColor,
                               UIColor.black.withAlphaComponent(0.8).cgColor]
            gradient.locations = [0.0, 1.0]
            gradient.frame = self.userTitleView.bounds
            self.userTitleView.layer.insertSublayer(gradient, at: 0)
        }
    }
    
    func play() {
        if let videoString = topic?.video_url, let videoUrl = URL(string: videoString) {
            print("zzzzzzz \(videoUrl)")
            playerView?.play(with: videoUrl)
        }
    }
    
    func pause() {
        playerView?.pauseVideo()
    }
    
    private func setThumbnailImageHidden(isHidden: Bool) {
        thumbnailImageView?.isHidden = isHidden
    }
    
    private func setThumbnailImage(urlString: String) {
        thumbnailImageView?.kf.setImage(with: URL(string: urlString))
    }
    
    private func setVideoPlayerViewHidden(isHidden: Bool) {
        videoPlayerView.isHidden = isHidden
    }
    
    @objc private func didTapUserImageView(_ sender: UITapGestureRecognizer) {
        delegate?.goToProfile(with: selected_postion)
    }
    
    @objc private func didTapUsernameLabel(_ sender: UITapGestureRecognizer) {
        delegate?.goToProfile(with: selected_postion)
    }
    
    @objc private func didTapSongLabel(_ sender: UITapGestureRecognizer) {
        delegate?.goToAudioSelect(with: selected_postion)
    }
    
    @IBAction private func didTapLikeButton(_ sender: UIButton) {
        likeButton.isSelected = !likeButton.isSelected
        
        if let topic = topic, let intLike = Int(topic.like_count) {
            var like: Int
            if topic.isLiked {
                like = intLike - 1
            } else {
                like = intLike + 1
            }
            
            likeLabel.text = "\(like)"
            topic.like_count = "\(like)"
        }
        
        delegate?.likedTopic(with: selected_postion)
    }
    
    @IBAction private func didTapCommentButton(_ sender: UIButton) {
        delegate?.renderComments(with: selected_postion)
    }
    
    @IBAction private func didTapShareButton(_ sender: UIButton) {
        delegate?.goToSharing(with: selected_postion)
    }
    
    @IBAction private func didTapWhatsappButton(_ sender: UIButton) {
        delegate?.downloadAndShareVideoWhatsapp(with: selected_postion)
    }
    
    @IBAction private func didTapMoreButton(_ sender: UIButton) {
        delegate?.didTapOptions(with: selected_postion)
    }
}


extension BIVideoCell: PlayerViewClassDelegate {
    func playerStatus(status: AVPlayerItem.Status) {
        switch status {
        case .readyToPlay:
            DispatchQueue.main.async {
                self.setVideoPlayerViewHidden(isHidden: false)
                self.setThumbnailImageHidden(isHidden: true)
                
                self.videoPlayerView.bounds = self.bounds
                self.playerView?.frame = self.videoPlayerView.bounds
            }
        default:
            break
        }
    }
}
