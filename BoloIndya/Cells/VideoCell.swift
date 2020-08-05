//
//  VideoCell.swift
//  BoloIndya
//
//  Created by apple on 7/10/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

protocol VideoCellDelegate {
    func goToProfile(with selected_postion: Int)
    
    func renderComments(with selected_postion: Int)
    
    func downloadAndShareVideoWhatsapp(with selected_postion: Int)
}

class VideoCell: UITableViewCell {
    
    var title = UILabel()

    var username = UILabel()
    
    var video_image =  UIImageView()
    
    var user_image = UIImageView()
    
    var like_image = UIImageView()
    
    var comment_image = UIImageView()
    
    var share_image = UIImageView()
    
    var whatsapp_share_image = UIImageView()
    
    var play_and_pause_image = UIImageView()
    
    var actions_stack = UIStackView()
    
    var player = PlayerViewClass()
    
    var delegate: VideoCellDelegate?
    
    var selected_postion: Int = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(video_image)
        addSubview(player)
        addSubview(title)
        addSubview(username)
        addSubview(actions_stack)
        
        addSubview(play_and_pause_image)
        
        setPlayer()
        setTitleAttribute()
        setUsernameAttribute()
        setImageView()
        setPlayAndPauseImage()
        
        actions_stack.translatesAutoresizingMaskIntoConstraints = false
        actions_stack.widthAnchor.constraint(equalToConstant: 40).isActive = true
        actions_stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        actions_stack.bottomAnchor.constraint(equalTo: username.topAnchor, constant: -15).isActive = true
        actions_stack.axis = .vertical
        actions_stack.spacing = CGFloat(15)
        
        actions_stack.addArrangedSubview(user_image)
        actions_stack.addArrangedSubview(like_image)
        actions_stack.addArrangedSubview(comment_image)
        actions_stack.addArrangedSubview(share_image)
        actions_stack.addArrangedSubview(whatsapp_share_image)
        
        setUserImage()
        setLikeImage()
        setCommentImage()
        setShareImage()
        setWhatsappImage()
        
        
        username.isUserInteractionEnabled = true
        user_image.isUserInteractionEnabled = true
        comment_image.isUserInteractionEnabled = true
        play_and_pause_image.isUserInteractionEnabled = true
        like_image.isUserInteractionEnabled = true
        whatsapp_share_image.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToProfile(_:)))
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(goToProfile(_:)))
        username.addGestureRecognizer(tapGesture1)
        user_image.addGestureRecognizer(tapGesture)
                
        let pauseGesture = UITapGestureRecognizer(target: self, action: #selector(pausePlayer(_:)))
        play_and_pause_image.addGestureRecognizer(pauseGesture)
        
        let likeGesture = UITapGestureRecognizer(target: self, action: #selector(tapLike(_:)))
        like_image.addGestureRecognizer(likeGesture)
        
        let commentGesture = UITapGestureRecognizer(target: self, action: #selector(renderComments))
        comment_image.addGestureRecognizer(commentGesture)
        
        let whatsappGesture = UITapGestureRecognizer(target: self, action: #selector(downloadAndShareVideoWhatsapp))
        whatsapp_share_image.addGestureRecognizer(whatsappGesture)
    }
    
    @objc func goToProfile(_ sender: UITapGestureRecognizer) {
        delegate?.goToProfile(with: selected_postion)
    }
    
    @objc func renderComments(_ sender: UITapGestureRecognizer) {
        delegate?.renderComments(with: selected_postion)
    }
    
    @objc func downloadAndShareVideoWhatsapp(_ sender: UITapGestureRecognizer) {
        delegate?.downloadAndShareVideoWhatsapp(with: selected_postion)
    }
    
    @objc func pausePlayer(_ sender: UITapGestureRecognizer) {
        if player.player?.timeControlStatus == .playing {
            player.player?.pause()
            play_and_pause_image.image = UIImage(named: "play")
        } else {
            player.player?.play()
            play_and_pause_image.image = UIImage(named: "pause")
        }
    }

    @objc func tapLike(_ sender: UITapGestureRecognizer) {
        like_image.image = like_image.image?.withRenderingMode(.alwaysTemplate)
        if like_image.tintColor == UIColor.red {
            like_image.tintColor = UIColor.white
        } else {
            like_image.tintColor = UIColor.red
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        like_image.image = like_image.image?.withRenderingMode(.alwaysTemplate)
        like_image.tintColor = UIColor.white
    }
    
    func setTitleAttribute() {
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        title.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        title.bottomAnchor.constraint(equalTo: play_and_pause_image.topAnchor, constant: -10).isActive = true
        
        title.font = UIFont.boldSystemFont(ofSize: 16.0)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.numberOfLines = 4
        title.textColor = UIColor.white
    }
    
    func setUsernameAttribute() {
           
       let screenSize = UIScreen.main.bounds.size
       username.translatesAutoresizingMaskIntoConstraints = false
       username.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
       username.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
       username.bottomAnchor.constraint(equalTo: title.topAnchor, constant: -10).isActive = true
       
       username.font = UIFont.boldSystemFont(ofSize: 14.0)
       username.lineBreakMode = NSLineBreakMode.byWordWrapping
       username.numberOfLines = 1
       username.textColor = UIColor.white
    }
    
    func setImageView() {
        video_image.translatesAutoresizingMaskIntoConstraints = false
        
        video_image.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        video_image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        video_image.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        video_image.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        
        video_image.contentMode = .scaleAspectFit
        video_image.clipsToBounds = true
        video_image.backgroundColor = .black
    }
    
    func setPlayer() {
        player.translatesAutoresizingMaskIntoConstraints = false
        player.playerLayer.videoGravity = .resizeAspect
        player.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        player.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        player.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        player.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
    }
    
    func setUserImage() {
        
        user_image.translatesAutoresizingMaskIntoConstraints = false
        user_image.layer.cornerRadius = 20
        user_image.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        user_image.contentMode = .scaleAspectFill
        user_image.clipsToBounds = true
    }
    
    func setPlayAndPauseImage() {
        play_and_pause_image.translatesAutoresizingMaskIntoConstraints = false
        play_and_pause_image.heightAnchor.constraint(equalToConstant: 40).isActive = true
        play_and_pause_image.widthAnchor.constraint(equalToConstant: 40).isActive = true
        play_and_pause_image.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        play_and_pause_image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
        play_and_pause_image.image = UIImage(named: "play")
    }
    
    func setLikeImage() {
        
        like_image.translatesAutoresizingMaskIntoConstraints = false
        like_image.heightAnchor.constraint(equalToConstant: 40).isActive = true
        like_image.image = UIImage(named: "like")
    }
    
    func setCommentImage() {
        
        comment_image.translatesAutoresizingMaskIntoConstraints = false
        comment_image.heightAnchor.constraint(equalToConstant: 40).isActive = true
        comment_image.image = UIImage(named: "comments")
    }
    
    func setShareImage() {
        
        share_image.heightAnchor.constraint(equalToConstant: 40).isActive = true
        share_image.image = UIImage(named: "share")
    }
    
    func setWhatsappImage() {
        
        whatsapp_share_image.heightAnchor.constraint(equalToConstant: 40).isActive = true

        whatsapp_share_image.image = UIImage(named: "whatsapp")
    }
} 
