//
//  WebEngageHelper.swift
//  BoloIndya
//
//  Created by Rahul Garg on 16/12/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation
import WebEngage

final class WebEngageHelper {
    static func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        WebEngage.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    static func setUserAttributes() {
        let weUser: WEGUser = WebEngage.sharedInstance().user
        
        if let id = UserDefaults.standard.getUserId(), !"\(id)".isEmpty, id != 41 {
            weUser.login("\(id)")
            weUser.setAttribute("id", withValue: id as NSNumber)
        }
        
        if let name = UserDefaults.standard.getName(), !name.isEmpty {
            let names = name.components(separatedBy: " ")
            if let firstName = names.first {
                weUser.setFirstName(firstName)
                weUser.setAttribute("First Name", withStringValue: firstName)
            }
            if names.count > 1 {
                weUser.setLastName(names[1])
                weUser.setAttribute("Last Name", withStringValue: names[1])
            }
            weUser.setAttribute("name", withStringValue: name)
        }
        
        if let username = UserDefaults.standard.getUsername(), !username.isEmpty {
            weUser.setAttribute("username", withStringValue: username)
            weUser.setPhone(username)
        }
    }
    
    static func setLanguageAttribute(id: Int? = nil, name: String? = nil) {
        var languageId: Int?
        if let id = id {
            languageId = id
        } else if let id = UserDefaults.standard.getValueForLanguageId() {
            languageId = id
        }
        
        var languageName: String?
        if let name = name {
            languageName = name
        }
        
        let weUser: WEGUser = WebEngage.sharedInstance().user
        
        if let languageId = languageId {
            weUser.setAttribute("language_id", withValue: languageId as NSNumber)
        }
        
        if let languageName = languageName {
            weUser.setAttribute("language", withStringValue: languageName)
        }
    }
    
    static func trackEvent(eventName: String, values: [String: Any]? = nil) {
        WebEngage.sharedInstance().analytics.trackEvent(withName: eventName, andValue: values)
    }
}
