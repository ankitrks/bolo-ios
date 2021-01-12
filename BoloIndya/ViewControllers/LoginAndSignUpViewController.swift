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
import Branch

class LoginAndSignUpViewController: BaseVC {

    @IBOutlet weak var signInWithGoogle: UIButton!
    
    @IBOutlet weak var verifyOtp: UIButton!
    @IBOutlet weak var continueWithMobile: UIButton!
    //IBOutlet weak var signInWithGoogle: UIButton!
    @IBOutlet weak var mobile_no: UITextField!
    
    @IBOutlet weak var otp: UITextField!
    
    @IBOutlet weak var number_and_google_login_view: UIStackView!
    
    @IBOutlet weak var otp_view: UIStackView!
    
    var image = UIImageView()
    var otp_image = UIImageView()
    
    var selected_tab: Int = 1
    
    var current_page = "terms_and_condition"
    var go_back =  UIImageView()
    var privacy_policy = UILabel()
    var terms_and_condition = UILabel()
    var earn_money = UILabel()
    
    @IBAction func continueWithNumber(_ sender: UIButton) {
    
        self.mobile_no.resignFirstResponder()
        self.otp.resignFirstResponder()
        
        let parameters: [String: Any] = [
            "mobile_no": "+91\(mobile_no.text.unsafelyUnwrapped)"
        ]
        
        AF.request("https://www.boloindya.com/api/v1/otp/send_with_country_code/", method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseString  { (responseData) in
                switch responseData.result {
                case.success(_):
                    self.otp_image.isHidden = false
                    self.image.isHidden = true
                    self.otp_view.isHidden = false
                    self.number_and_google_login_view.isHidden = true
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
        
        let myColor = UIColor.white
        mobile_no.layer.borderColor = myColor.cgColor
        otp.layer.borderColor = myColor.cgColor

        mobile_no.layer.borderWidth = 0.5
        otp.layer.borderWidth = 0.5
        
        go_back.translatesAutoresizingMaskIntoConstraints = false
        go_back.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        go_back.heightAnchor.constraint(equalToConstant: 40).isActive = true
        go_back.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5).isActive = true
        go_back.topAnchor.constraint(equalTo: self.view.topAnchor, constant: getStatusBarHeight()).isActive = true
        
        go_back.image = UIImage(named: "close_white")
        go_back.tintColor = UIColor.white
        
        go_back.isUserInteractionEnabled = true
        
        view.addSubview(privacy_policy)
        view.addSubview(terms_and_condition)
        view.addSubview(earn_money)
        
        let screenSize = UIScreen.main.bounds.size
        
        earn_money.translatesAutoresizingMaskIntoConstraints = false
        earn_money.heightAnchor.constraint(equalToConstant: 20).isActive = true
        earn_money.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        earn_money.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        earn_money.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        
        earn_money.font = UIFont.boldSystemFont(ofSize: 13.0)
        earn_money.text = "Earn money with Video bytes"
        earn_money.textColor = UIColor.white
        earn_money.textAlignment = .center
        
        earn_money.isUserInteractionEnabled = true
        let earn = UITapGestureRecognizer(target: self, action: #selector(earnpages(_:)))
        
        earn_money.addGestureRecognizer(earn)
        
        privacy_policy.translatesAutoresizingMaskIntoConstraints = false
        privacy_policy.heightAnchor.constraint(equalToConstant: 20).isActive = true
        privacy_policy.widthAnchor.constraint(equalToConstant: screenSize.width/2-CGFloat(10)).isActive = true
        privacy_policy.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        privacy_policy.bottomAnchor.constraint(equalTo: earn_money.topAnchor, constant: -10).isActive = true
        privacy_policy.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        privacy_policy.text = "Privacy Policy"
        privacy_policy.textColor = UIColor.white
        
        privacy_policy.isUserInteractionEnabled = true
        let privacy = UITapGestureRecognizer(target: self, action: #selector(privacypages(_:)))
        
        privacy_policy.addGestureRecognizer(privacy)
        
        terms_and_condition.translatesAutoresizingMaskIntoConstraints = false
        terms_and_condition.heightAnchor.constraint(equalToConstant: 20).isActive = true
        terms_and_condition.widthAnchor.constraint(equalToConstant:  screenSize.width/2-CGFloat(10)).isActive = true
        terms_and_condition.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        terms_and_condition.bottomAnchor.constraint(equalTo: earn_money.topAnchor, constant: -10).isActive = true
        terms_and_condition.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        terms_and_condition.text = "Terms and Conditions"
        terms_and_condition.textColor = UIColor.white
        terms_and_condition.textAlignment = .right
        
        terms_and_condition.isUserInteractionEnabled = true
        let termsandcondition = UITapGestureRecognizer(target: self, action: #selector(termpages))
        
        terms_and_condition.addGestureRecognizer(termsandcondition)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goBack(_:)))
        go_back.addGestureRecognizer(tapGesture)
        
        mobile_no.delegate = self
        otp.delegate = self
        
//        otp_image.layoutMargins = UIEdgeInsets(top: 198, left: 8, bottom: 8, right: 8)
//        image.layoutMargins = UIEdgeInsets(top: 180, left: 8, bottom: 500, right: 8)
        
        view.addSubview(image)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.widthAnchor.constraint(equalToConstant: 150).isActive = true
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        image.bottomAnchor.constraint(equalTo: number_and_google_login_view.topAnchor, constant: 10).isActive = true
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "logo")
        
        

        view.addSubview(otp_image)
        
        
        otp_image.translatesAutoresizingMaskIntoConstraints = false
        otp_image.widthAnchor.constraint(equalToConstant: 150).isActive = true
        otp_image.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        otp_image.bottomAnchor.constraint(equalTo: otp_view.topAnchor, constant: 10).isActive = true
        otp_image.image = UIImage(named: "logo")
        otp_image.contentMode = .scaleAspectFit
        otp_image.clipsToBounds = true
        otp_image.isHidden = true
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        GIDSignIn.sharedInstance().clientID = "581293693346-tphkhhes9a84ohf929cqt1l5vaerm3rr.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
    
        // signInWithGoogle.layer.cornerRadius = 10.0
        verifyOtp.layer.cornerRadius = 10.0
        continueWithMobile.layer.cornerRadius = 10.0
        mobile_no.layer.cornerRadius = 10.0
        otp.layer.cornerRadius = 10.0
        //continueWithMobile.backgroundColor = UIColor.white;
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is TermsPagesViewController {
           let vc = segue.destination as? TermsPagesViewController
           vc?.current_page = current_page
        }
    }
    
    @objc func goBack(_ sender: UITapGestureRecognizer) {
        self.otp_image.isHidden = true
        self.image.isHidden = false
        self.otp_view.isHidden = true
        self.number_and_google_login_view.isHidden = false
        if self.navigationController == nil {
            self.dismiss(animated: true, completion: nil)
        } else if (selected_tab == 0) {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    @objc func termpages(_ sender: UITapGestureRecognizer) {
       current_page = "terms_and_condition"
       performSegue(withIdentifier: "contentpages", sender: self)
    }
    
    @objc func earnpages(_ sender: UITapGestureRecognizer) {
       current_page = "bolo_action"
       performSegue(withIdentifier: "contentpages", sender: self)
    }
    
    @objc func privacypages(_ sender: UITapGestureRecognizer) {
       current_page = "privacy_poilcy"
       performSegue(withIdentifier: "contentpages", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    override func onSuccessResponse(response: Any, resultCode: Int = 0) {
        //if(resultCode == 2){
        
            if let userInfo = response as? LoginUserInfo,
               let access = userInfo.accessToken,
               !access.isEmpty {
                setDataUserInfo(info: userInfo)
                sentToTrending()
          
                let isSignup = userInfo.message?.lowercased() == "user created"
                let eventName = isSignup ? EventName.signUp : EventName.login
                let values = ["mobile": mobile_no.text ?? "",
                              "mode": "mobile"]
                WebEngageHelper.trackEvent(eventName: eventName, values: values)
            } else {
                showToast(message: "Please enter valid otp"  )
            }
   // }
    }

    override func onFailResponse(response: Error) {
         print(response.localizedDescription)
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
                Branch.getInstance().setIdentity(userid)
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
        
        setParam(url: PROFILE_URL , param: parameters, className: LoginUserInfo.self, resultCode: 2)
        
    }
    
    @IBAction func verifyOTP(_ sender: UIButton) {
        
        self.mobile_no.resignFirstResponder()
        self.otp.resignFirstResponder()
        
        let parameters: [String: Any] = [
            "mobile_no": "\(mobile_no.text.unsafelyUnwrapped)",
            "otp": "\(otp.text.unsafelyUnwrapped)",
            "country_code": "+91",
            "language": UserDefaults.standard.getValueForLanguageId() ?? "2" as String
        ]
        

        let userid = String(UserDefaults.standard.getUserId() ?? 0)
        Branch.getInstance().setIdentity(userid)
        setParam(auth: false,url: OTP_VERIFY_URL, param: parameters, className: LoginUserInfo.self)
    }
    
 
    func sentToTrending() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }

    
}

extension LoginAndSignUpViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.mobile_no.resignFirstResponder()
        self.otp.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
}
