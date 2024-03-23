//
//  UITableViewCell+Extension.swift
//  BoloIndya
//
//  Created by Rahul Garg on 09/12/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

extension UITableViewCell {
    var tableView: UITableView? {
        return parentView(of: UITableView.self)
    }
}
