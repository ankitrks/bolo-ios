//
//  BIRedeemedCouponResultModel.swift
//  BoloIndya
//
//  Created by Rahul Garg on 01/02/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation

struct BIRedeemedCouponResultModel: Codable {
    let brandLogo: String?
    let brandPartner: Int?
    let id: Int?
    let user: Int?
    let voucher: BIRedeemedCouponVoucherModel?
    
    enum CodingKeys: String, CodingKey {
        case brandLogo = "brand_logo"
        case brandPartner = "brand_partner"
        case id
        case user
        case voucher
    }
}

struct BIRedeemedCouponVoucherModel: Codable {
    let validity: String?
    let voucher: String?
}
