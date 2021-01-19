//
//  BIUserProfileModel.swift
//  BoloIndya
//
//  Created by Rahul Garg on 12/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation

struct Userprofile: Codable {
    let about, androidDid, bio: String?
//    let boloScore, boloScoreNew: String?
    let countryCode, coverPic: String?
    let id: Int?
//    let followCount: Int?
//    let followerCount: String?
    let isBusiness, isEventCreator, isExpert, isGuestUser: Bool?
    let isPopular, isSuperstar: Bool?
    let name: String?
    let ownVBViewCount: String?
    let profilePic, slug: String?
    let viewCount: String?
    let vbCount: Int?
    let user: Int?
//    let subCategory: [JSONAny]

    enum CodingKeys: String, CodingKey {
        case about
        case androidDid = "android_did"
        case bio
//        case boloScore = "bolo_score"
//        case boloScoreNew = "bolo_score_new"
        case countryCode = "country_code"
        case coverPic = "cover_pic"
//        case followCount = "follow_count"
//        case followerCount = "follower_count"
        case id
        case isBusiness = "is_business"
        case isEventCreator = "is_event_creator"
        case isExpert = "is_expert"
        case isGuestUser = "is_guest_user"
        case isPopular = "is_popular"
        case isSuperstar = "is_superstar"
        case name
        case ownVBViewCount = "own_vb_view_count"
        case profilePic = "profile_pic"
        case slug, user
        case vbCount = "vb_count"
        case viewCount = "view_count"
//        case subCategory = "sub_category"
    }
}
