//
//  BaseVC.swift
//  BoloIndya
//
//  Created by Mushareb on 10/09/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import SVProgressHUD

class BaseVC: UIViewController {
    func setParam<T: Mappable>(showProgressBar: Bool = true, auth: Bool = true, url: String, param: [String:Any], className: T.Type, resultCode: Int = 0) {
        showPrograssBar(show: showProgressBar)
        
        var headers: HTTPHeaders?
        
        if auth, let token = UserDefaults.standard.getAuthToken(), !token.isEmpty {
            headers = ["Authorization": "Bearer \(token)"]
        }
        
        AF.request(url, method: .post, parameters: param, encoding: URLEncoding.default, headers: headers).responseObject { [weak self] (response: AFDataResponse<T>) in
            print("url : \(response.request!)" as Any)
            
            switch response.result {
            case .success(let mappable):
                self?.onSuccessResponse(response: mappable, resultCode: resultCode)
                self?.showPrograssBar(show: false)
            case .failure(let error):
                self?.onFailResponse(response: error, resultCode: resultCode)
                self?.showPrograssBar(show: false)
            }
        }
    }
    
    func onSuccessResponse(response: Any, resultCode: Int = 0) {
        onSuccessResponse(response: response)
    }
    
    func onSuccessResponse(response: Any) {
        showPrograssBar(show: false)
    }
    
    func onFailResponse(response: Error, resultCode: Int = 0) {
        onFailResponse(response: response)
    }
    
    func onFailResponse(response: Error) {
        showPrograssBar(show: false)
    }
    
    func setDataUserInfo(info: LoginUserInfo) {
        
        if let accessToken = info.accessToken, !accessToken.isEmpty {
            UserDefaults.standard.setAuthToken(value: accessToken)
        }
        if let username = info.username, !username.isEmpty {
            UserDefaults.standard.setUsername(value: username)
        }
        
        if let u = info.user {
            UserDefaults.standard.setUserId(value: u.id)
            
            if let id = u.id {
                BranchHelper().setId(userId: "\(id)")
                CrashlyticsHelper().setUserId(id: "\(id)")
            }
            
            if let profile = u.userprofile {
                UserDefaults.standard.setName(value: profile.name)
                UserDefaults.standard.setCoverPic(value: profile.coverPic)
                UserDefaults.standard.setProfilePic(value: profile.profilePic)
                UserDefaults.standard.setBio(value: profile.bio)
                UserDefaults.standard.setGuestLoggedIn(value: profile.isGuestUser)
                UserDefaults.standard.setAbout(value: profile.about)
                //  UserDefaults.standard.isg(value: profile.bio)
                
                UserDefaults.standard.setGender(value: profile.gender)
                UserDefaults.standard.setDOB(value: profile.dOB)
                
                UserDefaults.standard.setIsSuperStar(value: profile.isSuperstar ?? false)
                UserDefaults.standard.setIsExpert(value: profile.isExpert ?? false)
                UserDefaults.standard.setIsBusiness(value: profile.isBusiness ?? false)
                UserDefaults.standard.setIsPopular(value: profile.isPopular ?? false)
                
                CrashlyticsHelper().setUserName(name: profile.name)
            }
        }
        
        WebEngageHelper.setUserAttributes()
    }
    
    func isLogin() -> Bool {
        var isLoggedin: Bool
        if let isLoggedIn = UserDefaults.standard.isLoggedIn(), isLoggedIn {
            isLoggedin = true
        } else if let guest = UserDefaults.standard.getGuestLoggedIn(), !guest, let name = UserDefaults.standard.getName(), !name.isEmpty, let gender = UserDefaults.standard.getGender(), !gender.isEmpty, let dob = UserDefaults.standard.getDOB(), !dob.isEmpty {
            isLoggedin = true
        } else {
            isLoggedin = false
        }
        
        if !isLoggedin {
            tabBarController?.tabBar.isHidden = true
            navigationController?.isNavigationBarHidden = true
            performSegue(withIdentifier: "LoginAndSignUpViewController", sender: self)
        }
        
        return isLoggedin
    }
    
    private func showPrograssBar(show: Bool) {
        if show {
            SVProgressHUD.show()
            SVProgressHUD.setBackgroundColor(.white)
        } else {
            SVProgressHUD.dismiss()
        }
    }
}


extension BaseVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
