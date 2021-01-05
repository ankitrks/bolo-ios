//
//  AFWrapper.swift
//  BoloIndya
//
//  Created by Mushareb on 09/09/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//


import Alamofire
import AlamofireObjectMapper
import ObjectMapper
class AFWrapper: NSObject {
    class func requestGETURL<T: Mappable>(showProgressBar:Bool = true,url : String, params : [String : Any]?, success:@escaping (_ response: T) -> Void, failure:@escaping (Error) -> Void){
        AppUtils.showPrograssBar(show: showProgressBar)
        
        AF.request(url, method : .get,parameters: params).responseObject { (response: AFDataResponse<T>) in
            print("url : \(response.request!)" as Any)
            switch response.result {
            case .success(let mappable):
                success(mappable)
                AppUtils.showPrograssBar(show: false)
            case .failure(let error):
                failure(error)
                AppUtils.showPrograssBar(show: false)
            }
        }
    }
    
    class func requestPOSTURL<T: Mappable>(showProgressBar:Bool = true,auth:Bool = true,url : String, params : [String : Any]?, success:@escaping (_ response: T) -> Void, failure:@escaping (Error) -> Void){
        AppUtils.showPrograssBar(show: showProgressBar)
        var headers: HTTPHeaders? = nil
        
        // if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
        if auth == true{
            headers = ["Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        //   }
        
        AF.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseObject { (response: AFDataResponse<T>) in
            print("url : \(response.request!)" as Any)
            switch response.result {
            case .success(let mappable):
                success(mappable)
                AppUtils.showPrograssBar(show: false)
            case .failure(let error):
                failure(error  )
                AppUtils.showPrograssBar(show: false)
            }
        }
    }
}
