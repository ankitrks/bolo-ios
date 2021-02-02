//
//  BIGaanaOfferViewController.swift
//  BoloIndya
//
//  Created by Rahul Garg on 01/02/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

protocol BIGaanaOfferViewControllerDelegate: class {
    func didTapGaanaOfferCloseButton()
    func didTapGaanaOfferCopyCodeButton(model: BIGaanaOfferModel?)
}

final class BIGaanaOfferViewController: UIViewController {
    @IBOutlet private weak var mainContentView: UIView! {
        didSet {
            mainContentView.layer.borderWidth = 1
            mainContentView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
            mainContentView.layer.cornerRadius = 7
            mainContentView.clipsToBounds = true
        }
    }
    @IBOutlet private weak var offerLabel: UILabel!
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
    
    weak var delegate: BIGaanaOfferViewControllerDelegate?
    var model: BIGaanaOfferModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func config(model: BIGaanaOfferModel) {
        self.model = model
        
        couponLabel.text = model.coupon
    }
    
    @IBAction private func didTapClose(_ sender: UIButton) {
        delegate?.didTapGaanaOfferCloseButton()
    }
    
    @IBAction private func didTapCopyCode(_ sender: UIButton) {
        delegate?.didTapGaanaOfferCopyCodeButton(model: model)
    }
}
