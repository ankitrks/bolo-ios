//
//  BICommentTableCell.swift
//  BoloIndya
//
//  Created by Rahul Garg on 21/12/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

protocol BICommentTableCellDelegate: class {
    func didTapLikeComment(comment: Comment)
}

final class BICommentTableCell: UITableViewCell {
    @IBOutlet private weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.cornerRadius = userImageView.bounds.width/2
            userImageView.clipsToBounds = true
        }
    }
    @IBOutlet private weak var commentLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var likeLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    
    weak var delegate: BICommentTableCellDelegate?
    
    var comment: Comment? {
        didSet {
            guard let comment = comment else { return }
            
            commentLabel.text = comment.user.username + ": " + comment.title.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            timeLabel.text = comment.date
            
            let likes = comment.likes
            if likes == "0" || likes.isEmpty {
                likeLabel.text = ""
            } else if likes == "1" {
                likeLabel.text = likes + " like"
            } else {
                likeLabel.text = likes + " likes"
            }
            
            if !comment.user.profile_pic.isEmpty {
                let pic_url = URL(string: comment.user.profile_pic)
                userImageView.kf.setImage(with: pic_url, placeholder: UIImage(named: "user"))
            } else {
                userImageView.image = UIImage(named: "user")
            }
            
            if comment.isLiked {
                likeButton.setImage(UIImage(named: "like")?.withRenderingMode(.alwaysTemplate), for: .normal)
                likeButton.tintColor = UIColor.red
            } else {
                likeButton.setImage(UIImage(named: "heart_non_filled"), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    @IBAction private func didTapLikeButton(_ sender: UIButton) {
        guard let comment = comment else { return }
        
        if comment.isLiked {
            comment.isLiked = false
            
            if let likeCount = Int(comment.likes), likeCount > 0 {
                comment.likes = "\(likeCount - 1)"
            }
        } else {
            comment.isLiked = true
            
            if let likeCount = Int(comment.likes) {
                comment.likes = "\(likeCount + 1)"
            }
        }
        
        let likes = comment.likes
        if likes == "0" || likes.isEmpty {
            likeLabel.text = ""
        } else if likes == "1" {
            likeLabel.text = likes + " like"
        } else {
            likeLabel.text = likes + " likes"
        }
        
        if comment.isLiked {
            likeButton.setImage(UIImage(named: "like")?.withRenderingMode(.alwaysTemplate), for: .normal)
            likeButton.tintColor = UIColor.red
        } else {
            likeButton.setImage(UIImage(named: "heart_non_filled"), for: .normal)
        }
        
        delegate?.didTapLikeComment(comment: comment)
    }
}
