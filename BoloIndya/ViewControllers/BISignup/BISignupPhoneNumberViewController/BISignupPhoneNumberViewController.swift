//
//  BISignupPhoneNumberViewController.swift
//  BoloIndya
//
//  Created by Rahul Garg on 27/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

protocol BISignupPhoneNumberViewControllerDelegate: class {
    func didTapSignupPhoneVCNext(phone: String)
    func didTapSignupPhoneVCBack()
}

final class BISignupPhoneNumberViewController: UIViewController {
    @IBOutlet private weak var contentStackView: UIStackView!
    @IBOutlet private weak var contentStackViewCenterConstraint: NSLayoutConstraint!
    @IBOutlet private weak var countryCodeView: UIView! {
        didSet {
            countryCodeView.layer.cornerRadius = 3
            countryCodeView.layer.borderWidth = 1
            countryCodeView.layer.borderColor = (UIColor(hex: "5C5C5C") ?? UIColor.white).cgColor
            countryCodeView.clipsToBounds = true
        }
    }
    @IBOutlet private weak var phoneNumberView: UIView! {
        didSet {
            phoneNumberView.layer.cornerRadius = 3
            phoneNumberView.layer.borderWidth = 1
            phoneNumberView.layer.borderColor = (UIColor(hex: "5C5C5C") ?? UIColor.white).cgColor
            phoneNumberView.clipsToBounds = true
        }
    }
    @IBOutlet private weak var phoneTextfield: UITextField! {
        didSet {
            phoneTextfield.delegate = self
            
            phoneTextfield.setLeftPaddingPoints(15)
            phoneTextfield.setRightPaddingPoints(15)
            phoneTextfield.maxLength = 10
            
            phoneTextfield.addDoneButtonOnKeyboard()
            phoneTextfield.attributedPlaceholder = NSAttributedString(string: "Enter your Mobile Number",
                                                                      attributes: [.foregroundColor: UIColor(hex: "9A9A9A") ?? UIColor.white])
        }
    }
    
    weak var delegate: BISignupPhoneNumberViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        resignFirstResponder()
    }
    
    @IBAction private func didTapGetOTP(_ sender: UIButton) {
        guard let text = phoneTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        view.endEditing(true)
        
        if text.isEmpty {
            showToast(message: "Please enter the phone number to proceed")
            return
        } else if text.count != 10 {
            showToast(message: "Phone number should be of 10 digits")
            return
        }
        
        sender.isUserInteractionEnabled = false
        
        SVProgressHUD.show()
        let parameters: [String: Any] = [
            "mobile_no": "+91\(text)"
        ]

        AF.request("https://www.boloindya.com/api/v1/otp/send_with_country_code/", method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseString { [weak self] (responseData) in
                
                sender.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
                
                switch responseData.result {
                case.success(_):
                    self?.delegate?.didTapSignupPhoneVCNext(phone: text)
                case.failure(let error):
                    print(error)
                    self?.showToast(message: "Something went wrong. Please try again.")
                }
        }
    }
    
    @IBAction private func didTapBack(_ sender: UIButton) {
        delegate?.didTapSignupPhoneVCBack()
    }
}

extension BISignupPhoneNumberViewController: KeyboardHandler {
    func keyboardWillShow(withSize size: CGSize) {
        contentStackViewCenterConstraint.constant = 0
        contentStackViewCenterConstraint.constant -= 60
    }
    
    func keyboardWillHide() {
        contentStackViewCenterConstraint.constant = 0
    }
}

extension BISignupPhoneNumberViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let disallowedCharacterSet = NSCharacterSet(charactersIn: "0123456789").inverted
        if string.rangeOfCharacter(from: disallowedCharacterSet) != nil {
            return false
        } else {
            return true
        }
    }
}
