//
//  BIOTPTextField.swift
//  BoloIndya
//
//  Created by Rahul Garg on 27/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

protocol BIOTPTextFieldDelegate: class {
    func textFieldDidDelete(_ textField: UITextField)
}

class BIOTPTextField: UITextField {
    
    weak var textFieldDelegate: BIOTPTextFieldDelegate?
    
    override public func deleteBackward() {
        super.deleteBackward()
        
        textFieldDelegate?.textFieldDidDelete(self)
    }
}
