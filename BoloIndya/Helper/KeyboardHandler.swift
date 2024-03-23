//
//  KeyboardHandler.swift
//  BoloIndya
//
//  Created by Rahul Garg on 21/12/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

protocol KeyboardHandler: class {
    func keyboardWillShow(withSize size: CGSize)
    func keyboardWillHide()
}

extension KeyboardHandler {
    
    func addKeyboardObservers(to notificationCenter: NotificationCenter = .default) {
        notificationCenter.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil,
            using: { [weak self] notification in
                let key = UIResponder.keyboardFrameEndUserInfoKey
                guard let keyboardSizeValue = notification.userInfo?[key] as? NSValue else {
                    return;
                }
                
                let keyboardSize = keyboardSizeValue.cgRectValue
                self?.keyboardWillShow(withSize: keyboardSize.size)
        })
        notificationCenter.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil,
            using: { [weak self] _ in
                self?.keyboardWillHide()
        })
    }
    
    func removeKeyboardObservers(from notificationCenter: NotificationCenter) {
        notificationCenter.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        notificationCenter.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
    }
}

