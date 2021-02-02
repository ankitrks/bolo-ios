//
//  BICouponRedemptionTableCell.swift
//  BoloIndya
//
//  Created by Rahul Garg on 01/02/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

protocol BICouponRedemptionTableCellDelegate: class {
    func didTapCopyCouponCode(model: BIRedeemedCouponResultModel?)
}

final class BICouponRedemptionTableCell: UITableViewCell {
    @IBOutlet private weak var mainContentView: UIView! {
        didSet {
            mainContentView.layer.borderWidth = 1
            mainContentView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
            mainContentView.layer.cornerRadius = 7
            mainContentView.clipsToBounds = true
        }
    }
    @IBOutlet private weak var offerImageView: UIImageView!
    
    @IBOutlet private weak var timeLabel: UILabel!
    
    @IBOutlet private weak var couponView: UIView! {
        didSet {
            couponView.layer.borderWidth = 0.5
            couponView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
            couponView.layer.cornerRadius = 3
            couponView.clipsToBounds = true
        }
    }
    @IBOutlet private weak var couponLabel: UILabel!
    @IBOutlet private weak var copyButton: BIGradientButton! {
        didSet {
            copyButton.layer.cornerRadius = 3
            copyButton.clipsToBounds = true
        }
    }
    
    var model: BIRedeemedCouponResultModel? {
        didSet {
            couponLabel.text = model?.voucher?.voucher
            timeLabel.text = model?.voucher?.validity
            
            if let urlString = model?.brandLogo, let url = URL(string: urlString) {
                offerImageView.kf.setImage(with: url, placeholder: UIImage(named: "boloindya_logo"))
            } else {
                offerImageView.image = UIImage(named: "boloindya_logo")
            }
        }
    }
    weak var delegate: BICouponRedemptionTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    @IBAction private func didTapCopyCode(_ sender: UIButton) {
        delegate?.didTapCopyCouponCode(model: model)
    }
}
