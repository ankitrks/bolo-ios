//
//  UIViewController.swift
//  BoloIndya
//
//  Created by Mushareb on 30/08/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//
import UIKit
extension UIViewController {

    func showToast(message : String) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: (self.view.frame.size.height - 200), width: 200, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor(hex: "10A5F9")
    toastLabel.font = UIFont.systemFont(ofSize: 20.0)
    toastLabel.textAlignment = .center
        toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
} }
