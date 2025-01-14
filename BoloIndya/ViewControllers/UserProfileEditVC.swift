//
//  UserProfileEditVC.swift
//  BoloIndya
//
//  Created by Mushareb on 30/08/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import YPImagePicker
import Alamofire
import AVFoundation
import SVProgressHUD
import Kingfisher

protocol UserProfileEdittProtocal {
    func reloadPage()
}

class UserProfileEditVC: UIViewController {
    @IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var tvName: UITextField!
    @IBOutlet weak var tvUsername: UITextField!
    @IBOutlet weak var tvBio: UITextField!
    var user_id: Int = 0
    var delegate:UserProfileEdittProtocal?
    var user:User!
    var reload:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = false

        tvName.attributedPlaceholder = NSAttributedString(string: "Name",
                                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        tvUsername.attributedPlaceholder = NSAttributedString(string: "Username",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        tvBio.attributedPlaceholder = NSAttributedString(string: "Bio",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        profile_image.makeRounded()
        setData()


    }

    func setData() {
        tvName.text = "\(user.name)"
        tvUsername.text = "\(user.username)"
        tvBio.text = "\(user.bio)"
        if !user.profile_pic.isEmpty {
            let url = URL(string: user.profile_pic)
            profile_image.kf.setImage(with: url, placeholder: UIImage(named: "user"))
        } else {
            profile_image.image = UIImage(named: "user")
        }
    }

    private func initTabBarProfileImage() {
        if let pic = UserDefaults.standard.getProfilePic(),
           !pic.isEmpty,
           let url = URL(string: pic),
           let count = tabBarController?.tabBar.items?.count,
           count > 4 {
            
            let item = tabBarController?.tabBar.items?[4]
            
//            if ImageCache.default.isCached(forKey: url.absoluteString) {
//                item?.selectedImage = nil
//                item?.image = nil
//            }
            
            let imageSize: CGFloat = 24
            let processor = ResizingImageProcessor(referenceSize: CGSize(width: imageSize, height: imageSize)) |> RoundCornerImageProcessor(cornerRadius: imageSize/2)
            let resource = ImageResource(downloadURL: url)
            KingfisherManager.shared.retrieveImage(with: resource, options: [.processor(processor),
                                                                             .scaleFactor(UIScreen.main.scale),
                                                                             .cacheOriginalImage])
            { (result) in
                switch result {
                case .success(let value):
                    let image = value.image
                    item?.selectedImage = image.withRenderingMode(.alwaysOriginal)
                    item?.image = image.withRenderingMode(.alwaysOriginal)
                    
                case .failure(let error):
                    print("Error: \(error)")
//                    item?.selectedImage = UIImage(named: "user")
//                    item?.image = UIImage(named: "user")
                }
            }
        }
    }

    

    @IBAction func onBack(_ sender: Any) {
        if reload == true {
            delegate?.reloadPage()
        }

        self.navigationController?.popViewController(animated: true)

    }
    @IBAction func editImage(_ sender: Any) {
        imagePicker()
    }

    @IBAction func onSubmit(_ sender: Any) {
        profileUpdate(imageUrl: nil)
    }

    func imagePicker() {
        var config = YPImagePickerConfiguration()
        config.showsCrop = .none
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                //                print(photo.fromCamera) // Image source (camera or library)
                //                print(photo.image) // Final image selected by the user
                //                print(photo.originalImage) // original image selected by the user, unfiltered
                //                print(photo.modifiedImage) // Transformed image, can be nil
                //                print(photo.exifMeta)
                self.profile_image.image = photo.image
                self.uploadImage()

                // Print exif meta data of original image.
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }

    func uploadImage() {

        var headers: HTTPHeaders!
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
            headers = [
                "Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }

        //  let image = UIImage.init(named: "whatsapp")
        let imageData = self.profile_image.image?.jpegData(compressionQuality: 1)

        let timeStamp = Int(NSDate().timeIntervalSince1970)

        let file_name = "\(timeStamp).jpeg"

        DispatchQueue.main.async {
            SVProgressHUD.show(withStatus:  "Uploding..")
        }
        
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData!, withName: "file", fileName: file_name, mimeType: "image/jpg")
        }, to: "https://www.boloindya.com/api/v1/upload_profile_image", method: .post, headers: headers)
        .responseJSON(completionHandler: { response in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            if let json_data = response.data {
                do {
                    if let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: Any] {
                        if !(json_object["body"] as? String ?? "").isEmpty {

                            print(json_object["body"] as! String)
                            self.profileUpdate(imageUrl: json_object["body"] as? String)
                            
                            UserDefaults.standard.setProfilePic(value: json_object["body"] as? String)
                            
                            self.initTabBarProfileImage()
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
            }
        })
    }


    func profileUpdate(imageUrl:String?) {
        tvName.endEditing(true)
        tvBio.endEditing(true)
        tvUsername.endEditing(true)
        
        var headers: HTTPHeaders!
        if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
            headers = [
                "Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
        }
        
        let paramters: [String: Any]
        if imageUrl == nil {
            paramters = [
                // "user_id": "\(UserDefaults.standard.getUserId().unsafelyUnwrapped)",
                "activity":"profile_save",
                "name": tvName.text ?? "",
                "bio": tvBio.text ?? "",
                "username": tvUsername.text ?? "",
            ]
        } else {
            paramters = [
                // "user_id": "\(UserDefaults.standard.getUserId().unsafelyUnwrapped)",
                "activity":"profile_save",
                "profile_pic": imageUrl ?? ""

            ]
        }
        
        DispatchQueue.main.async {
            SVProgressHUD.show(withStatus:  "Please wait..")
        }

        let url = "https://www.boloindya.com/api/v1/fb_profile_settings/"

        AF.request(url, method: .post, parameters: paramters, encoding: URLEncoding.default, headers: headers)
            .responseString  { (responseData) in
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
                switch responseData.result {

                case.success(let data):
                    if let json_data = data.data(using: .utf8) {

                        do {
                            let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                            //  if let result = json_object?["message"] as? [String:Any] {
                            self.reload = true
                            self.showToast(message: json_object?["message"] as! String)

                        }
                        catch {
                            //  self.isLoading = false
                            // self.fetchData()
                            print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    // self.isLoading = false
                    //self.fetchData()
                    print(error)
                }
        }
    }

}
