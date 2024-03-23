//
//  BICamapignStatusMessageModel.swift
//  BoloIndya
//
//  Created by Rahul Garg on 06/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation

struct BICamapignStatusMessageModel: Codable {
    let status: String
    let message: [BICampaignModel]
}
