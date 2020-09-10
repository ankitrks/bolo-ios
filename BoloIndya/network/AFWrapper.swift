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
        Alamofire.request(url, method : .get,parameters: params).responseObject { (response: DataResponse<T>) in
            // UIApplication.shared.isNetworkActivityIndicatorVisible = false

            let responseResult = response.result.value
            print("url : \(response.request!)" as Any)
            switch response.result {
            case .success:
                success(responseResult!)
                 AppUtils.showPrograssBar(show: false)
                break;
            case .failure(let error):
                failure(error  )
                 AppUtils.showPrograssBar(show: false)

                break;
            }
        }


    }

    class func requestPOSTURL<T: Mappable>(showProgressBar:Bool = true,auth:Bool = true,url : String, params : [String : Any]?, success:@escaping (_ response: T) -> Void, failure:@escaping (Error) -> Void){
        AppUtils.showPrograssBar(show: showProgressBar)
        var headers: [String: String]? = nil

            // if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
        if auth == true{
                 headers = ["Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
          //   }

        Alamofire.request(url, method : .post,parameters: params,headers: headers).responseObject { (response: DataResponse<T>) in
            // UIApplication.shared.isNetworkActivityIndicatorVisible = false

            let responseResult = response.result.value
            print("url : \(response.request!)" as Any)
            switch response.result {
            case .success:
                 success(responseResult!)
                 AppUtils.showPrograssBar(show: false)
                break;
            case .failure(let error):
                failure(error  )
                 AppUtils.showPrograssBar(show: false)

                break;
            }
        }


    }


//    class func requestGETURLImage<T: Mappable>(showProgressBar:Bool = true,imageArray:[ImageUploadModel],imageName:String,url : String, params : [String : String]?, success:@escaping (_ response: T) -> Void, failure:@escaping (Error) -> Void){
//
//        let headers: HTTPHeaders = [
//            /* "Authorization": "your_access_token",  in case you need authorization header */
//            "Content-type": "multipart/form-data"
//        ]
//       AppUtils.showPrograssBar(show: showProgressBar)
//        Alamofire.upload(multipartFormData: { multipartFormData in
//
//            for i in 0..<imageArray.count {
//                let currentTimeStamp = String(Int(NSDate().timeIntervalSince1970 * 1000))
//
//                if String.isNilOrEmptyBool(string: String.isNilOrEmpty(string: imageArray[i].fielExtention)){
//                     print("Image time stamp : \(imageName)\(currentTimeStamp).\(imageArray[i].fielExtention!)")
//
//
//                multipartFormData.append(imageArray[i].imagePath!, withName: "images[]",fileName: "\(imageName)\(currentTimeStamp).\(imageArray[i].fielExtention!)", mimeType: "application/*")
//                //   }
//            }else{
//                     print("Image time stamp : \(imageName)\(currentTimeStamp).png")
//               multipartFormData.append(imageArray[i].imagePath!, withName: "images[]",fileName: "\(imageName)\(currentTimeStamp).png", mimeType: "image/*")
//            }
//            }
//            for (key, value) in params! {
//                multipartFormData.append(value.data(using: .utf8)!, withName: key)
//            }
//
//
//        }, to: url, method: .post, headers: headers,
//
//           encodingCompletion: { encodingResult in
//
//            switch encodingResult {
//            case .success(let upload, _, _):
//
//                upload.responseObject(completionHandler: { (response: DataResponse<T>) in
//                    switch response.result {
//                    case .success:
//                        success(response.result.value!)
//                        AppUtils.showPrograssBar(show: false)
//
//                        break;
//                    case .failure(let error):
//                        failure(error  )
//                        AppUtils.showPrograssBar(show: false)
//                        break;
//                    }
//                })
//
//            break
//            case .failure(let error):
//                  AppUtils.showPrograssBar(show: false)
//                 failure(error)
//                print(error)
//                break
//            }
//
//        })
//
//    }











}
