//
//  BIUserModel.swift
//  BoloIndya
//
//  Created by Rahul Garg on 12/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation

struct BIUserModel: Codable {
    let email, firstName: String?
    let id: Int?
    let isActive: Bool?
    let lastName, username: String?
    let userprofile: Userprofile?

    enum CodingKeys: String, CodingKey {
        case email
        case firstName = "first_name"
        case id
        case isActive = "is_active"
        case lastName = "last_name"
        case username, userprofile
    }
}
