//
//  CrashlyticsHelper.swift
//  BoloIndya
//
//  Created by Rahul Garg on 27/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation
import FirebaseCrashlytics

final class CrashlyticsHelper {
    func setUserId(id: String) {
        Crashlytics.crashlytics().setUserID(id)
    }
    
    func setUserName(name: String? = nil) {
        var name2: String
        if let name = name {
            name2 = name
        } else if let name = UserDefaults.standard.getName() {
            name2 = name
        } else {
            return
        }
        
        Crashlytics.crashlytics().setCustomValue(name2, forKey: "name")
    }
}
