//
//  BIResultUserProfileModel.swift
//  BoloIndya
//
//  Created by Rahul Garg on 28/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation

struct BIResultUserProfileModel: Codable {
    let userprofile: Userprofile?

    enum CodingKeys: String, CodingKey {
        case userprofile
    }
}
