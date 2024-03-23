//
//  BranchHelper.swift
//  BoloIndya
//
//  Created by Rahul Garg on 27/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation
import Branch

final class BranchHelper {
    func initBranch(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        Branch.setUseTestBranchKey(false) // make it false for live
        Branch.getInstance().enableLogging()
        
        print("Branch Initialisation")
        
        Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
            if let params = params {
                print("Branch Session Initialised with params: \(params)")
            } else if let error = error {
                print("Branch Session not Initialised with Error: \(error)")
            }
        }
    }
    
    func setId(userId: String? = nil) {
        var id: String?
        
        if let userId = userId {
            id = userId
        } else if let userId = UserDefaults.standard.getUserId2() {
            id = "\(userId)"
        }
        
        if let id = id {
            Branch.getInstance().setIdentity(id)
        }
    }
    
    func logout() {
        Branch.getInstance().logout()
    }
}
