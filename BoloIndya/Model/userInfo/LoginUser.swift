//
//  LoginUser.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 10, 2020

import Foundation
import ObjectMapper

//MARK: - LoginUser
 struct LoginUser : Mappable {

         var email : String?
         var firstName : String?
         var id : Int?
         var isActive : Bool?
         var lastName : String?
         var username : String?
         var userprofile : LoginUserprofile?
        
        	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		email <- map["email"]
		firstName <- map["first_name"]
		id <- map["id"]
		isActive <- map["is_active"]
		lastName <- map["last_name"]
		username <- map["username"]
		userprofile <- map["userprofile"]
	}
        
}

