//
//  AppDelegate.swift
//  BoloIndya
//
//  Created by apple on 7/9/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Firebase
import Branch
import WebEngage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate  {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        if let uuid = KeychainHelper.getDeviceId(), !uuid.isEmpty {
            print(uuid)
        } else {
            KeychainHelper.setDeviceId()
        }
        
        // if you are using the TEST key
        Branch.setUseTestBranchKey(false) // make it false for live
        Branch.getInstance().enableLogging()
        Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
            print(params as? [String: AnyObject] ?? {})
        }
        //Branch.getInstance().validateSDKIntegration()
        
        UNUserNotificationCenter.current().delegate = self
        
        WebEngageHelper.application(application, didFinishLaunchingWithOptions: launchOptions)
        WebEngageHelper.setUserAttributes()
        
        initTabBar()
        initNavigationBar()
        
        return true
    }
    
    private func initTabBar() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
        UITabBar.appearance().tintColor = UIColor(hex: "10A5F9")
        UITabBar.appearance().backgroundColor = UIColor(hex: "222020")
    }
    
    private func initNavigationBar() {
        UINavigationBar.appearance().barTintColor = UIColor(hex: "10A5F9")
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return Branch.getInstance().application(app, open: url, options: options)
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
      // handler for Universal Links
        return Branch.getInstance().continue(userActivity)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      // handler for Push Notifications
      Branch.getInstance().handlePushNotification(userInfo)
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

extension AppDelegate: WEGAppDelegate {
    func wegHandleDeeplink(_ deeplink: String!, userData data: [AnyHashable : Any]!) {
        print("Deeplink URL received on click of Push Notification: \(deeplink ?? "")")
    }
    
    func didReceiveAnonymousID(_ anonymousID: String!, for reason: WEGReason) {
        print("Anonymous ID:\(anonymousID)  got refreshed for reason: \(reason)")
    }
}
