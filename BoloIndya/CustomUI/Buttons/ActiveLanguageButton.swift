//
//  ActiveLanguageButton.swift
//  BoloIndya
//
//  Created by apple on 7/11/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//


import UIKit

class ActiveLanguageButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpButton()
    }
    
    func setUpButton() {
        layer.cornerRadius = 10.0
        layer.backgroundColor = #colorLiteral(red: 0.7098039216, green: 0.1568627451, blue: 0.1568627451, alpha: 0.8470588235)
        setTitleColor(.white, for: .normal)
    }
}
