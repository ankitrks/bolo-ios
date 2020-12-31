//
//  BICommentView.swift
//  BoloIndya
//
//  Created by Rahul Garg on 21/12/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Alamofire

enum BICommentViewType {
    case trendingView
    case videoView
}

protocol BICommentViewDelegate: class {
    func didTapCloseButton()
    func didTapSendButton(comment: String?, topic: Topic?)
    func didTapLikeComment(isLike: Bool, comment: Comment, topic: Topic?)
}

final class BICommentView: UIView {
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet weak var commentTable: UITableView! {
        didSet {
            commentTable.showsVerticalScrollIndicator = false
            commentTable.tableFooterView = UIView()
            commentTable.register(cellType: BICommentTableCell.self)
            commentTable.register(cellType: BICommentLoadingCell.self)
            
            commentTable.delegate = self
            commentTable.dataSource = self
        }
    }
    @IBOutlet private weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.cornerRadius = userImageView.bounds.width/2
            userImageView.clipsToBounds = true
            
            if let image = UserDefaults.standard.getProfilePic() , let url = URL(string: image) {
                userImageView.kf.setImage(with: url, placeholder: UIImage(named: "user"))
            } else {
                userImageView.image = UIImage(named: "user")
            }
            
        }
    }
    @IBOutlet private weak var commentTextfield: UITextField! {
        didSet {
            commentTextfield.attributedPlaceholder = NSAttributedString(string: "Add a comment..",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            
            if #available(iOS 11.0, *) {
                commentTextfield.textContentType = .username
            } else {
                // Fallback on earlier versions
            }
            commentTextfield.delegate = self
        }
    }
    @IBOutlet private weak var sendButton: UIButton!
    
    private weak var delegate: BICommentViewDelegate?
    private weak var viewController: UIViewController?
    private var topic: Topic?
    private var originalFrame: CGRect?
    private var type: BICommentViewType = .trendingView
    
    private var isLoading = false
    private var page = 0
    private var isMoreData = true
    var comments: [Comment] = []
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addKeyboardObservers(to: .default)
    }
    
    func config(topic: Topic, originalFrame: CGRect, viewController: UIViewController, delegate: BICommentViewDelegate, type: BICommentViewType) {
        self.frame = originalFrame
        
        self.topic = topic
        self.originalFrame = originalFrame
        self.viewController = viewController
        self.delegate = delegate
        self.type = type
        
        fetchComment()
    }
    
    //MARK: Helpers
    private func fetchComment() {
        guard let topic = topic else { return }
        
        isLoading = true
        
        var headers: [String: Any]? = nil
        if let token = UserDefaults.standard.getAuthToken(), !token.isEmpty {
            headers = ["Authorization": "Bearer \(token)"]
        }
        
        let url = "https://www.boloindya.com/api/v1/topics/ddwd/\(topic.id)/comments/?limit=15&offset=\(page*15)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers as? HTTPHeaders)
            .responseString { [weak self] (responseData) in
                
                switch responseData.result {
                case.success(let data):
                    guard let json_data = data.data(using: .utf8) else { break }
                    
                    do {
                        let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                        if let content = json_object?["results"] as? [[String:Any]] {
                            
                            let commentLike = UserDefaults.standard.getLikeComment()
                            
                            for each in content {
                                let comment = getComment(each: each)
                                
                                if let idInt = Int(comment.id), commentLike.contains(idInt) {
                                    comment.isLiked = true
                                } else {
                                    comment.isLiked = false
                                }
                                
                                self?.comments.append(comment)
                            }
                            
                            if self?.page == 0 {
                                if self?.comments.isEmpty == true {
                                    self?.commentTable.setMessage("No Comments. Be the first one to comment.")
                                } else {
                                    self?.commentTable.removeMessage()
                                }
                            }
                            
                            if content.isEmpty {
                                self?.isMoreData = false
                            } else {
                                self?.isMoreData = true
                                self?.page += 1
                            }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                case.failure(let error):
                    print(error)
                }
                
                self?.isLoading = false
                DispatchQueue.main.async {
                    self?.commentTable.reloadData()
                }
        }
    }
    
    //MARK: IBAction
    @IBAction private func didTapCloseButton(_ sender: UIButton) {
        delegate?.didTapCloseButton()
    }
    
    @IBAction private func didTapSendButton(_ sender: UIButton) {
        guard commentTextfield.text?.isEmpty == false else { return }
        
        delegate?.didTapSendButton(comment: commentTextfield.text, topic: topic)
        
        commentTextfield.resignFirstResponder()
        commentTextfield.text = nil
    }
}

//MARK:- UITableViewDelegate, UITableViewDataSource
extension BICommentView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isMoreData {
            return comments.count + 1
        }
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if comments.count == indexPath.row,
            isMoreData,
            isLoading {
            return 40
        }

        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if comments.count == indexPath.row,
            isMoreData,
            isLoading {
            return 40
        }

        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isLoading, indexPath.row+5 > comments.count, isMoreData {
            fetchComment()
        }
        
        if comments.count == indexPath.row,
            isMoreData,
            isLoading {
            let cell = tableView.dequeueReusableCell(with: BICommentLoadingCell.self, for: indexPath)
            cell.activityIndicator.startAnimating()
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(with: BICommentTableCell.self, for: indexPath)
        if comments.count > indexPath.row {
            cell.comment = comments[indexPath.row]
        }
        cell.delegate = self
        return cell
    }
}

//MARK:- UITextFieldDelegate
extension BICommentView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK:- BICommentTableCellDelegate
extension BICommentView: BICommentTableCellDelegate {
    func didTapLikeComment(comment: Comment) {
        delegate?.didTapLikeComment(isLike: comment.isLiked, comment: comment, topic: topic)
    }
}

//MARK:- KeyboardHandler
extension BICommentView: KeyboardHandler {
    func keyboardWillShow(withSize size: CGSize) {
        if frame.origin.y == originalFrame?.origin.y {
            var offset: CGFloat
            if type == .trendingView {
                offset = viewController?.tabBarController?.tabBar.bounds.height ?? 0
            } else {
                offset = 0
            }
            frame.origin.y -= size.height - offset
        }
    }
    
    func keyboardWillHide() {
        frame.origin.y = originalFrame?.origin.y ?? 0
    }
}
