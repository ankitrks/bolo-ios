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
        print("User Profile \(user.profile.email ?? "No Email") \(user.authentication.idToken ?? "")")
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
}
