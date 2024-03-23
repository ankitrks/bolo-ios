//
//  BISignupModel.swift
//  BoloIndya
//
//  Created by Rahul Garg on 27/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation

enum BIGender: Int {
    case male = 1
    case female = 2
    case others = 3
}

final class BISignupModel {
    var phone: String?
    var otp: String?
    var name: String?
    var gender: BIGender?
    var dob: Date?
    var type: BISignupDetailsType?
    
    var enteredName: String?
    var enteredGender: BIGender?
    var enteredDob: Date?
}
