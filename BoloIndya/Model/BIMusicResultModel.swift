//
//  BIMusicResultModel.swift
//  BoloIndya
//
//  Created by Rahul Garg on 13/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation

struct BIMusicResultModel: Codable {
    let id: Int
    let user: BIUserModel?
//    let category: JSONNull?
    let viewCount, commentCount: String
//    let videoComments, audioComments, textComments: [JSONAny]
    let date: String
    let videoCDN: String
    let m3U8Content, audioM3U8Content, videoM3U8Content: String
    let backupURL: String
    let likesCount, whatsappShareCount, otherShareCount, totalShareCount: String
    let music: BIMusicModel?
    let title: String
    let questionAudio: String?
    let questionVideo: String
    let slug, lastActive, languageID: String
    let questionImage: String
    let isMedia: Bool
    let mediaDuration: String
    let isRemoved: Bool
    let thumbnail: String
    let shareCount, impCount, topicLikeCount, topicShareCount: Int
    let isReported: Bool
    let reportCount, vbWidth, vbHeight: Int
    let isThumbnailResized: Bool
    let linkedinShareCount, facebookShareCount, twitterShareCount: Int
    let oldBackupURL: String
    let safeBackupURL: String
    let transcodeJobID: String
    let downloadedURL: String
    let hasDownloadedURL: Bool
    let vbScore: Int
    let isBoosted, popularBoosted: Bool
    let popularBoostedTime: String
    let isViolent: Bool
    let violentContent: Int
    let isAdult: Bool
    let adultContent: Int
    let logoDetected: Bool
    let profanityCollageURL: String?
    let isSticky, isAudioExtracted: Bool
    let firstHashTag, lastModeratedBy, location: String?
    let hashTags: [String]?

    enum CodingKeys: String, CodingKey {
        case id, user
//        case category
        case viewCount = "view_count"
        case commentCount = "comment_count"
//        case videoComments = "video_comments"
//        case audioComments = "audio_comments"
//        case textComments = "text_comments"
        case date
        case videoCDN = "video_cdn"
        case m3U8Content = "m3u8_content"
        case audioM3U8Content = "audio_m3u8_content"
        case videoM3U8Content = "video_m3u8_content"
        case backupURL = "backup_url"
        case likesCount = "likes_count"
        case whatsappShareCount = "whatsapp_share_count"
        case otherShareCount = "other_share_count"
        case totalShareCount = "total_share_count"
        case music, title
        case questionAudio = "question_audio"
        case questionVideo = "question_video"
        case slug
        case lastActive = "last_active"
        case languageID = "language_id"
        case questionImage = "question_image"
        case isMedia = "is_media"
        case mediaDuration = "media_duration"
        case isRemoved = "is_removed"
        case thumbnail
        case shareCount = "share_count"
        case impCount = "imp_count"
        case topicLikeCount = "topic_like_count"
        case topicShareCount = "topic_share_count"
        case isReported = "is_reported"
        case reportCount = "report_count"
        case vbWidth = "vb_width"
        case vbHeight = "vb_height"
        case isThumbnailResized = "is_thumbnail_resized"
        case linkedinShareCount = "linkedin_share_count"
        case facebookShareCount = "facebook_share_count"
        case twitterShareCount = "twitter_share_count"
        case oldBackupURL = "old_backup_url"
        case safeBackupURL = "safe_backup_url"
        case transcodeJobID = "transcode_job_id"
        case downloadedURL = "downloaded_url"
        case hasDownloadedURL = "has_downloaded_url"
        case vbScore = "vb_score"
        case isBoosted = "is_boosted"
        case popularBoosted = "popular_boosted"
        case popularBoostedTime = "popular_boosted_time"
        case isViolent = "is_violent"
        case violentContent = "violent_content"
        case isAdult = "is_adult"
        case adultContent = "adult_content"
        case logoDetected = "logo_detected"
        case profanityCollageURL = "profanity_collage_url"
        case isSticky = "is_sticky"
        case isAudioExtracted = "is_audio_extracted"
        case firstHashTag = "first_hash_tag"
        case lastModeratedBy = "last_moderated_by"
        case location
        case hashTags = "hash_tags"
    }
}
