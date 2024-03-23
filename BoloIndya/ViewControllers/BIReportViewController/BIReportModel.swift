//
//  BIReportModel.swift
//  BoloIndya
//
//  Created by Rahul Garg on 29/12/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation

struct BIReportModel: Codable {
    let count: Int
    let results: [BIReportResult]
}

struct BIReportResult: Codable {
    let id: Int
    let text: String
    let isActive: Bool
    let target: String

    enum CodingKeys: String, CodingKey {
        case id, text
        case isActive = "is_active"
        case target
    }
}
