//
//  BoloIndya.swift
//  BoloIndya
//
//  Created by apple on 8/8/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation
import UIKit

class BoloIndya {
    
}

func getStatusBarHeight() -> CGFloat {
    var statusBarHeight: CGFloat = 25
    if #available(iOS 13.0, *) {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 25
    } else {
        statusBarHeight = UIApplication.shared.statusBarFrame.height
    }
    return statusBarHeight
}
