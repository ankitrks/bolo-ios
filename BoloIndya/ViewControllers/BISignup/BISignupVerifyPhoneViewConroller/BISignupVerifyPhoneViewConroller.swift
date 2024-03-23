//
//  BISignupVerifyPhoneViewConroller.swift
//  BoloIndya
//
//  Created by Rahul Garg on 27/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

protocol BISignupVerifyPhoneViewConrollerDelegate: class {
    func didTapSignupVerifyPhoneVCNext(object: BISignupModel?)
    func didTapSignupVerifyPhoneVCBack()
}

final class BISignupVerifyPhoneViewConroller: BaseVC {
    private enum Direction {
        case left
        case right
    }
    
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
            phoneTextfield.isUserInteractionEnabled = false
            
            phoneTextfield.setLeftPaddingPoints(15)
        }
    }
    @IBOutlet private var textFieldsOutletCollection: [BIOTPTextField]!
    @IBOutlet private weak var otpButton: UIButton!
    
    private var textFieldsIndexes: [UITextField:Int] = [:]
    
    var model: BISignupModel? {
        didSet {
            phoneTextfield.text = model?.phone
        }
    }
    weak var delegate: BISignupVerifyPhoneViewConrollerDelegate?
    
    private var otpTimer: Timer?
    private var otpCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldsOutletCollection = textFieldsOutletCollection.sorted(by: { $0.tag < $1.tag})
        
        for tf in textFieldsOutletCollection {
            tf.attributedPlaceholder = NSAttributedString(string: "0",
                                                          attributes: [.foregroundColor: UIColor(hex: "9A9A9A") ?? UIColor.white])
            tf.delegate = self
            tf.textFieldDelegate = self
            
            tf.maxLength = 1
            tf.addDoneButtonOnKeyboard()
            
            tf.layer.cornerRadius = 3
            tf.layer.borderWidth = 1
            tf.layer.borderColor = (UIColor(hex: "5C5C5C") ?? UIColor.white).cgColor
            tf.clipsToBounds = true
        }
        
        for index in 0..<textFieldsOutletCollection.count {
            textFieldsIndexes[textFieldsOutletCollection[index]] = index
        }
        
        addKeyboardObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let _ = textFieldsOutletCollection.compactMap { return $0.text = nil }
        
        otpButton.setAttributedTitle(NSAttributedString(string: "Resend OTP"), for: .normal)
        otpButton.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.textFieldsOutletCollection.first?.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        resignFirstResponder()
        
        otpTimer?.invalidate()
        otpTimer = nil
    }
    
    private func setNextResponder(_ index: Int?, direction: Direction) {
        guard let index = index else { return }

        if direction == .left {
            index == 0 ?
                (_ = textFieldsOutletCollection.first?.resignFirstResponder()) :
                (_ = textFieldsOutletCollection[(index - 1)].becomeFirstResponder())
        } else {
            index == textFieldsOutletCollection.count - 1 ?
                (_ = textFieldsOutletCollection.last?.resignFirstResponder()) :
                (_ = textFieldsOutletCollection[(index + 1)].becomeFirstResponder())
        }
    }
    
    @IBAction private func didTapEditPhone(_ sender: UIButton) {
        delegate?.didTapSignupVerifyPhoneVCBack()
    }
    
    @IBAction private func didTapNext(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let otpArray = textFieldsOutletCollection.compactMap { return $0.text?.trimmingCharacters(in: .whitespacesAndNewlines) }.filter{ !$0.isEmpty }
        let otp = otpArray.joined()
        
        if otp.isEmpty {
            showToast(message: "Please enter the OTP sent on the mobile number")
            return
        } else if otp.count != 6 {
            showToast(message: "Please enter the complete 6 digit OTP sent on the mobile number")
            return
        }
        
        guard let mobile = model?.phone?.trimmingCharacters(in: .whitespacesAndNewlines),
              !mobile.isEmpty
            else { return }
        
        sender.isUserInteractionEnabled = false
        
        SVProgressHUD.show()
        let parameters: [String: Any] = [
            "mobile_no": "\(mobile)",
            "otp": "\(otp)",
            "country_code": "+91",
            "language": UserDefaults.standard.getValueForLanguageId() ?? "2" as String
        ]

        AF.request(OTP_VERIFY_URL, method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseString { [weak self] (responseData) in
                
                sender.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
                
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                        do {
                            if let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject],
                               let loginObject = LoginUserInfo(JSON: json_object),
                               let access = loginObject.accessToken,
                               !access.isEmpty {
                                self?.setDataUserInfo(info: loginObject)
                                
                                let name = loginObject.user?.userprofile?.name
                                
                                self?.model?.otp = otp
                                self?.model?.name = name
                                
                                if let genderString = loginObject.user?.userprofile?.gender, let genderInt = Int(genderString), let gender = BIGender(rawValue: genderInt) {
                                    self?.model?.gender = gender
                                }
                                
                                if let dob = loginObject.user?.userprofile?.dOB {
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.locale = Locale.current
                                    dateFormatter.dateFormat = "dd/MM/yyyy"
                                    self?.model?.dob = dateFormatter.date(from: dob)
                                }
                                
                                let isSignup = loginObject.message?.lowercased() == "user created"
                                
                                self?.model?.type = isSignup ? .signup : .login
                                
                                self?.delegate?.didTapSignupVerifyPhoneVCNext(object: self?.model)
                                
                                let eventName = isSignup ? EventName.signUp : EventName.login
                                let values = ["mobile": mobile,
                                              "mode": "mobile"]
                                WebEngageHelper.trackEvent(eventName: eventName, values: values)
                                
                                break
                            } else {
                                self?.showToast(message: "Please enter a valid otp")
                            }
                            
                            return
                        } catch {
                            print(error)
                        }
                    }
                    
                case.failure(let error):
                    print(error)
                }
                
                self?.showToast(message: "Something went wrong. Please try again.")
        }
    }
    
    @IBAction private func didTapResend(_ sender: UIButton) {
        guard let phone = model?.phone?.trimmingCharacters(in: .whitespacesAndNewlines),
              !phone.isEmpty
            else { return }
        
        view.endEditing(true)
        
        showToast(message: "An OTP is sent on your mobile number")
        
        otpButton.isUserInteractionEnabled = false
        otpButton.setAttributedTitle(NSAttributedString(string: "OTP sent. Please wait for 20 seconds"), for: .normal)
        
        otpTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [unowned self] _ in
            self.otpCount += 1
            
            if self.otpCount == 20 {
                self.otpCount = 0
                
                self.otpTimer?.invalidate()
                self.otpTimer = nil
                
                self.otpButton.setAttributedTitle(NSAttributedString(string: "Resend OTP"), for: .normal)
                
                self.otpButton.isUserInteractionEnabled = true
            } else {
                var text: String
                
                let diff = 20 - self.otpCount
                if diff == 0 {
                    text = "OTP sent. Please wait for \(diff) second"
                } else if diff == 1 {
                    text = "OTP sent. Please wait for 1 second"
                } else {
                    text = "OTP sent. Please wait for \(diff) seconds"
                }
                
                self.otpButton.setAttributedTitle(NSAttributedString(string: text), for: .normal)
                self.otpButton.isUserInteractionEnabled = false
            }
        })
        
        let parameters: [String: Any] = [
            "mobile_no": "+91\(phone)"
        ]

        AF.request("https://www.boloindya.com/api/v1/otp/send_with_country_code/", method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseString { (responseData) in
//                switch responseData.result {
//                case.success(_):
//                    break
//                case.failure(let error):
//                    print(error)
//                }
        }
    }
    
    @IBAction private func didTapBack(_ sender: UIButton) {
        delegate?.didTapSignupVerifyPhoneVCBack()
    }
}

extension BISignupVerifyPhoneViewConroller: KeyboardHandler {
    func keyboardWillShow(withSize size: CGSize) {
        contentStackViewCenterConstraint.constant = 0
        contentStackViewCenterConstraint.constant -= 120
    }
    
    func keyboardWillHide() {
        contentStackViewCenterConstraint.constant = 0
    }
}

extension BISignupVerifyPhoneViewConroller: UITextFieldDelegate, BIOTPTextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidDelete(_ textField: UITextField) {
        if textField.tag > 0, textFieldsOutletCollection.count > (textField.tag - 1) {
            textFieldsOutletCollection[textField.tag - 1].text = ""
            setNextResponder(textFieldsIndexes[textField], direction: .left)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let disallowedCharacterSet = NSCharacterSet(charactersIn: "0123456789").inverted
        if string.rangeOfCharacter(from: disallowedCharacterSet) != nil {
            return false
        }
//
        //while auto reading otp and selecting from quick bar, first two fields are empty. this workaround fixes the problem
        if string.isEmpty, let text = textField.text, text.isEmpty {
            return false
        }
        
        if let _ = string.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines) {
            print("OTPViewController: Invalid Character Inserted : \(string)")
            return false
        }
        
        
        if range.length == 0 {
            
            //if user taps backspace and enter some text
            // - if now-textfield(previous) is empty, text should be updated
            // - if now-textfield(previous) is non-empty, text should be updated on the next textfield not the now-textfield(previous)
            
            // below if code is for 2 scenario, else is for 1 scenario
            
            if let text = textField.text, !text.isEmpty {
                if textFieldsOutletCollection.count > (textField.tag + 1) {
                    let nextTF = textFieldsOutletCollection[textField.tag + 1]
                    nextTF.text = string
                }
            } else {
                textField.text = string
            }
            
            setNextResponder(textFieldsIndexes[textField], direction: .right)
            return true
        } else if range.length == 1 {
            setNextResponder(textFieldsIndexes[textField], direction: .left)
            textField.text = ""
            return false
        }
        
        return false
    }
}
