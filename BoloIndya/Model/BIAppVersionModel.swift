//
//  BIAppVersionModel.swift
//  BoloIndya
//
//  Created by Rahul Garg on 21/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation

struct BIAppVersionModel: Codable {
    let appVersion: BIAppVersionNestedModel?

    enum CodingKeys: String, CodingKey {
        case appVersion = "app_version"
    }
}
