//
//  BIBannerRulesViewController.swift
//  BoloIndya
//
//  Created by Rahul Garg on 06/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

final class BIBannerRulesViewController: UIViewController {
    @IBOutlet private weak var textView: UITextView!
    
    var banner: BICampaignModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.attributedText = banner?.details?.htmlToAttributedString(font: textView.font)
    }
}
