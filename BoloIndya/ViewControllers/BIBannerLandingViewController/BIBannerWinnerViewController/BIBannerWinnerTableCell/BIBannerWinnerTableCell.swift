//
//  BIBannerWinnerTableCell.swift
//  BoloIndya
//
//  Created by Rahul Garg on 06/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

protocol BIBannerWinnerTableCellDelegate: class {
    func didTapVideo(winner: BICampaignWinner?)
}

final class BIBannerWinnerTableCell: UITableViewCell {
    @IBOutlet private weak var sNoLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var linkButton: UIButton!
    
    var winner: BICampaignWinner? {
        didSet {
            if let rank = winner?.rank {
                sNoLabel.text = "\(rank)"
            } else {
                sNoLabel.text = ""
            }
            nameLabel.text = winner?.user?.userprofile.name
            linkButton.setTitle("Click Here", for: .normal)
        }
    }
    weak var delegate: BIBannerWinnerTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    @IBAction private func didTapLinkButton(_ sender: UIButton) {
        delegate?.didTapVideo(winner: winner)
    }
}
