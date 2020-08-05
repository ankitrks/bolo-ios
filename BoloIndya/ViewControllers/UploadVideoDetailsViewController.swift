//
//  UploadVideoDetailsViewController.swift
//  BoloIndya
//
//  Created by apple on 8/5/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

class UploadVideoDetailsViewController: UIViewController {
    
    var image: UIImage!
    var video_url: URL!
    
    var upper_tab = UIView()
    var back_image = UIImageView()
    var label = UILabel()
    var tick_image = UIImageView()
    
    var thumb = UIImageView()
    var topic_title = UITextView()
    
    var choose_category = UILabel()
    var add_hashtag = UILabel()
    var choose_language = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        let screenSize = UIScreen.main.bounds.size
        
        upper_tab.addSubview(back_image)
        upper_tab.addSubview(label)
        upper_tab.addSubview(tick_image)
        
        view.addSubview(upper_tab)
        view.addSubview(thumb)
        view.addSubview(topic_title)
        view.addSubview(choose_category)
        view.addSubview(add_hashtag)
        view.addSubview(choose_language)
        
        upper_tab.translatesAutoresizingMaskIntoConstraints = false
        upper_tab.heightAnchor.constraint(equalToConstant: 40).isActive = true
        upper_tab.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 0).isActive = true
        upper_tab.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: 0).isActive = true
        upper_tab.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        
        upper_tab.layer.backgroundColor = #colorLiteral(red: 0.7098039216, green: 0.1568627451, blue: 0.1568627451, alpha: 0.8470588235)
        
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
        
        label.text = "Reach your audience"
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(uploadVideo(_:)))
        tick_image.addGestureRecognizer(tapGesture)
        
        thumb.translatesAutoresizingMaskIntoConstraints = false
        thumb.widthAnchor.constraint(equalToConstant: (screenSize.width*0.5)-10).isActive = true
        thumb.heightAnchor.constraint(equalToConstant: 130).isActive = true
        thumb.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        thumb.topAnchor.constraint(equalTo: upper_tab.bottomAnchor, constant: 10).isActive = true
        
        thumb.image = image
        thumb.layer.cornerRadius = (thumb.frame.height / 2)
        thumb.backgroundColor = UIColor.white
        thumb.clipsToBounds = true
        thumb.contentMode = .scaleAspectFit
        
        topic_title.translatesAutoresizingMaskIntoConstraints = false
        topic_title.widthAnchor.constraint(equalToConstant: (screenSize.width*0.5)-20).isActive = true
        topic_title.heightAnchor.constraint(equalToConstant: 130).isActive = true
        topic_title.leftAnchor.constraint(equalTo: thumb.rightAnchor, constant: 10).isActive = true
        topic_title.topAnchor.constraint(equalTo: upper_tab.bottomAnchor, constant: 10).isActive = true
        
        topic_title.isEditable = true
        topic_title.text = "What is this video about?"
        topic_title.textColor = UIColor.white
        topic_title.font = UIFont.boldSystemFont(ofSize: 12.0)
        
        choose_category.translatesAutoresizingMaskIntoConstraints = false
        choose_category.widthAnchor.constraint(equalToConstant: (screenSize.width)-20).isActive = true
        choose_category.heightAnchor.constraint(equalToConstant: 30).isActive = true
        choose_category.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        choose_category.topAnchor.constraint(equalTo: thumb.bottomAnchor, constant: 10).isActive = true
        choose_category.textColor = UIColor.white
        choose_category.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.8470588235)
        choose_category.text = "Choose Category"
        choose_category.font = UIFont.boldSystemFont(ofSize: 12.0)
        
        add_hashtag.translatesAutoresizingMaskIntoConstraints = false
        add_hashtag.widthAnchor.constraint(equalToConstant: (screenSize.width)-20).isActive = true
        add_hashtag.heightAnchor.constraint(equalToConstant: 30).isActive = true
        add_hashtag.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        add_hashtag.topAnchor.constraint(equalTo: choose_category.bottomAnchor, constant: 10).isActive = true
        add_hashtag.textColor = UIColor.white
        add_hashtag.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.8470588235)
        add_hashtag.font = UIFont.boldSystemFont(ofSize: 12.0)
        
        add_hashtag.text = "Add HashTags"
        
        choose_language.translatesAutoresizingMaskIntoConstraints = false
        choose_language.widthAnchor.constraint(equalToConstant: (screenSize.width)-20).isActive = true
        choose_language.heightAnchor.constraint(equalToConstant: 30).isActive = true
        choose_language.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        choose_language.topAnchor.constraint(equalTo: add_hashtag.bottomAnchor, constant: 10).isActive = true
        choose_language.textColor = UIColor.white
        choose_language.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.8470588235)
        choose_language.font = UIFont.boldSystemFont(ofSize: 12.0)
        
        choose_language.text = "Choose Language"
    }

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func uploadVideo(_ sender: Any) {
    
    }

    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
