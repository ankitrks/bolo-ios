//
//  BISignupViewController.swift
//  BoloIndya
//
//  Created by Rahul Garg on 28/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

protocol BISignupViewControllerDelegate: class {
    func didTapSignupVCNext()
    func didTapSignupVCBack()
}

final class BISignupViewController: UIViewController {
    @IBOutlet private weak var gaanaLabel: UILabel!
    
    weak var delegate: BISignupViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if RemoteConfigHelper.shared.isShowGaanaSignup() {
            gaanaLabel.isHidden = false
            
            let attributedText = NSMutableAttributedString(string: "Signup and win free ")
            
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(named: "gaana_text")
            imageAttachment.bounds = CGRect(x: 0, y: -5, width: 102, height: 24)
            let imageString = NSAttributedString(attachment: imageAttachment)
            attributedText.append(imageString)
            
            let attributedText2 = NSAttributedString(string: " subscription")
            attributedText.append(attributedText2)
            
            gaanaLabel.attributedText = attributedText
        } else {
            gaanaLabel.isHidden = true
        }
    }
    
    @IBAction func didTapNext(_ sender: UIButton) {
        delegate?.didTapSignupVCNext()
    }
    
    @IBAction func didTapBack(_ sender: UIButton) {
        delegate?.didTapSignupVCBack()
    }
}
