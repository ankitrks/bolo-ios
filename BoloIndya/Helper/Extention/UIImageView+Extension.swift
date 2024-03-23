//
//  UIImageView+Extension.swift
//  BoloIndya
//
//  Created by Mushareb on 30/08/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {

    func makeRounded() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
