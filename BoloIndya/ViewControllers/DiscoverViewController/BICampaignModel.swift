//
//  BICampaignModel.swift
//  BoloIndya
//
//  Created by Rahul Garg on 06/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation

struct BICampaignModel: Codable {
    let activeFrom, activeTill: String?
    let bannerImgURL: String?
    let details, hashtagName: String?
    let isActive: Bool
    let isWinnerDeclared: Bool
    let popupImgURL: String?
    let showPopupOnApp: Bool
    var winners: [BICampaignWinner]?

    enum CodingKeys: String, CodingKey {
        case activeFrom = "active_from"
        case activeTill = "active_till"
        case bannerImgURL = "banner_img_url"
        case details
        case hashtagName = "hashtag_name"
        case isActive = "is_active"
        case isWinnerDeclared = "is_winner_declared"
        case popupImgURL = "popup_img_url"
        case showPopupOnApp = "show_popup_on_app"
        case winners
    }
}

struct BICampaignWinner: Codable {
    let rank: Int?
    let extraText: String?
    let video: Int?
    let user: BIUserModel?
    
    enum CodingKeys: String, CodingKey {
        case rank
        case extraText = "extra_text"
        case video
        case user
    }
}
