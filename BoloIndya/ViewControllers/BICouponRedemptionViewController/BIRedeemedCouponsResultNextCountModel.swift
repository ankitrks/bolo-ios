//
//  BIRedeemedCouponsResultNextCountModel.swift
//  BoloIndya
//
//  Created by Rahul Garg on 01/02/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation

struct BIRedeemedCouponsResultNextCountModel: Codable {
    let count: Int?
    var next, previous: String?
    let results: [BIRedeemedCouponResultModel]?
}
