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

final class LoginAndSignUpViewController: BaseVC {
    @IBOutlet private weak var viewContainer: UIView!
    
    @IBOutlet private var bottomTabsView: [UIView]! {
        didSet {
            for tab in bottomTabsView {
                tab.layer.cornerRadius = tab.bounds.height/2
                tab.clipsToBounds = true
            }
        }
    }
    
    private var pageController: UIPageViewController?
    private var currentIndex: Int = 0
    private var controllers = [UIViewController]()
    
    private lazy var signupVC: BISignupViewController = {
       let vc = BISignupViewController.loadFromNib()
        vc.delegate = self
        return vc
    }()
    
    private lazy var phoneVC: BISignupPhoneNumberViewController = {
       let vc = BISignupPhoneNumberViewController.loadFromNib()
        vc.delegate = self
        return vc
    }()
    
    private lazy var verifyVC: BISignupVerifyPhoneViewConroller = {
       let vc = BISignupVerifyPhoneViewConroller.loadFromNib()
        vc.delegate = self
        return vc
    }()
    
    private lazy var detailsVC: BISignupDetailsViewController = {
       let vc = BISignupDetailsViewController.loadFromNib()
        vc.delegate = self
        return vc
    }()
    
    private var model = BISignupModel()
    
    var selected_tab = 1
    
    private var current_page = "terms_and_condition"
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        GIDSignIn.sharedInstance().clientID = "581293693346-tphkhhes9a84ohf929cqt1l5vaerm3rr.apps.googleusercontent.com"
//        GIDSignIn.sharedInstance().delegate = self
//
//        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        bottomTabsView = bottomTabsView.sorted(by: { $0.tag < $1.tag})
        
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//        pageController?.dataSource = self
        pageController?.delegate = self
        pageController?.view.backgroundColor = .clear
        pageController?.view.frame = CGRect(x: 0, y: 0, width: viewContainer.frame.width, height: viewContainer.frame.height)
        addChild(pageController!)
        viewContainer.addSubview(pageController!.view)
        
        controllers.append(signupVC)
        controllers.append(phoneVC)
        controllers.append(verifyVC)
        controllers.append(detailsVC)
 
        pageController?.setViewControllers([controllers[currentIndex]], direction: .forward, animated: true, completion: nil)
        pageController?.didMove(toParent: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is TermsPagesViewController {
           let vc = segue.destination as? TermsPagesViewController
           vc?.current_page = current_page
        }
    }
    
    private func dismissView() {
        if navigationController == nil {
            dismiss(animated: true, completion: nil)
        } else if selected_tab == 0 {
            navigationController?.popViewController(animated: true)
        } else {
            tabBarController?.selectedIndex = 0
        }
    }
    
    private func sentToTrending() {
        guard let rootVC = storyboard?.instantiateViewController(withIdentifier: "MainViewController") else { return }
        
        UIApplication.shared.currentWindow?.rootViewController?.dismiss(animated: false, completion: nil)
        
        let rootNC = UINavigationController(rootViewController: rootVC)
        UIApplication.shared.currentWindow?.rootViewController = rootNC
        UIApplication.shared.currentWindow?.makeKeyAndVisible()
    }
    
    private func setPageIndexSelection(direction: UIPageViewController.NavigationDirection) {
        guard bottomTabsView.count > currentIndex else { return }
        
        for (index, view) in bottomTabsView.enumerated() {
            if index == currentIndex {
                view.backgroundColor = UIColor(hex: "10A5F9")
            } else {
                view.backgroundColor = UIColor(hex: "393636")
            }
        }
        
        pageController?.setViewControllers([controllers[currentIndex]], direction: direction, animated: true, completion: nil)
    }
    
    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
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
    
    override func onSuccessResponse(response: Any, resultCode: Int = 0) {
        //if(resultCode == 2){
//
//            if let userInfo = response as? LoginUserInfo,
//               let access = userInfo.accessToken,
//               !access.isEmpty {
//                setDataUserInfo(info: userInfo)
//                sentToTrending()
//
//                let isSignup = userInfo.message?.lowercased() == "user created"
//                let eventName = isSignup ? EventName.signUp : EventName.login
//                let values = ["mobile": mobile_no.text ?? "",
//                              "mode": "mobile"]
//                WebEngageHelper.trackEvent(eventName: eventName, values: values)
//            } else {
//                showToast(message: "Please enter valid otp"  )
//            }
   // }
    }

    override func onFailResponse(response: Error) {
         print(response.localizedDescription)
    }
}

extension LoginAndSignUpViewController: UIPageViewControllerDelegate {
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        if let index = controllers.firstIndex(of: viewController) {
//            //setPageIndexSelection(indexPage: index)
//            if index > 0 {
//                return controllers[index - 1]
//            } else {
//                return nil
//            }
//        }
//        return nil
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        if let index = controllers.firstIndex(of: viewController) {
//            //setPageIndexSelection(indexPage: index)
//            if index < controllers.count - 1 {
//                return controllers[index + 1]
//            } else {
//                return nil
//            }
//        }
//        return nil
//    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentViewController = pageViewController.viewControllers?.first,
               let index = controllers.firstIndex(of: currentViewController) {
                currentIndex = index
                setPageIndexSelection(direction: .forward)
            }
        }
    }
}

extension LoginAndSignUpViewController: BISignupViewControllerDelegate {
    func didTapSignupVCNext() {
        currentIndex = 1
        setPageIndexSelection(direction: .forward)
    }
    
    func didTapSignupVCBack() {
        currentIndex = 0
        setPageIndexSelection(direction: .reverse)
        
        dismissView()
    }
}

extension LoginAndSignUpViewController: BISignupPhoneNumberViewControllerDelegate {
    func didTapSignupPhoneVCNext(phone: String) {
        model.phone = phone
        
        currentIndex = 2
        setPageIndexSelection(direction: .forward)
        
        verifyVC.model = model
    }
    
    func didTapSignupPhoneVCBack() {
        currentIndex = 0
        setPageIndexSelection(direction: .reverse)
    }
}

extension LoginAndSignUpViewController: BISignupVerifyPhoneViewConrollerDelegate {
    func didTapSignupVerifyPhoneVCNext(object: BISignupModel?) {
        if let model = object {
            self.model = model
        }
        
        if let name = model.name, !name.isEmpty, let gender = model.gender, let dob = model.dob {
            dismissView()
            
            sentToTrending()
            
            UserDefaults.standard.setLoggedIn(value: true)
        } else {
            currentIndex = 3
            setPageIndexSelection(direction: .forward)
            
            detailsVC.model = model
        }
    }
    
    func didTapSignupVerifyPhoneVCBack() {
        currentIndex = 1
        setPageIndexSelection(direction: .reverse)
    }
}

extension LoginAndSignUpViewController: BISignupDetailsViewControllerDelegate {
    func didTapSignupDetailsVCNext(model: BISignupModel?) {
        if let model = model {
            self.model = model
        }
        
        dismissView()
        
        sentToTrending()
        
        UserDefaults.standard.setLoggedIn(value: true)
        
        if model?.type == .signup, RemoteConfigHelper.shared.isShowGaanaSignup() {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                NotificationCenter.default.post(name: .init("showGaanaOfferView"), object: nil)
            }
        }
    }
    
    func didTapSignupDetailsVCBack(model: BISignupModel?) {
        if let model = model {
            self.model = model
        }
        
        currentIndex = 2
        setPageIndexSelection(direction: .reverse)
    }
}

extension LoginAndSignUpViewController : GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard let authentication = user.authentication else {
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            let user = Auth.auth().currentUser
            if let user = user {
                let userid = user.uid
                BranchHelper().setId(userId: userid)
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
}
