//
//  FeedBackViewController.swift
//  BoloIndya
//
//  Created by apple on 7/13/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Alamofire

class FeedBackViewController: UIViewController {
    
    var upper_tab = UIView()
    var back_image = UIImageView()
    var label = UILabel()
    var tick_image = UIImageView()
    
    var heading = UILabel()
    var email = UITextField()
    var mobile_no = UITextField()
    var feedback = UITextField()
    
    var loader = UIActivityIndicatorView()
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        self.view.layer.backgroundColor = UIColor.black.cgColor
        
        upper_tab.addSubview(back_image)
        upper_tab.addSubview(label)
        upper_tab.addSubview(tick_image)
        
        view.addSubview(upper_tab)
        view.addSubview(heading)
        view.addSubview(email)
        view.addSubview(mobile_no)
        view.addSubview(feedback)
        
        upper_tab.translatesAutoresizingMaskIntoConstraints = false
        upper_tab.heightAnchor.constraint(equalToConstant: 40).isActive = true
        upper_tab.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 0).isActive = true
        upper_tab.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: 0).isActive = true
        upper_tab.topAnchor.constraint(equalTo: self.view.topAnchor, constant: getStatusBarHeight()).isActive = true
        
        upper_tab.layer.backgroundColor = UIColor(hex: "10A5F9")?.cgColor
        
        back_image.translatesAutoresizingMaskIntoConstraints = false
        back_image.heightAnchor.constraint(equalToConstant: 20).isActive = true
        back_image.widthAnchor.constraint(equalToConstant: 40).isActive = true
        back_image.centerYAnchor.constraint(equalTo: upper_tab.centerYAnchor,constant: 0).isActive = true
        back_image.leftAnchor.constraint(equalTo: upper_tab.leftAnchor,constant: 10).isActive = true
        
        back_image.isUserInteractionEnabled = true
        let tapGestureBack = UITapGestureRecognizer(target: self, action: #selector(goBack(_:)))
        back_image.addGestureRecognizer(tapGestureBack)
        
        back_image.image = UIImage(named: "back")
        back_image.contentMode = .scaleAspectFit
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.centerYAnchor.constraint(equalTo: upper_tab.centerYAnchor,constant: 0).isActive = true
        label.leftAnchor.constraint(equalTo: back_image.rightAnchor,constant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: tick_image.leftAnchor,constant: -10).isActive = true
        
        label.text = "Send Feedback"
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        tick_image.translatesAutoresizingMaskIntoConstraints = false
        tick_image.heightAnchor.constraint(equalToConstant: 20).isActive = true
        tick_image.widthAnchor.constraint(equalToConstant: 40).isActive = true
        tick_image.centerYAnchor.constraint(equalTo: upper_tab.centerYAnchor,constant: 0).isActive = true
        tick_image.rightAnchor.constraint(equalTo: upper_tab.rightAnchor,constant: -10).isActive = true
        
        tick_image.image = UIImage(named: "tick")
        tick_image.contentMode = .scaleAspectFit
        
        tick_image.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sendFeedBack))
        tick_image.addGestureRecognizer(tapGesture)
        
        heading.translatesAutoresizingMaskIntoConstraints = false
        heading.heightAnchor.constraint(equalToConstant: 30).isActive = true
        heading.topAnchor.constraint(equalTo: upper_tab.bottomAnchor,constant: 10).isActive = true
        heading.leftAnchor.constraint(equalTo: back_image.rightAnchor,constant: 10).isActive = true
        heading.rightAnchor.constraint(equalTo: tick_image.leftAnchor,constant: -10).isActive = true
        
        heading.text = "Tell us your feedback"
        heading.textColor = UIColor.white
        heading.textAlignment = .center
        
        email.translatesAutoresizingMaskIntoConstraints = false
        email.heightAnchor.constraint(equalToConstant: 30).isActive = true
        email.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        email.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        email.topAnchor.constraint(equalTo: heading.bottomAnchor, constant: 20).isActive = true
        
        email.textColor = UIColor.white
        email.placeholder = "Email *"
        email.attributedPlaceholder = NSAttributedString(string: "Email *", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        email.delegate = self
        
        email.layer.borderColor = UIColor.white.cgColor
        email.layer.borderWidth = 1
        
        mobile_no.translatesAutoresizingMaskIntoConstraints = false
        mobile_no.heightAnchor.constraint(equalToConstant: 30).isActive = true
        mobile_no.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        mobile_no.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        mobile_no.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 15).isActive = true
        
        mobile_no.textColor = UIColor.white
        mobile_no.placeholder = "Mobile No *"
        mobile_no.attributedPlaceholder = NSAttributedString(string: "Mobile No *", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        mobile_no.delegate = self
        
        mobile_no.layer.borderColor = UIColor.white.cgColor
        mobile_no.layer.borderWidth = 1
        
        feedback.translatesAutoresizingMaskIntoConstraints = false
        feedback.heightAnchor.constraint(equalToConstant: 30).isActive = true
        feedback.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        feedback.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        feedback.topAnchor.constraint(equalTo: mobile_no.bottomAnchor, constant: 15).isActive = true
        
        feedback.textColor = UIColor.white
        feedback.placeholder = "What would you like us to improve?"
        feedback.attributedPlaceholder = NSAttributedString(string: "What would you like us to improve?", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        feedback.delegate = self
    
        feedback.layer.borderColor = UIColor.white.cgColor
        feedback.layer.borderWidth = 1
        
        email.layer.cornerRadius = 5.0
        mobile_no.layer.cornerRadius = 5.0
        feedback.layer.cornerRadius = 5.0
        
        let paddingViewEmail = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: email.frame.height))
        email.leftView = paddingViewEmail
        email.leftViewMode = .always
        
        let paddingViewMobile = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: mobile_no.frame.height))
        mobile_no.leftView = paddingViewMobile
        mobile_no.leftViewMode = .always
        
        let paddingViewFeed = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: feedback.frame.height))
        feedback.leftView = paddingViewFeed
        feedback.leftViewMode = .always
        
        email.font = UIFont.boldSystemFont(ofSize: 12.0)
        mobile_no.font = UIFont.boldSystemFont(ofSize: 12.0)
        feedback.font = UIFont.boldSystemFont(ofSize: 12.0)
        
        view.addSubview(loader)
        
        loader.center = self.view.center
        
        loader.color = UIColor.white
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendFeedBack(_ sender: Any) {
        if (email.text ?? "").isEmpty {
            setAlert(message: "Please Enter Email")
        } else if (mobile_no.text ?? "").isEmpty {
            setAlert(message: "Please Enter Mobile No.")
        } else if (feedback.text ?? "").isEmpty {
            setAlert(message: "Please Enter Feedback")
        } else {
            saveFeedBack()
        }
        
    }
    
    func saveFeedBack() {
        
        if isLoading {
            return
        }
        
        let paramters: [String: Any] = [
            "contact_mobile": mobile_no.text ?? "",
            "contact_email": email.text ?? "",
            "description": feedback.text ?? "",
            "feedback_image": ""
        ]
        
        var headers: [String: Any]? = nil
        
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
            headers = ["Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        
        loader.isHidden = false
        loader.startAnimating()
        isLoading = true
        
        let url = "https://www.boloindya.com/api/v1/submit_user_feedback/"
        
        Alamofire.request(url, method: .post, parameters: paramters, encoding: URLEncoding.default, headers: headers as? HTTPHeaders)
            .responseString  { (responseData) in
                self.loader.isHidden = true
                self.loader.stopAnimating()
                self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setAlert(message: String) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}


extension FeedBackViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.email.resignFirstResponder()
        self.mobile_no.resignFirstResponder()
        self.feedback.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
}
