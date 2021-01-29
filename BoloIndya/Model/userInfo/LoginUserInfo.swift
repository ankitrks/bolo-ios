//
//  LoginUserInfo.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 10, 2020

import Foundation
import ObjectMapper

//MARK: - LoginUserInfo
struct LoginUserInfo : Mappable {
    var access : String?
    var message : String?
    var refreshToken : String?
    var user : LoginUser?
    var username : String?
    var accessToken : String?
    
    init?() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        accessToken  <- map["access_token"]
        access <- map["access"]
        message <- map["message"]
        refreshToken <- map["refresh_token"]
        user <- map["user"]
        username <- map["username"]
        accessToken = accessToken !=  nil ? accessToken : access
    }
    
}

