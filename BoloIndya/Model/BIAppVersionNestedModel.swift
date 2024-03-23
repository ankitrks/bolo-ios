//
//  BIAppVersionNestedModel.swift
//  BoloIndya
//
//  Created by Rahul Garg on 21/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation

struct BIAppVersionNestedModel: Codable {
    let id: Int?
    let createdAt, lastModified, appName, appVersion: String?
    let versionToBePushed: String?
    let isHardPush: Bool?
    let changesTitle, changes: String?
    let iosVersionToBePushed: String?
    let isIosHardPush: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case lastModified = "last_modified"
        case appName = "app_name"
        case appVersion = "app_version"
        case versionToBePushed = "version_to_be_pushed"
        case isHardPush = "is_hard_push"
        case changesTitle = "changes_title"
        case changes
        case iosVersionToBePushed = "ios_version_to_be_pushed"
        case isIosHardPush = "is_ios_hard_push"
    }
}
