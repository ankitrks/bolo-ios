//
//  LoginUserprofile.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 10, 2020

import Foundation
import ObjectMapper

//MARK: - LoginUserprofile
struct LoginUserprofile : Mappable {
    var about : String?
    var androidDid : AnyObject?
    var answerCount : Int?
    var bio : String?
    var boloScore : Int?
    var boostFollowCount : Int?
    var boostLikeCount : Int?
    var boostSpan : Int?
    var boostViewsCount : Int?
    var boostedTime : AnyObject?
    var cityName : AnyObject?
    var commentCount : Int?
    var countryCode : AnyObject?
    var coverPic : String?
    var dOB : AnyObject?
    var encashableBoloScore : Int?
    var followCount : Int?
    var followerCount : Int?
    var gender : String?
    var id : Int?
    var instagarmId : AnyObject?
    var isBusiness : Bool?
    var isDarkModeEnabled : Bool?
    var isExpert : Bool?
    var isGuestUser : Bool?
    var isInsightFix : Bool?
    var isPopular : Bool?
    var isSuperstar : Bool?
    var language : String?
    var likeCount : Int?
    var linkedinUrl : String?
    var mobileNo : String?
    var name : String?
    var ownVbViewCount : String?
    var paytmNumber : AnyObject?
    var profilePic : String?
    var questionCount : Int?
    var refrence : String?
    var salaryRange : AnyObject?
    var shareCount : Int?
    var slug : String?
    var socialIdentifier : String?
    var stateName : AnyObject?
    var subCategory : [Int]?
    var topicCount : Int?
    var totalTimeSpent : Int?
    var totalVbPlaytime : Int?
    var twitterId : AnyObject?
    var user : Int?
    var vbCount : Int?
    var viewCount : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        about <- map["about"]
        androidDid <- map["android_did"]
        answerCount <- map["answer_count"]
        bio <- map["bio"]
        boloScore <- map["bolo_score"]
        boostFollowCount <- map["boost_follow_count"]
        boostLikeCount <- map["boost_like_count"]
        boostSpan <- map["boost_span"]
        boostViewsCount <- map["boost_views_count"]
        boostedTime <- map["boosted_time"]
        cityName <- map["city_name"]
        commentCount <- map["comment_count"]
        countryCode <- map["country_code"]
        coverPic <- map["cover_pic"]
        dOB <- map["d_o_b"]
        encashableBoloScore <- map["encashable_bolo_score"]
        followCount <- map["follow_count"]
        followerCount <- map["follower_count"]
        gender <- map["gender"]
        id <- map["id"]
        instagarmId <- map["instagarm_id"]
        isBusiness <- map["is_business"]
        isDarkModeEnabled <- map["is_dark_mode_enabled"]
        isExpert <- map["is_expert"]
        isGuestUser <- map["is_guest_user"]
        isInsightFix <- map["is_insight_fix"]
        isPopular <- map["is_popular"]
        isSuperstar <- map["is_superstar"]
        language <- map["language"]
        likeCount <- map["like_count"]
        linkedinUrl <- map["linkedin_url"]
        mobileNo <- map["mobile_no"]
        name <- map["name"]
        ownVbViewCount <- map["own_vb_view_count"]
        paytmNumber <- map["paytm_number"]
        profilePic <- map["profile_pic"]
        questionCount <- map["question_count"]
        refrence <- map["refrence"]
        salaryRange <- map["salary_range"]
        shareCount <- map["share_count"]
        slug <- map["slug"]
        socialIdentifier <- map["social_identifier"]
        stateName <- map["state_name"]
        subCategory <- map["sub_category"]
        topicCount <- map["topic_count"]
        totalTimeSpent <- map["total_time_spent"]
        totalVbPlaytime <- map["total_vb_playtime"]
        twitterId <- map["twitter_id"]
        user <- map["user"]
        vbCount <- map["vb_count"]
        viewCount <- map["view_count"]
    }
}
