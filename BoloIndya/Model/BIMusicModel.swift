//
//  BIMusicModel.swift
//  BoloIndya
//
//  Created by Rahul Garg on 13/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation

struct BIMusicModel: Codable {
    let id: Int?
    let title: String?
    let s3FilePath: String?
    let imagePath: String?
//    let languageID: String?
    let authorName: String?
    let languages: [String]?
    let orderNo: Int?
    let lastModified: String?
    let isExtractedAudio, isPinned: Bool?

    enum CodingKeys: String, CodingKey {
        case id, title
        case s3FilePath = "s3_file_path"
        case imagePath = "image_path"
        case authorName = "author_name"
//        case languageID = "language_id"
        case languages
        case orderNo = "order_no"
        case lastModified = "last_modified"
        case isExtractedAudio = "is_extracted_audio"
        case isPinned = "is_pinned"
    }
}
