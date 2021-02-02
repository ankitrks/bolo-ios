//
//  SceneDelegate.swift
//  BoloIndya
//
//  Created by apple on 7/9/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Alamofire

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    enum AppUpdatePopupType {
        case forced
        case optional
    }
    
    var window: UIWindow?
    
    private var isUpdateRequestSent = false
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        (UIApplication.shared.delegate as? AppDelegate)?.self.window = window
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        isUpdateRequestSent = true
        fetchUpdateDetails(activity: connectionOptions.userActivities.first)
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        pushViewController(activity: userActivity, isDeeplink: true)
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        if !isUpdateRequestSent {
            let topViewController = UIApplication.topMostViewController()
            if topViewController?.isKind(of: UIAlertController.self) == true {
                //alert controller is already shown. To avoid duplicate alert controllers
                
                if topViewController?.view.tag == Constants.viewTags.updateView {
                    //update alert controller is already shown
                    return
                } else {
//                    topViewController?.dismiss(animated: true, completion: nil)
                }
            }
            
            fetchUpdateDetails(didBecomeActive: true)
        }
    }
}

//MARK: - Update Helpers
@available(iOS 13.0, *)
extension SceneDelegate {
    private func fetchUpdateDetails(activity: NSUserActivity? = nil, didBecomeActive: Bool = false) {
        var headers: HTTPHeaders?
        
        if let token = UserDefaults.standard.getAuthToken(), !token.isEmpty {
            headers = ["Authorization": "Bearer \(token)"]
        }
        
        let url = "https://www.boloindya.com/api/v1/my_app_version/"
        AF.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseString { [weak self] (responseData) in
                
                self?.isUpdateRequestSent = false
                
                switch responseData.result {
                case.success(let data):
                    guard let json_data = data.data(using: .utf8) else { break }
                        
                    do {
                        let object = try JSONDecoder().decode(BIAppVersionModel.self, from: json_data)
                        
                        if let popupType = self?.isShowUpdatePopup(object: object.appVersion) {
                            switch popupType {
                            case .forced:
                                self?.showUpdatePopup(type: .forced)
                                return
                            case .optional:
                                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                                    self?.showUpdatePopup(type: .optional)
                                }
                            }
                        }
                    } catch {
                        print(error)
                    }
                case.failure(let error):
                    print(error)
                }
                
                if !didBecomeActive {
                    self?.showAppView()
                }
                
                if let activity = activity {
                    self?.pushViewController(activity: activity, isDeeplink: false)
                }
            }
    }
    
    private func isShowUpdatePopup(object: BIAppVersionNestedModel?) -> AppUpdatePopupType? {
        if let object = object,
           let remoteVersion = object.iosVersionToBePushed,
           let currentVersion = BIUtility.getAppVersion(),
           "\(remoteVersion)" > currentVersion {
            
            if let hardPush = object.isIosHardPush, hardPush {
                return .forced
            } else {
                return .optional
            }
        }
        
        return nil
    }
}

//MARK: - UI Helpers
@available(iOS 13.0, *)
extension SceneDelegate {
    private func showUpdatePopup(type: AppUpdatePopupType) {
        var title: String
        var message: String
        
        if type == .forced {
            title = "Update Available!"
            message = "A new version of Bolo Indya is live on the App Store. Please update the app to continue using Bolo Indya."
        } else {
            title = "Update Available!"
            message = "A new version of Bolo Indya is live on the App Store. Please update the app to enjoy the latest features of Bolo Indya."
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { _ in
            guard let url  = URL(string: "https://apps.apple.com/us/app/bolo-indya-short-video-app/id1527082221"),
                  UIApplication.shared.canOpenURL(url)
            else { return }
            
            UIApplication.shared.open(url)
        }))
        
        if type == .optional {
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        }
        
        alert.view.tag = Constants.viewTags.updateView
        
        if type == .forced {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(hex: "10A5F9")
            
            window?.rootViewController = vc
            window?.windowLevel = UIWindow.Level.alert + 1
            window?.rootViewController?.present(alert, animated: true, completion: nil)
        } else {
            UIApplication.topMostViewController()?.present(alert, animated: true, completion: nil)
        }
    }
    
    private func showAppView() {
        if UserDefaults.standard.isLoggedIn() == true && (UserDefaults.standard.getAuthToken() == nil || (UserDefaults.standard.getAuthToken() ?? "").isEmpty) {
            moveToLoginSignupView()
        } else if UserDefaults.standard.isLanguageSet() ?? false {
            moveToTrendingView()
        } else {
            moveToChooseLanguageView()
        }
    }
    
    private func pushViewController(activity: NSUserActivity, isDeeplink: Bool) {
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
        } else if paths.first == "campaign" {
            guard paths.count > 1,
                  !paths[1].isEmpty
            else { return }
            
            BIDeeplinkHandler.campaignHashtag = paths[1]
            
            if isDeeplink {
                moveToDiscoverView()
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    self.moveToDiscoverView()
                }
            }
            return
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
    
    private func moveToDiscoverView() {
        let navVC = UIApplication.topMostViewController()?.navigationController
        navVC?.popToRootViewController(animated: false)
        
        if let discoverVC = UIApplication.topMostViewController() as? DiscoverViewController {
            discoverVC.viewWillAppear(true)
        } else {
            navVC?.tabBarController?.selectedIndex = 1
        }
    }
    
    private func moveToLoginSignupView() {
        let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginAndSignUpViewController")
        let rootNC = UINavigationController(rootViewController: rootVC)
        
        if let snapshot = window?.snapshotView(afterScreenUpdates: true) {
            rootNC.view.addSubview(snapshot)
            
            window?.rootViewController = rootNC
            
            UIView.animate(withDuration: 0.5, animations: {() in
                snapshot.layer.opacity = 0
                snapshot.layer.transform = CATransform3DMakeScale(2, 2, 2)
            }, completion: { _ in
                snapshot.removeFromSuperview()
            })
        } else {
            window?.rootViewController = rootNC
        }
        
        window?.makeKeyAndVisible()
    }
    
    private func moveToChooseLanguageView() {
        let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChooseLanguageFirstViewController")
        let rootNC = UINavigationController(rootViewController: rootVC)
        
        if let snapshot = window?.snapshotView(afterScreenUpdates: true) {
            rootNC.view.addSubview(snapshot)
            
            window?.rootViewController = rootNC
            
            UIView.animate(withDuration: 0.5, animations: {() in
                snapshot.layer.opacity = 0
                snapshot.layer.transform = CATransform3DMakeScale(2, 2, 2)
            }, completion: { _ in
                snapshot.removeFromSuperview()
            })
        } else {
            window?.rootViewController = rootNC
        }
        
        window?.makeKeyAndVisible()
    }
    
    private func moveToTrendingView() {
        let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController")
        let rootNC = UINavigationController(rootViewController: rootVC)
        
        if let snapshot = window?.snapshotView(afterScreenUpdates: true) {
            rootNC.view.addSubview(snapshot)
            
            window?.rootViewController = rootNC
            
            UIView.animate(withDuration: 0.5, animations: {() in
                snapshot.layer.opacity = 0
                snapshot.layer.transform = CATransform3DMakeScale(2, 2, 2)
            }, completion: { _ in
                snapshot.removeFromSuperview()
            })
        } else {
            window?.rootViewController = rootNC
        }
        
        window?.makeKeyAndVisible()
    }
}
