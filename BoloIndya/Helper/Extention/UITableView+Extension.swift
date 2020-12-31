//
//  UITableView+Extension.swift
//  BoloIndya
//
//  Created by Rahul Garg on 21/12/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(cellType: T.Type) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forCellReuseIdentifier: className)
    }
    
    func register<T: UITableViewCell>(cellTypes: [T.Type]) {
        cellTypes.forEach { register(cellType: $0) }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
        return cell
    }
    
    func setMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 15,
                                                 y: 0,
                                                 width: bounds.size.width - 30,
                                                 height: bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        messageLabel.sizeToFit()
        
        backgroundView = messageLabel
    }
    
    func removeMessage() {
        backgroundView = nil
    }
}
