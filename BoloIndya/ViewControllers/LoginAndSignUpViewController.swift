//
//  LoginAndSignUpViewController.swift
//  BoloIndya
//
//  Created by apple on 7/10/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

import Firebase
import GoogleSignIn
import Alamofire

class LoginAndSignUpViewController: UIViewController {

    @IBOutlet weak var signInWithGoogle: UIButton!
    
    @IBOutlet weak var continueWithMobile: UIButton!
    
    @IBOutlet weak var mobile_no: UITextField!
    
    @IBOutlet weak var otp: UITextField!
    
    @IBOutlet weak var number_and_google_login_view: UIStackView!
    
    @IBOutlet weak var otp_view: UIStackView!
    
    var selected_tab: Int = 1
    
    var go_back =  UIImageView()
    
    @IBAction func continueWithNumber(_ sender: UIButton) {
    
        let parameters: [String: Any] = [
        "mobile_no": "+91\(mobile_no.text.unsafelyUnwrapped)"
        ]
        
        Alamofire.request("https://www.boloindya.com/api/v1/otp/send_with_country_code/", method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseString  { (responseData) in
                switch responseData.result {
                case.success(let data):
                    print(data)
                    self.otp_view.isHidden = false
                    self.number_and_google_login_view.isHidden = true
                    break
                case.failure(let error):
                    print(error)
                }
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(go_back)
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        go_back.translatesAutoresizingMaskIntoConstraints = false
        go_back.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        go_back.heightAnchor.constraint(equalToConstant: 40).isActive = true
        go_back.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5).isActive = true
        go_back.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        
        go_back.image = UIImage(named: "close_white")
        go_back.tintColor = UIColor.white
        
        go_back.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goBack(_:)))
        go_back.addGestureRecognizer(tapGesture)
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        GIDSignIn.sharedInstance().clientID = "581293693346-tphkhhes9a84ohf929cqt1l5vaerm3rr.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
    
        signInWithGoogle.layer.cornerRadius = 10.0
    
        continueWithMobile.layer.cornerRadius = 10.0
        
    }
    
    @objc func goBack(_ sender: UITapGestureRecognizer) {
        if (selected_tab == 0) {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
}

extension LoginAndSignUpViewController : GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard let authentication = user.authentication else {
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        print("Login")
        Auth.auth().signIn(with: credential) { (authResult, error) in
            let user = Auth.auth().currentUser
            if let user = user {
                let userid = user.uid
                self.googleLogin(id: userid, profile_pic: "", name: user.displayName ?? "")
                print(userid)
            }
        }
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    func googleLogin(id: String, profile_pic: String, name: String) {
        
        let parameters_extra: [String: Any] = [
            "google_id": id,
            "first_name": name,
            "profile_pic": profile_pic,
            "name": name,
            "last_name": ""
        ]
        var extraData = ""
        do {
            let json_extraData = try JSONSerialization.data(withJSONObject: parameters_extra, options: .prettyPrinted)
            extraData = String(data: json_extraData, encoding: .utf8) ?? ""
        } catch let error {
            print("An error occured while parsing the body into JSON.", error)
        }
        print(extraData)
        let parameters: [String: Any] = [
            "activity": "google_login",
            "profile_pic": profile_pic,
            "name": name,
            "categories": "",
            "bio":"",
            "about": "",
            "extra_data": extraData,
            "refrence": "google",
            "language": "2",
            "user_ip": ""
        ]
        
        Alamofire.request("https://www.boloindya.com/api/v1/fb_profile_settings/", method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseString  { (responseData) in
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                        do {
                            let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                            
                            UserDefaults.standard.setLoggedIn(value: true)
                        
                            UserDefaults.standard.setAuthToken(value: json_object?["access"] as? String)
                        
                            UserDefaults.standard.setUsername(value: json_object?["username"] as? String)
                            
                            let user_obj = json_object?["user"] as? [String: AnyObject]
                            
                            UserDefaults.standard.setUserId(value: user_obj?["id"] as? Int)
                            
                            let user_profile = user_obj?["userprofile"] as? [String: AnyObject]
                            
                            UserDefaults.standard.setName(value: user_profile?["name"] as? String)
                            
                            UserDefaults.standard.setCoverPic(value: user_profile?["cover_pic"] as? String)
                            
                            UserDefaults.standard.setProfilePic(value: user_profile?["profile_pic"] as? String)
                            
                            UserDefaults.standard.setBio(value: user_profile?["bio"] as? String)
                            
                            self.sentToTrending()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    break
                case.failure(let error):
                    print(error)
                }
        }
        
    }
    
    @IBAction func verifyOTP(_ sender: UIButton) {
        
        let parameters: [String: Any] = [
            "mobile_no": "\(mobile_no.text.unsafelyUnwrapped)",
            "otp": "\(otp.text.unsafelyUnwrapped)",
            "country_code": "+91",
            "language": "2"
        ]
        
        Alamofire.request("https://www.boloindya.com/api/v1/otp/verify_with_country_code/", method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseString  { (responseData) in
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                        
                        do {
                            let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                            UserDefaults.standard.setLoggedIn(value: true)
                        
                            UserDefaults.standard.setAuthToken(value: json_object?["access_token"] as? String)
                        
                            let user_obj = json_object?["user"] as? [String: AnyObject]
                            
                            UserDefaults.standard.setUserId(value: user_obj?["id"] as? Int)
                            
                            let user_profile = user_obj?["userprofile"] as? [String: AnyObject]
                            
                            UserDefaults.standard.setUsername(value: user_obj?["username"] as? String)
                            
                            UserDefaults.standard.setName(value: user_profile?["name"] as? String)
                            
                            UserDefaults.standard.setCoverPic(value: user_profile?["cover_pic"] as? String)
                            
                            UserDefaults.standard.setProfilePic(value: user_profile?["profile_pic"] as? String)
                            
                            UserDefaults.standard.setBio(value: user_profile?["bio"] as? String)
                            
                            self.sentToTrending()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    break
                case.failure(let error):
                    print(error)
                }
        }
    
    }
 
    func sentToTrending() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
    
}
