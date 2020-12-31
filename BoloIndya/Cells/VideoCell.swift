//
//  VideoCell.swift
//  BoloIndya
//
//  Created by apple on 7/10/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

protocol VideoCellDelegate {
    func didTapOptions(with selected_postion: Int)
    func goToProfile(with selected_postion: Int)
    func goToSharing(with selected_postion: Int)

    func renderComments(with selected_postion: Int)

    func downloadAndShareVideoWhatsapp(with selected_postion: Int)

    func likedTopic(with selected_postion: Int)
    
    func didTapPlayer()
}

class VideoCell: UITableViewCell {

    var title = UILabel()

    var username = UILabel()
    var like_count = UILabel()
    var comment_count = UILabel()
    var share_count = UILabel()
    var whatsapp_share_count = UILabel()
    
    var optionButton = UIButton()

    var video_image =  UIImageView()

    var user_image = UIImageView()

    var like_image = UIImageView()

    var comment_image = UIImageView()

    var share_image = UIImageView()

    var whatsapp_share_image = UIImageView()

    var play_and_pause_image = UIImageView()

    var actions_stack = UIStackView()

    var play_click = UIView()

    var player = PlayerViewClass()

    var delegate: VideoCellDelegate?

    var selected_postion: Int = 0
    
    var topic: Topic?

    var duration = UILabel()
    var playerSlider = UISlider()
    var sizeFrame = CGSize()
    override func awakeFromNib() {
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = true

        backgroundColor = .black
        selectionStyle = .none
        self.frame.size = sizeFrame


        addSubview(player)
        addSubview(video_image)
        addSubview(play_click)
        addSubview(title)
        addSubview(username)
        addSubview(actions_stack)
        addSubview(optionButton)
      //  play_click.frame.size = sizeFrame

        //        addSubview(play_and_pause_image)
        //        addSubview(playerSlider)
        //        addSubview(duration)



        setTitleAttribute()
        setUsernameAttribute()
        setImageView()
        setPlayer()
        clickPlayer()
        //setPlayAndPauseImage()

        //        playerSlider.isHidden = true
        //        play_and_pause_image.isHidden = true
        //        duration.isHidden = true

        actions_stack.translatesAutoresizingMaskIntoConstraints = false
        actions_stack.widthAnchor.constraint(equalToConstant: 50).isActive = true
        actions_stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        actions_stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60).isActive = true
        actions_stack.axis = .vertical
        actions_stack.alignment = .center
        actions_stack.spacing = CGFloat(20)

        actions_stack.addArrangedSubview(user_image)
        
        let likeStack = UIStackView()
        likeStack.axis = .vertical
        likeStack.spacing = CGFloat(0)
        likeStack.alignment = .center
        likeStack.addArrangedSubview(like_image)
        likeStack.addArrangedSubview(like_count)
        actions_stack.addArrangedSubview(likeStack)
        
        let commentStack = UIStackView()
        commentStack.axis = .vertical
        commentStack.spacing = CGFloat(0)
        commentStack.alignment = .center
        commentStack.addArrangedSubview(comment_image)
        commentStack.addArrangedSubview(comment_count)
        actions_stack.addArrangedSubview(commentStack)
        
        let shareStack = UIStackView()
        shareStack.axis = .vertical
        shareStack.spacing = CGFloat(0)
        shareStack.alignment = .center
        shareStack.addArrangedSubview(share_image)
        shareStack.addArrangedSubview(share_count)
        actions_stack.addArrangedSubview(shareStack)
        
        let whatsappStack = UIStackView()
        whatsappStack.axis = .vertical
        whatsappStack.spacing = CGFloat(0)
        whatsappStack.alignment = .center
        whatsappStack.addArrangedSubview(whatsapp_share_image)
        whatsappStack.addArrangedSubview(whatsapp_share_count)
        actions_stack.addArrangedSubview(whatsappStack)

        setUserImage()
        setLikeImage()
        setCommentImage()
        setShareImage()
        setWhatsappImage()
        clickPlayer()
        
        optionButton.translatesAutoresizingMaskIntoConstraints = false
        optionButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        optionButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        optionButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        optionButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -25).isActive = true
        optionButton.setImage(UIImage(named: "more_vertical"), for: .normal)
        optionButton.addTarget(self, action: #selector(didTapOptionButton), for: .touchUpInside)

        username.isUserInteractionEnabled = true
        user_image.isUserInteractionEnabled = true
        comment_image.isUserInteractionEnabled = true
        play_click.isUserInteractionEnabled = true
        like_image.isUserInteractionEnabled = true
        whatsapp_share_image.isUserInteractionEnabled = true
        share_image.isUserInteractionEnabled = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToProfile(_:)))
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(goToProfile(_:)))
        username.addGestureRecognizer(tapGesture1)
        user_image.addGestureRecognizer(tapGesture)

        share_image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToSharing(_:))))

        let pauseGesture = UITapGestureRecognizer(target: self, action: #selector(pausePlayer(_:)))
        play_click.addGestureRecognizer(pauseGesture)

        let likeGesture = UITapGestureRecognizer(target: self, action: #selector(tapLike(_:)))
        like_image.addGestureRecognizer(likeGesture)

        let commentGesture = UITapGestureRecognizer(target: self, action: #selector(renderComments(_:)))
        comment_image.addGestureRecognizer(commentGesture)

        let whatsappGesture = UITapGestureRecognizer(target: self, action: #selector(downloadAndShareVideoWhatsapp(_:)))
        whatsapp_share_image.addGestureRecognizer(whatsappGesture)
    }

    @objc func goToProfile(_ sender: UITapGestureRecognizer) {
        delegate?.goToProfile(with: selected_postion)
    }
    @objc func goToSharing(_ sender: UITapGestureRecognizer) {
        delegate?.goToSharing(with: selected_postion)
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
            //play_and_pause_image.image = UIImage(named: "play")
        } else {
            player.player?.play()
            video_image.isHidden = true
            //play_and_pause_image.image = UIImage(named: "pause")
        }
        
        delegate?.didTapPlayer()
    }

    @objc func tapLike(_ sender: UITapGestureRecognizer) {
        like_image.image = like_image.image?.withRenderingMode(.alwaysTemplate)
        if like_image.tintColor == UIColor.red {
            like_image.tintColor = UIColor.white
        } else {
            like_image.tintColor = UIColor.red
        }
        
        if let topic = topic, let intLike = Int(topic.like_count) {
            var like: Int
            if topic.isLiked {
                like = intLike - 1
            } else {
                like = intLike + 1
            }
            
            self.like_count.text = "\(like)"
            topic.like_count = "\(like)"
        }
        
        delegate?.likedTopic(with: selected_postion)
    }
    
    @objc func didTapOptionButton() {
        delegate?.didTapOptions(with: selected_postion)
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
        title.rightAnchor.constraint(equalTo: actions_stack.leftAnchor, constant: -5).isActive = true
        title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true

        title.font = UIFont.systemFont(ofSize: 14.0)
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

        username.font = UIFont.boldSystemFont(ofSize: 15.0)
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
        video_image.heightAnchor.constraint(equalToConstant: sizeFrame.height).isActive = true

        video_image.contentMode = .scaleAspectFill
        video_image.clipsToBounds = true
        video_image.backgroundColor = .black
    }

    func setPlayer() {
        player.translatesAutoresizingMaskIntoConstraints = false

        player.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        player.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        player.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        player.heightAnchor.constraint(equalToConstant: sizeFrame.height).isActive = true
        player.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        player.playerLayer.videoGravity = .resizeAspectFill
    }
    func clickPlayer() {
        play_click.translatesAutoresizingMaskIntoConstraints = false
        play_click.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        play_click.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        play_click.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        play_click.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        play_click.backgroundColor = UIColor.clear
    }


    func setUserImage() {

        user_image.translatesAutoresizingMaskIntoConstraints = false
        user_image.layer.cornerRadius = 20
        user_image.heightAnchor.constraint(equalToConstant: 40).isActive = true
        user_image.widthAnchor.constraint(equalToConstant: 40).isActive = true

        user_image.contentMode = .redraw
        user_image.clipsToBounds = true
       // user_image.m
    }

    func setLikeImage() {

        like_image.translatesAutoresizingMaskIntoConstraints = false
        like_image.heightAnchor.constraint(equalToConstant: 30).isActive = true
        like_image.widthAnchor.constraint(equalToConstant: 30).isActive = true
        like_image.image = UIImage(named: "like")

        like_count.translatesAutoresizingMaskIntoConstraints = false
        like_count.heightAnchor.constraint(equalToConstant: 20).isActive = true
        like_count.textAlignment = .center

        like_count.font = UIFont.systemFont(ofSize: 11.0)
        like_count.lineBreakMode = NSLineBreakMode.byWordWrapping
        like_count.numberOfLines = 1
        like_count.textColor = UIColor.white

        like_count.layer.shadowColor = UIColor.gray.cgColor
        like_count.layer.shadowOpacity = 3
        like_count.layer.shadowOffset = CGSize(width: 4, height: 4)
        like_count.layer.shadowRadius = 10
        like_count.layer.shadowPath = UIBezierPath(rect: like_count.bounds).cgPath
        like_count.layer.shouldRasterize = true

        like_image.layer.shadowColor = UIColor.gray.cgColor
        like_image.layer.shadowOpacity = 5
        like_image.layer.shadowOffset = CGSize(width: 4, height: 4)
        like_image.layer.shadowRadius = 10
        like_image.layer.shadowPath = UIBezierPath(rect: like_image.bounds).cgPath
        like_image.layer.shouldRasterize = true
    }

    func setCommentImage() {

        comment_image.translatesAutoresizingMaskIntoConstraints = false
        comment_image.heightAnchor.constraint(equalToConstant: 30).isActive = true
        comment_image.widthAnchor.constraint(equalToConstant: 30).isActive = true
        comment_image.image = UIImage(named: "comments")

        comment_count.translatesAutoresizingMaskIntoConstraints = false
        comment_count.heightAnchor.constraint(equalToConstant: 20).isActive = true
        comment_count.textAlignment = .center

        comment_count.font = UIFont.systemFont(ofSize: 11.0)
        comment_count.lineBreakMode = NSLineBreakMode.byWordWrapping
        comment_count.numberOfLines = 1
        comment_count.textColor = UIColor.white

        comment_count.layer.shadowColor = UIColor.gray.cgColor
        comment_count.layer.shadowOpacity = 5
        comment_count.layer.shadowOffset = .zero
        comment_count.layer.shadowRadius = 10
        comment_count.layer.shadowPath = UIBezierPath(rect: comment_count.bounds).cgPath
        comment_count.layer.shouldRasterize = true

        comment_image.layer.shadowColor = UIColor.gray.cgColor
        comment_image.layer.shadowOpacity = 5
        comment_image.layer.shadowOffset = .zero
        comment_image.layer.shadowRadius = 10
        comment_image.layer.shadowPath = UIBezierPath(rect: comment_image.bounds).cgPath
        comment_image.layer.shouldRasterize = true
    }

    func setShareImage() {

        share_image.heightAnchor.constraint(equalToConstant: 30).isActive = true
        share_image.widthAnchor.constraint(equalToConstant: 30).isActive = true
        share_image.image = UIImage(named: "share")

        share_count.translatesAutoresizingMaskIntoConstraints = false
        share_count.heightAnchor.constraint(equalToConstant: 20).isActive = true

        share_count.font = UIFont.systemFont(ofSize: 11.0)
        share_count.lineBreakMode = NSLineBreakMode.byWordWrapping
        share_count.textAlignment = .center

        share_count.numberOfLines = 1
        share_count.textColor = UIColor.white

        share_count.layer.shadowColor = UIColor.gray.cgColor
        share_count.layer.shadowOpacity = 5
        share_count.layer.shadowOffset = .zero
        share_count.layer.shadowRadius = 10
        share_count.layer.shadowPath = UIBezierPath(rect: share_count.bounds).cgPath
        share_count.layer.shouldRasterize = true

        share_image.layer.shadowColor = UIColor.gray.cgColor
        share_image.layer.shadowOpacity = 5
        share_image.layer.shadowOffset = .zero
        share_image.layer.shadowRadius = 10
        share_image.layer.shadowPath = UIBezierPath(rect: share_image.bounds).cgPath
        share_image.layer.shouldRasterize = true
    }

    func setWhatsappImage() {

        whatsapp_share_image.heightAnchor.constraint(equalToConstant: 30).isActive = true
        whatsapp_share_image.widthAnchor.constraint(equalToConstant: 30).isActive = true

        whatsapp_share_image.image = UIImage(named: "whatsapp")

        whatsapp_share_count.translatesAutoresizingMaskIntoConstraints = false
        whatsapp_share_count.heightAnchor.constraint(equalToConstant: 20).isActive = true

        whatsapp_share_count.font = UIFont.systemFont(ofSize: 11.0)
        whatsapp_share_count.textAlignment = .center
        whatsapp_share_count.numberOfLines = 1
        whatsapp_share_count.textColor = UIColor.white

        whatsapp_share_count.layer.shadowColor = UIColor.gray.cgColor
        whatsapp_share_count.layer.shadowOpacity = 5
        whatsapp_share_count.layer.shadowOffset = .zero
        whatsapp_share_count.layer.shadowRadius = 10
        whatsapp_share_count.layer.shadowPath = UIBezierPath(rect: whatsapp_share_count.bounds).cgPath
        whatsapp_share_count.layer.shouldRasterize = true

        whatsapp_share_count.layer.shadowColor = UIColor.gray.cgColor
        whatsapp_share_count.layer.shadowOpacity = 5
        whatsapp_share_count.layer.shadowOffset = .zero
        whatsapp_share_count.layer.shadowRadius = 10
        whatsapp_share_count.layer.shadowPath = UIBezierPath(rect: whatsapp_share_count.bounds).cgPath
        whatsapp_share_count.layer.shouldRasterize = true
    }

    func configure(with topic: Topic) {
        self.frame.size.height = sizeFrame.height
        self.frame.size.width = sizeFrame.width
        
        self.topic = topic

        title.text = topic.title.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        let url = URL(string: topic.thumbnailHome)
        video_image.isHidden = false
        video_image.kf.setImage(with: url)
        username.text = "@"+topic.user.username
        //duration.text = ""
        //play_and_pause_image.image = UIImage(named: "play")
        like_count.text = topic.like_count
        comment_count.text = topic.comment_count
        share_count.text = topic.share_count
        whatsapp_share_count.text = topic.whatsapp_share_count

        if (!topic.user.profile_pic.isEmpty) {
            
            let pic_url = URL(string: topic.user.profile_pic)
            
            user_image.kf.setImage(with: pic_url, placeholder: UIImage(named: "user"))
        } else {
            user_image.image = UIImage(named: "user")
        }

        if topic.isLiked {
            like_image.image = like_image.image?.withRenderingMode(.alwaysTemplate)
            like_image.tintColor = UIColor.red
        }

        //        playerSlider.value = 0
        //        playerSlider.minimumValue = 0
        //        playerSlider.maximumValue = 0
    }
}
