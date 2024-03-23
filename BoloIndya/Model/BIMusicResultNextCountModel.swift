//
//  BIMusicResultNextCountModel.swift
//  BoloIndya
//
//  Created by Rahul Garg on 13/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation

struct BIMusicResultNextCountModel: Codable {
    let count: Int?
    let next, previous: String?
    let results: [BIMusicResultModel]?
}
