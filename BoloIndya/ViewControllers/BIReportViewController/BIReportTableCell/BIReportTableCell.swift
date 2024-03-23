//
//  BIReportTableCell.swift
//  BoloIndya
//
//  Created by Rahul Garg on 29/12/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

final class BIReportTableCell: UITableViewCell {
    @IBOutlet weak var selectedButton: UIButton! {
        didSet {
            selectedButton.setImage(UIImage(named: "radio"), for: .normal)
            selectedButton.setImage(UIImage(named: "radio_fill"), for: .selected)
            selectedButton.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    
    var model: BIReportResult? {
        didSet {
            guard let model = model else { return }
            
            titleLabel.text = model.text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}
