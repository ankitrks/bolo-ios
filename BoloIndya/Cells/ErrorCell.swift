//
//  ErrorCell.swift
//  BoloIndya
//
//  Created by Mushareb on 11/09/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

protocol ErrorCellDelegate {
    func onRelaod()
}
class ErrorCell: UITableViewCell {
    var delegate:ErrorCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func onRelaod(_ sender: Any) {
        delegate?.onRelaod()

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
