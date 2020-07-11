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

class LoginAndSignUpViewController: UIViewController {

    @IBOutlet weak var signInWithGoogle: UIButton!
    
    @IBOutlet weak var continueWithMobile: UIButton!
    
    @IBOutlet weak var mobile_no: UITextField!
    
    @IBOutlet weak var otp: UITextField!
    
    @IBOutlet weak var number_and_google_login_view: UIStackView!
    
    @IBOutlet weak var otp_view: UIStackView!
    
    @IBAction func continueWithNumber(_ sender: UIButton) {
        guard let url = URL(string: "https://www.boloindya.com/api/v1/otp/send_with_country_code/") else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        let number = "+91" + (mobile_no.text ?? "")
        let parameters: [String: Any] = [
            "mobile_no": number
        ]
        print(number)
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print("An error occured while parsing the body into JSON.", error)
        }
        URLSession.shared.dataTask(with: urlRequest) {(data, resp, err) in
            if let error = err {
                print("An Error Occured")
                return
            }
            
            if let data = data {
                do {
                    print(String(data: data, encoding: .utf8))
                    self.otp_view.isHidden = false
                    self.number_and_google_login_view.isHidden = true
                } catch let error {
                    print("Whoops! We couldn't parse the data into JSON my friend..", error)
                }
            }
        }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseApp.configure()

        GIDSignIn.sharedInstance().clientID = "581293693346-tphkhhes9a84ohf929cqt1l5vaerm3rr.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
    
        signInWithGoogle.layer.cornerRadius = 10.0
    
        continueWithMobile.layer.cornerRadius = 10.0
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
        guard let url = URL(string: "https://stage.boloindya.com/api/v1/fb_profile_settings/") else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
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
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            print(String(data: urlRequest.httpBody!, encoding: .utf8) ?? "")
        } catch let error {
            print("An error occured while parsing the body into JSON.", error)
        }
        URLSession.shared.dataTask(with: urlRequest) {(data, resp, err) in
            if let error = err {
                print("An Error Occured")
                return
            }
            
            if let data = data {
                do {
                    print(String(data: data, encoding: .utf8))
                } catch let error {
                    print("Whoops! We couldn't parse the data into JSON my friend..", error)
                }
            }
        }.resume()
    }
    
    @IBAction func verifyOTP(_ sender: UIButton) {
        guard let url = URL(string: "https://www.boloindya.com/api/v1/otp/verify_with_country_code/") else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        let number = (mobile_no.text ?? "")
        let parameters: [String: Any] = [
            "mobile_no": number,
            "otp": (otp.text ?? ""),
            "country_code": "+91",
            "language": "2"
        ]
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            print(String(data: urlRequest.httpBody!, encoding: .utf8) ?? "")
        } catch let error {
            print("An error occured while parsing the body into JSON.", error)
        }
        URLSession.shared.dataTask(with: urlRequest) {(data, resp, err) in
            if let error = err {
                print("An Error Occured")
                return
            }
            
            if let data = data {
                do {
                    print(String(data: data, encoding: .utf8))
                } catch let error {
                    print("Whoops! We couldn't parse the data into JSON my friend..", error)
                }
            }
        }.resume()
    }
    
}
