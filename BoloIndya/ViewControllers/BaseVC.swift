//
//  BaseVC.swift
//  BoloIndya
//
//  Created by Mushareb on 10/09/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation
import ObjectMapper
class BaseVC: UIViewController {
    func setParam<T: Mappable>(showProgressBar:Bool = true,auth:Bool = true,url:String, param:[String:Any],className:T.Type,resultCode:Int = 0 )  {
        AFWrapper.requestPOSTURL(showProgressBar: showProgressBar, auth: auth ,url: url, params: param, success: { (response:T) in
                  print("\(url)")
                print("\(response)")
                  self.onSuccessResponse(response: response,resultCode: resultCode)
    //              if showProgressBar == false{
    //                  self.refreshHide()
    //              }
              }, failure: { (error:Error) in
                  self.onFailResponse(response: error,resultCode: resultCode)
    //              if showProgressBar == false{
    //                  self.refreshHide()
    //              }

              })


          }

        func onSuccessResponse(response:Any,resultCode:Int = 0) {
                    onSuccessResponse(response: response)

                 }
           func onSuccessResponse(response:Any) {
               AppUtils.showPrograssBar(show: false)

           }

           func onFailResponse(response:Error,resultCode:Int = 0) {
               onFailResponse(response: response)

           }

          func onFailResponse(response:Error) {
                  AppUtils.showPrograssBar(show: false)

              }

    func setDataUserInfo(info:LoginUserInfo) {
             UserDefaults.standard.setLoggedIn(value: true)
        UserDefaults.standard.setAuthToken(value: info.accessToken ?? "")
             UserDefaults.standard.setUsername(value: info.username ?? "")
             if let u = info.user {
                 UserDefaults.standard.setUserId(value: u.id)
                 if let profile = u.userprofile {
                     UserDefaults.standard.setName(value: profile.name)
                     UserDefaults.standard.setCoverPic(value: profile.coverPic)
                     UserDefaults.standard.setProfilePic(value: profile.profilePic)
                     UserDefaults.standard.setBio(value: profile.bio)
                    UserDefaults.standard.setGuestLoggedIn(value: profile.isGuestUser)
                  //  UserDefaults.standard.isg(value: profile.bio)
                    //is_guest_user
                 }

             }



         }


    func isLogin() ->Bool {
        let isLoggedIn = UserDefaults.standard.getGuestLoggedIn() ?? true
             if (isLoggedIn) {
                 self.tabBarController?.tabBar.isHidden = true
                 self.navigationController?.isNavigationBarHidden = true
                 performSegue(withIdentifier: "LoginAndSignUpViewController", sender: self)
                 return false
             }
         return true

        }





}
