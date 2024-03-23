//
//  CommentViewCell.swift
//  BoloIndya
//
//  Created by apple on 7/24/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

protocol CommentViewCellDelegate {
    func likedComment(with selected_postion: Int)
}

class CommentViewCell: UITableViewCell {
    
    var profile_pic = UIImageView()
    
    var comment_title = UILabel()
    var created_at = UILabel()
    var likes = UILabel()
    var heart = UIImageView()
    
    var delegate: CommentViewCellDelegate?
    
    var selected_postion: Int = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with comment: Comment) {
        comment_title.text = comment.user.username + ": " + comment.title.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        created_at.text = comment.date
        likes.text = comment.likes + " likes"
        
        if (!comment.user.profile_pic.isEmpty) {
            let pic_url = URL(string: comment.user.profile_pic)
            profile_pic.kf.setImage(with: pic_url, placeholder: UIImage(named: "user"))
        } else {
            profile_pic.image = UIImage(named: "user")
        }
        heart.image = UIImage(named: "heart_non_filled")
        if comment.isLiked {
            heart.image = UIImage(named: "like")
            heart.image = heart.image?.withRenderingMode(.alwaysTemplate)
            heart.tintColor = UIColor.red
        }
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        addSubview(profile_pic)
        addSubview(comment_title)
        addSubview(created_at)
        addSubview(likes)
        addSubview(heart)
        
        backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.8470588235)
        
        setCommentData()
        
        
        heart.isUserInteractionEnabled = true
        let heartGesture = UITapGestureRecognizer(target: self, action: #selector(tapLike(_:)))
        heart.addGestureRecognizer(heartGesture)
    }
    
    @objc func tapLike(_ sender: UITapGestureRecognizer) {
        heart.image = heart.image?.withRenderingMode(.alwaysTemplate)
        if heart.tintColor == UIColor.red {
            heart.image = UIImage(named: "heart_non_filled")
        } else {
            heart.image = UIImage(named: "like")
            heart.image = heart.image?.withRenderingMode(.alwaysTemplate)
            heart.tintColor = UIColor.red
        }
        delegate?.likedComment(with: selected_postion)
    }
    
    func setCommentData() {
        
        profile_pic.translatesAutoresizingMaskIntoConstraints = false
        profile_pic.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profile_pic.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profile_pic.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        profile_pic.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        profile_pic.layer.cornerRadius = 25
        profile_pic.contentMode = .scaleAspectFill
        profile_pic.clipsToBounds = true
        
        heart.translatesAutoresizingMaskIntoConstraints = false
        heart.heightAnchor.constraint(equalToConstant: 30).isActive = true
        heart.widthAnchor.constraint(equalToConstant: 30).isActive = true
        heart.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        heart.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        heart.contentMode = .scaleAspectFill
        heart.clipsToBounds = true
        
        
        comment_title.translatesAutoresizingMaskIntoConstraints = false
        comment_title.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        comment_title.leftAnchor.constraint(equalTo: profile_pic.rightAnchor, constant: 5).isActive = true
        comment_title.rightAnchor.constraint(equalTo: heart.leftAnchor, constant: -10).isActive = true
        comment_title.numberOfLines = 2
        comment_title.textColor = .white
        
        comment_title.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        created_at.translatesAutoresizingMaskIntoConstraints = false
        created_at.topAnchor.constraint(equalTo: comment_title.bottomAnchor, constant: 10).isActive = true
        created_at.widthAnchor.constraint(equalToConstant: 125).isActive = true
        created_at.leftAnchor.constraint(equalTo: profile_pic.rightAnchor, constant: 5).isActive = true
        created_at.numberOfLines = 1
        created_at.textColor = .white
        
        created_at.font = UIFont.boldSystemFont(ofSize: 10.0)
        
        likes.translatesAutoresizingMaskIntoConstraints = false
        likes.topAnchor.constraint(equalTo: comment_title.bottomAnchor, constant: 10).isActive = true
        likes.widthAnchor.constraint(equalToConstant: 125).isActive = true
        likes.leftAnchor.constraint(equalTo: created_at.rightAnchor, constant: 5).isActive = true
        likes.numberOfLines = 1
        likes.textColor = .white
        
        likes.font = UIFont.boldSystemFont(ofSize: 10.0)
    }
}
