//
//  BIMusicTrackModel.swift
//  BoloIndya
//
//  Created by Rahul Garg on 15/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation

struct BIMusicTrackModel: Codable {
    let authorName: String
    let id: Int
    let imagePath: String?
    let isExtractedAudio: Bool
//    let languageID: Int?
//    let languages: [Int]?
//    let lastModified: String
//    let orderNo: Int
    let s3FilePath: String
    let title: String

    enum CodingKeys: String, CodingKey {
        case authorName = "author_name"
        case id
        case imagePath = "image_path"
        case isExtractedAudio = "is_extracted_audio"
//        case languageID = "language_id"
//        case languages
//        case lastModified = "last_modified"
//        case orderNo = "order_no"
        case s3FilePath = "s3_file_path"
        case title
    }
}
