//
//  Date.swift
//  BoloIndya
//
//  Created by Mushareb on 11/09/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation
extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    func currentTimeMint() -> Int64 {
          return Int64(self.timeIntervalSince1970 * 1000)/1000
      }
}
