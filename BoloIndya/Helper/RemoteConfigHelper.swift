//
//  RemoteConfigHelper.swift
//  BoloIndya
//
//  Created by Rahul Garg on 27/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig

final class RemoteConfigHelper {
    private struct Keys {
        static let gaanaSignup = "gaana_signup"
    }
    
    
    static let shared = RemoteConfigHelper()
    
    private init() {
        setupRemoteConfigDefaults()
        fetchRemoteConfig()
    }
    
    
    var remoteConfig: RemoteConfig = {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 3600
        remoteConfig.configSettings = settings
        return remoteConfig
    }()
    
    
    private func setupRemoteConfigDefaults() {
        let defaultValue = [
            Keys.gaanaSignup: false as NSObject
        ]
        remoteConfig.setDefaults(defaultValue)
    }
    
    private func fetchRemoteConfig() {
        remoteConfig.fetch() { [weak self] (status, error) in
            if status == .success {
                print("Firebase Remote Config fetched")
                
                self?.remoteConfig.activate() { (changed, error) in
                    if let error = error {
                        print("Firebase Remote Config not activated with Error: \(error)")
                    } else {
                        print("Firebase Remote Config Activated")
                    }
                }
            } else {
                print("Firebase Remote Config not fetched with Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
    
    func isShowGaanaSignup() -> Bool {
        return remoteConfig.configValue(forKey: Keys.gaanaSignup).boolValue
    }
}
