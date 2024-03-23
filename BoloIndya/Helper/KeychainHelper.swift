//
//  KeychainHelper.swift
//  BoloIndya
//
//  Created by Rahul Garg on 24/12/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation
import KeychainAccess

final class KeychainHelper {
    
    private struct KeychainHelperKeys {
        static let service = "com.boloindya.ios"
        static let uuid = "uuid"
    }
    
    
    static func setDeviceId() {
        guard let uuid = UIDevice.current.identifierForVendor?.uuidString else { return }
        
        let keychain = Keychain(service: KeychainHelperKeys.service)
            .synchronizable(true)
        keychain[KeychainHelperKeys.uuid] = uuid
    }
    
    static func getDeviceId() -> String? {
        let keychain = Keychain(service: KeychainHelperKeys.service)
        return try? keychain.getString(KeychainHelperKeys.uuid)
    }
}
