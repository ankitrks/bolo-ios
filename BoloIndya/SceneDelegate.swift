//
//  SceneDelegate.swift
//  BoloIndya
//
//  Created by apple on 7/9/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        (UIApplication.shared.delegate as? AppDelegate)?.self.window = window
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if let userActivity = connectionOptions.userActivities.first {
            showAppView(activity: userActivity, isDeeplink: false)
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        showAppView(activity: userActivity)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    private func showAppView(activity: NSUserActivity, isDeeplink: Bool = false) {
        guard activity.activityType == NSUserActivityTypeBrowsingWeb,
                let incomingURL = activity.webpageURL,
                let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
                let path = components.path
            else { return }
        
        var viewController: UIViewController?
        
        let paths = path.components(separatedBy: "/").filter { !$0.isEmpty }
        if paths.first == "video_bytes" {
            guard paths.count > 2,
                  let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoViewController") as? VideoViewController
                else { return }
            
            vc.topic_id = paths[2]
            
            viewController = vc
        } else if paths.first == "user" {
            guard paths.count > 1,
                  let userId = Int(paths[1])
                else { return }
            
            if userId == UserDefaults.standard.getUserId() {
                if isDeeplink {
                    moveToCurrentUserView()
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                        self.moveToCurrentUserView()
                    }
                }
                return
            } else if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
                let user = User()
                user.id = userId
                vc.user = user
                
                viewController = vc
            }
        }
        
        if isDeeplink {
            push(viewController: viewController)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.push(viewController: viewController)
            }
        }
    }
    
    private func push(viewController: UIViewController?) {
        guard let vc = viewController else { return }
        
        let topVC = UIApplication.topMostViewController()
        if let navVC = topVC as? UINavigationController {
            navVC.pushViewController(vc, animated: true)
        } else if let navVC = topVC?.navigationController {
            navVC.pushViewController(vc, animated: true)
        }
    }
    
    private func moveToCurrentUserView() {
        let topVC = UIApplication.topMostViewController()?.navigationController
        topVC?.popToRootViewController(animated: false)
        topVC?.tabBarController?.selectedIndex = 4
    }
}

