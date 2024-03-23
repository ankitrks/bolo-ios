//
//  BIUtility.swift
//  BoloIndya
//
//  Created by Rahul Garg on 21/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation
import Alamofire

final class BIUtility {
    static func getAppStoreInfoDict(completion: @escaping ((_ result: NSDictionary?) -> Void)) {
        let url = "https://itunes.apple.com/lookup?bundleId=com.boloindya.ios"
        
        AF.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseString  { (responseData) in
                
                switch responseData.result {
                case.success(let data):
                    guard let json_data = data.data(using: .utf8) else { break }
                    
                    do {
                        let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                        completion(json_object as NSDictionary?)
                        return
                    } catch {
                        print(error)
                    }
                    
                case.failure(let error):
                    print(error)
                }
                
                completion(nil)
        }
    }
    
    static func isAppUpdateAvailableFrom(_ dict: NSDictionary) -> Bool {
        if let appStoreVersion = getAppStoreVersion(from: dict),
           let currentVersion = getAppVersion(),
           currentVersion < appStoreVersion {
            return true
        }
        
        return false
    }
    
    static func getAppVersion() -> String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    static func getAppStoreVersion(from dict: NSDictionary) -> String? {
        if let results = dict["results"] as? NSArray,
           let resultDict = results.firstObject as? NSDictionary,
           let appStoreVersion = resultDict["version"] as? String {
            return appStoreVersion
        }
        
        return nil
    }
}
