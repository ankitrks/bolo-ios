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
    
    var go_back =  UIImageView()
    
    @IBAction func continueWithNumber(_ sender: UIButton) {
    
        let parameters: [String: Any] = [
        "mobile_no": "+91" + (mobile_no.text ?? "")
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
        
        go_back.image = UIImage(named: "close")
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
        self.tabBarController?.selectedIndex = 0
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
                    print(data)
                    break
                case.failure(let error):
                    print(error)
                }
        }
        
    }
    
    @IBAction func verifyOTP(_ sender: UIButton) {
        
        let parameters: [String: Any] = [
            "mobile_no": (mobile_no.text ?? ""),
            "otp": (otp.text ?? ""),
            "country_code": "+91",
            "language": "2"
        ]
        
        Alamofire.request("https://www.boloindya.com/api/v1/otp/verify_with_country_code/", method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseString  { (responseData) in
                switch responseData.result {
                case.success(let data):
                    print(data)
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


//{"username": "bi191040877", "access": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwidXNlcl9pZCI6MzkzNDIsImp0aSI6ImZhNGY5YjdlMDJiMjQ0ZDhiM2YxZDMzNDVjZTk4YTUxIiwiZXhwIjoxNjgwODE0MjI5fQ.dWaQu3wByjrNvKyce4n0tm4X7XzxnEMhfGXAR8con28", "message": "User Logged In", "user": {"id": 39342, "userprofile": {"id": 20347, "follow_count": 33, "follower_count": 2820, "bolo_score": "16.5K", "slug": "bi191040877", "view_count": "181.3K", "own_vb_view_count": "181.3K", "is_expert": false, "topic_count": 0, "comment_count": 0, "is_popular": false, "is_superstar": false, "is_business": true, "cover_pic": "https://boloindyapp-prod.s3.amazonaws.com/public/cover_photo/Gitesh_1593975923463.jpeg", "profile_pic": "https://s3.amazonaws.com/boloindyapp-prod/thumbnail/img-159397590439.jpg", "name": "Gitesh", "bio": "adaptive", "d_o_b": "12/15/1996", "gender": "1", "about": "adaptive", "language": "1", "refrence": null, "social_identifier": "4x4TNsFBFrXlY0N0jNyzOHUkqIX2", "mobile_no": "9911806266", "question_count": 0, "answer_count": 51, "share_count": 196, "like_count": 40, "vb_count": 33, "encashable_bolo_score": 0, "is_test_user": false, "linkedin_url": null, "twitter_id": null, "instagarm_id": null, "is_dark_mode_enabled": false, "total_vb_playtime": 3544, "total_time_spent": 0, "state_name": "Haryana", "city_name": "Gurgaon", "paytm_number": "9911806266", "android_did": null, "is_guest_user": false, "boost_views_count": 0, "boost_like_count": 0, "boost_follow_count": 0, "boosted_time": null, "boost_span": 0, "country_code": "+91", "salary_range": null, "user": 39342, "sub_category": [70, 72, 67]}, "username": "bi191040877", "first_name": "", "last_name": "", "email": "giteshshastri96@gmail.com", "is_active": true}, "refresh": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsInVzZXJfaWQiOjM5MzQyLCJqdGkiOiI2MTc4NTNlMWEzODQ0MGM3ODIyYjdhMGRiMTgwMzVlNSIsImV4cCI6MTU5NDU4NzAyOX0.vSAGqEFLNowjNz4BDi4tiFJFOtNFZUzUa9WXWm8Idc0"}
