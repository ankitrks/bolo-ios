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
            sNoLabel.text = winner?.rank
            nameLabel.text = winner?.extraText
            linkButton.setTitle(winner?.video, for: .normal)
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
