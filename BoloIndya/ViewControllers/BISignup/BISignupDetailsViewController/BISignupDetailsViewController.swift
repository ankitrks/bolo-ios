//
//  BISignupDetailsViewController.swift
//  BoloIndya
//
//  Created by Rahul Garg on 27/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

protocol BISignupDetailsViewControllerDelegate: class {
    func didTapSignupDetailsVCNext(model: BISignupModel?)
    func didTapSignupDetailsVCBack(model: BISignupModel?)
}

final class BISignupDetailsViewController: BaseVC {
    @IBOutlet private weak var nameStackView: UIStackView!
    
    @IBOutlet private weak var contentStackView: UIStackView!
    @IBOutlet private weak var contentStackViewCenterConstraint: NSLayoutConstraint!
    @IBOutlet private weak var nameTextfield: UITextField! {
        didSet {
            nameTextfield.delegate = self
            
            nameTextfield.setLeftPaddingPoints(15)
            nameTextfield.setRightPaddingPoints(15)
            
            nameTextfield.addDoneButtonOnKeyboard()
            nameTextfield.attributedPlaceholder = NSAttributedString(string: "Please Enter your Full Name",
                                                                      attributes: [.foregroundColor: UIColor(hex: "9A9A9A") ?? UIColor.white])
            
            nameTextfield.layer.cornerRadius = 5
            nameTextfield.layer.borderWidth = 1
            nameTextfield.layer.borderColor = (UIColor(hex: "5C5C5C") ?? UIColor.white).cgColor
            nameTextfield.clipsToBounds = true
        }
    }
    
    @IBOutlet private weak var genderStackView: UIStackView!
    @IBOutlet private weak var genderMaleViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var femaleView: UIView!
    @IBOutlet private weak var maleView: UIView!
    @IBOutlet private weak var othersView: UIView!
    
    @IBOutlet private weak var dobStackView: UIStackView!
    @IBOutlet private weak var monthView: UIView!
    @IBOutlet private weak var monthLabel: UILabel!
    @IBOutlet private weak var dayView: UIView!
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var yearView: UIView!
    @IBOutlet private weak var yearLabel: UILabel!
    
    private var datePicker: UIDatePicker?
    
    var model: BISignupModel? {
        didSet {
            if let name = model?.name, !name.isEmpty {
                nameStackView.isHidden = true
            } else if let name = model?.enteredName, !name.isEmpty {
                nameStackView.isHidden = false
                nameTextfield.text = name
            } else {
                nameStackView.isHidden = false
            }
            
            if let gender = model?.gender {
                genderStackView.isHidden = true
            } else if let gender = model?.enteredGender {
                genderStackView.isHidden = false
                
                var genderView: UIView
                
                switch gender {
                case .male: genderView = maleView
                case .female: genderView = femaleView
                case .others: genderView = othersView
                }
                
                genderView.layer.borderColor = (UIColor(hex: "10A5F9") ?? UIColor.white).cgColor
                genderView.layer.borderWidth = 2
            } else {
                genderStackView.isHidden = false
            }
            
            if let dob = model?.dob {
                dobStackView.isHidden = true
            } else if let dob = model?.enteredDob {
                dobStackView.isHidden = false
                
                monthLabel.text = dob.month()
                dayLabel.text = dob.day()
                yearLabel.text = dob.year()
            } else {
                dobStackView.isHidden = false
            }
        }
    }
    weak var delegate: BISignupDetailsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = UIScreen.main.bounds.width
        let remSpace = width - (14 * 2) - 30
        genderMaleViewWidthConstraint.constant = remSpace/3
        
        for (index, view) in [femaleView, maleView, othersView].enumerated() {
            view?.layer.cornerRadius = 5
            view?.layer.borderWidth = 1
            view?.layer.borderColor = (UIColor(hex: "5C5C5C") ?? UIColor.white).cgColor
            view?.clipsToBounds = true
            
            view?.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer.init(target: self, action: #selector(didTapGenderView(_:)))
            view?.tag = index
            view?.addGestureRecognizer(gesture)
        }
        
        for (index, view) in [monthView, dayView, yearView].enumerated() {
            view?.layer.cornerRadius = 5
            view?.layer.borderWidth = 1
            view?.layer.borderColor = (UIColor(hex: "5C5C5C") ?? UIColor.white).cgColor
            view?.clipsToBounds = true
            
            view?.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer.init(target: self, action: #selector(didTapDateView(_:)))
            view?.tag = index
            view?.addGestureRecognizer(gesture)
        }
        
        addKeyboardObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SVProgressHUD.dismiss()
    }
    
    @objc private func didTapGenderView(_ sender: UITapGestureRecognizer) {
        let views = [femaleView, maleView, othersView]
        
        guard let tag = sender.view?.tag,
              views.count > tag
            else { return }
        
        for (index, view) in views.enumerated() {
            if index == tag {
                view?.layer.borderColor = (UIColor(hex: "10A5F9") ?? UIColor.blue).cgColor
                view?.layer.borderWidth = 2
                
                model?.enteredGender = BIGender(rawValue: tag)
            } else {
                view?.layer.borderColor = (UIColor(hex: "5C5C5C") ?? UIColor.white).cgColor
                view?.layer.borderWidth = 1
            }
        }
    }
    
    @objc private func didTapDateView(_ sender: UITapGestureRecognizer) {
        let minDate = Calendar.current.date(byAdding: .year, value: -12, to: Date()) ?? Date()
        
        monthLabel.text = minDate.month()
        dayLabel.text = minDate.day()
        yearLabel.text = minDate.year()
        
        model?.enteredDob = minDate
        
        datePicker = UIDatePicker()
        datePicker?.frame = CGRect(x: 10, y: 0, width: view.bounds.width - 20, height: 240)
        datePicker?.locale = .current
        datePicker?.datePickerMode = .date
        datePicker?.date = minDate
        datePicker?.minimumDate = Calendar.current.date(byAdding: .year, value: -100, to: Date())
        datePicker?.maximumDate = minDate
        
        datePicker?.addTarget(self, action: #selector(handleDateSelection), for: .valueChanged)
        
        let dateChooserAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        dateChooserAlert.view.addSubview(datePicker!)
        dateChooserAlert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { _ in
            let selectedDate = self.datePicker?.date
            
            self.monthLabel.text = selectedDate?.month()
            self.dayLabel.text = selectedDate?.day()
            self.yearLabel.text = selectedDate?.year()
            
            self.model?.enteredDob = selectedDate
        }))
        
        if let v = dateChooserAlert.view {
            var height: NSLayoutConstraint
            if #available(iOS 13.4, *) {
                datePicker?.preferredDatePickerStyle = .wheels
                height = NSLayoutConstraint(item: v, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 270)
            } else {
                height = NSLayoutConstraint(item: v, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
            }
            
            dateChooserAlert.view.addConstraint(height)
        }
        
        present(dateChooserAlert, animated: true, completion: nil)
    }
    
    @objc private func handleDateSelection() {
        guard let selectedDate = datePicker?.date else { return }
        
        monthLabel.text = selectedDate.month()
        dayLabel.text = selectedDate.day()
        yearLabel.text = selectedDate.year()
        
        model?.enteredDob = selectedDate
    }
    
    @IBAction private func didTapSubmit(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        var fullName: String
        if let name = model?.name, !name.isEmpty {
            fullName = name
        } else if let name = nameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            if name.isEmpty {
                showToast(message: "Please enter your name to proceed")
                return
            } else if name.count < 5 {
                showToast(message: "Name is too short")
                return
            } else {
                fullName = name
            }
        } else {
            showToast(message: "Please enter your name to proceed")
            return
        }
        
        var userGender: BIGender?
        if let _ = model?.gender {
            userGender = nil
        } else if let gender = model?.enteredGender {
            userGender = gender
        } else {
            showToast(message: "Please select your gender to proceed")
            return
        }
        
        var userDob: String?
        if let _ = model?.dob {
            userDob = nil
        } else if let dob = model?.enteredDob {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = "dd/MM/YYYY"
            userDob = dateFormatter.string(from: dob)
        } else {
            showToast(message: "Please enter your Date of Birth")
            return
        }
        
        SVProgressHUD.show()
        sender.isUserInteractionEnabled = false
        
        let parameters: NSMutableDictionary = [
            "activity": "profile_save",
            "profile_pic": UserDefaults.standard.getProfilePic() ?? "",
            "cover_pic": UserDefaults.standard.getCoverPic() ?? "",
            "name": fullName,
            "bio": UserDefaults.standard.getBio() ?? "",
            "about": UserDefaults.standard.getAbout() ?? "",
            "username": UserDefaults.standard.getUsername() ?? "",
            "android_did": KeychainHelper.getDeviceId() ?? ""
        ]
        
        if let userDob = userDob {
            parameters.setValue(userDob, forKey: "d_o_b")
        }
        
        if let gender = userGender {
            parameters.setValue("\(gender.rawValue)", forKey: "gender")
        }
        
        var headers: HTTPHeaders?
        
        if let token = UserDefaults.standard.getAuthToken(), !token.isEmpty {
            headers = ["Authorization": "Bearer \(token)"]
        }
        
        AF.request(PROFILE_URL, method: .post, parameters: parameters as? Parameters, encoding: URLEncoding.default, headers: headers)
            .responseString { [weak self] (responseData) in
                
                switch responseData.result {
                case.success(let data):
                    guard let json_data = data.data(using: .utf8) else { break }
                    
                    do {
                        if let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject],
                           let loginObject = LoginUserInfo(JSON: json_object),
                           let message = loginObject.message,
                           message.lowercased() == "Profile Saved".lowercased() {
                            
                            if let id = UserDefaults.standard.getUserId2() {
                                self?.fetchuserDetails(id: "\(id)", completion: { [weak self] (userInfo, error) in
                                    if let userInfo = userInfo {
                                        self?.setDataUserInfo(info: userInfo)
                                        
                                        if let name = userInfo.user?.userprofile?.name {
                                            self?.model?.name = name
                                        } else {
                                            self?.model?.name = fullName
                                        }
                                        
                                        if let genderString = userInfo.user?.userprofile?.gender, let genderInt = Int(genderString), let gender = BIGender(rawValue: genderInt) {
                                            self?.model?.gender = gender
                                        } else {
                                            self?.model?.gender = self?.model?.enteredGender
                                            
                                            if let gender = userGender?.rawValue {
                                                UserDefaults.standard.setGender(value: "\(gender)")
                                            }
                                        }
                                        
                                        if let dob = userInfo.user?.userprofile?.dOB {
                                            let dateFormatter = DateFormatter()
                                            dateFormatter.locale = Locale.current
                                            dateFormatter.dateFormat = "dd/MM/YYYY"
                                            self?.model?.dob = dateFormatter.date(from: dob)
                                        } else {
                                            self?.model?.dob = self?.model?.enteredDob
                                            UserDefaults.standard.setDOB(value: userDob)
                                        }
                                    } else {
                                        self?.model?.name = fullName
                                        self?.model?.gender = self?.model?.enteredGender
                                        self?.model?.dob = self?.model?.enteredDob
                                    }
                                    
                                    sender.isUserInteractionEnabled = true
                                    SVProgressHUD.dismiss()
                                    
                                    self?.delegate?.didTapSignupDetailsVCNext(model: self?.model)
                                })
                            } else {
                                sender.isUserInteractionEnabled = true
                                SVProgressHUD.dismiss()
                                
                                self?.model?.name = fullName
                                self?.model?.gender = self?.model?.enteredGender
                                self?.model?.dob = self?.model?.enteredDob
                                
                                self?.delegate?.didTapSignupDetailsVCNext(model: self?.model)
                            }
                        }
                        
                        return
                    } catch {
                        print(error)
                    }
                    
                case.failure(let error):
                    print(error)
                }
                
                sender.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
                
                self?.showToast(message: "Something went wrong. Please try again.")
            }
    }
    
    @IBAction private func didTapBack(_ sender: UIButton) {
        model?.enteredName = nameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        delegate?.didTapSignupDetailsVCBack(model: model)
    }
    
    private func fetchuserDetails(id: String, completion: @escaping (_ loginInfo: LoginUserInfo?, _ error: Error?) -> Void) {
        let paramters: [String: Any] = [
            "user_id": id
        ]
        
        let url = "https://www.boloindya.com/api/v1/get_userprofile/"
        AF.request(url, method: .post, parameters: paramters, encoding: URLEncoding.default, headers: nil)
            .responseString { (responseData) in
                switch responseData.result {
                case .success(let data):
                    
                    do {
                        if let json_data = data.data(using: .utf8),
                           let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject],
                           let result = json_object["result"] as? [String: AnyObject],
                           let loginObject = LoginUser(JSON: result) {
                            var object = LoginUserInfo()
                            object?.user = loginObject
                            completion(object, nil)
                            return
                        }
                    } catch {
                        print(error)
                        completion(nil, error)
                    }
                    
                case .failure(let error):
                    print(error)
                    completion(nil, error)
                }
            }
    }
}

extension BISignupDetailsViewController: KeyboardHandler {
    func keyboardWillShow(withSize size: CGSize) {
        contentStackViewCenterConstraint.constant = 0
//        contentStackViewCenterConstraint.constant -= 40
    }
    
    func keyboardWillHide() {
        contentStackViewCenterConstraint.constant = 0
    }
}

extension BISignupDetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
