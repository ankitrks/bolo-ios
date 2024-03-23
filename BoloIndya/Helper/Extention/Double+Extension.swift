//
//  Double+Extension.swift
//  BoloIndya
//
//  Created by Rahul Garg on 18/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation

extension Double {
    func rounded(digits: Int) -> Double {
        let multiplier = pow(10.0, Double(digits))
        return (self * multiplier).rounded() / multiplier
    }
    
    func removeZerosFromEnd() -> String {
        return String(format: "%g", self)
    }
}
