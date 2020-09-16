//
//  AppDelegate.swift
//  BoloIndya
//
//  Created by apple on 7/9/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Firebase
let NextLevelAlbumTitle = "NextLevel"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate  {
    
    var window: UIWindow?
    
    var baseUrl:String? = "https://www.boloindya.com/api/v1/"
//        Request request = new Request.Builder()
//    .url(Constants.BOLO_INDYA_URL + "upload_video_to_s3_for_app/")
//    .addHeader("content-type", "multipart/form-data;")
//    .addHeader("Authorization", "Bearer " + cache)
//    .addHeader("cache-control", "no-cache")
//    .post(requestBody)
//    .build();

    var imgbaseUrl:String? = "http://domain/API/tictic/"
    var sharURl:String? =  "http://bringthings.com/"
    var signUp:String? = "signup"
    var uploadVideo:String? = "upload_video_to_s3_for_app/"
    var showAllVideos:String? = "showAllVideos"
    var showMyAllVideos:String? = "showMyAllVideos"
    var likeDislikeVideo:String? = "likeDislikeVideo"
    var postComment:String? = "postComment"
    var showVideoComments:String? = "showVideoComments"
    var updateVideoView:String? = "updateVideoView"
    var fav_sound:String? = "fav_sound"
    var my_FavSound:String? = "my_FavSound"
    var allSounds:String? = "allSounds"
    var my_liked_video:String? = "my_liked_video"
    var discover:String? = "discover"
    var edit_profile:String? = "edit_profile"
    var follow_users:String? = "follow_users"
    var get_user_data:String? = "get_user_data"
    var uploadImage:String? = "uploadImage"
    var get_followers:String? = "get_followers"
    var get_followings:String? = "get_followings"
    var downloadFile:String? = "downloadFile"
    var getNotifications:String? = "getNotifications"

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

