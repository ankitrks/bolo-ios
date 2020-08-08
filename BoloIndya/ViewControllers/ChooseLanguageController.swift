//
//  ChooseLanguageController.swift
//  BoloIndya
//
//  Created by apple on 7/9/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Alamofire

class ChooseLanguageController : UIViewController {

    var languages: [Languages]!

    var languageView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())

    var upper_tab = UIView()
    var back_image = UIImageView()
    var label = UILabel()
    var tick_image = UIImageView()

    var selected_position: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        selected_position = UserDefaults.standard.getValueForLanguageId() ?? 1
        
        languages = getLanguages()
            
        setView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func setView() {

        upper_tab.addSubview(back_image)
        upper_tab.addSubview(label)
        upper_tab.addSubview(tick_image)
        
        view.addSubview(upper_tab)
        
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
        
        label.text = "Choose Language"
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(setLanguage(_:)))
        tick_image.addGestureRecognizer(tapGesture)
        
        languageView.isScrollEnabled = true
        languageView.delegate = self
        languageView.dataSource = self
        languageView.backgroundColor = UIColor.black
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (languageView.frame.width/3.2), height: (languageView.frame.width/3.2 + 20))
        languageView.collectionViewLayout = layout
        
        languageView.register(LanguageCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")

        view.addSubview(languageView)
        
        languageView.translatesAutoresizingMaskIntoConstraints = false
        languageView.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 0).isActive = true
        languageView.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: 0).isActive = true
        languageView.topAnchor.constraint(equalTo: upper_tab.bottomAnchor, constant: 10).isActive = true
        languageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
    }

    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func setLanguage(_ sender: Any) {
        self.sentToTrending()
    }

    func sentToTrending() {
        
        UserDefaults.standard.setValueForLanguageId(value: selected_position)
        UserDefaults.standard.setLanguageSet(value: true)
        
        let paramters: [String: Any] = [
            "activity": "settings_changed",
            "language": "\(selected_position)"
       ]
       
       var headers: [String: Any]? = nil
       
       if !(UserDefaults.standard.getAuthToken() ?? "").isEmpty {
           headers = ["Authorization": "Bearer \( UserDefaults.standard.getAuthToken() ?? "")"]
       }
       
       let url = "https://www.boloindya.com/api/v1/fb_profile_settings/"
       
       Alamofire.request(url, method: .post, parameters: paramters, encoding: URLEncoding.default, headers: headers as? HTTPHeaders)
           .responseString  { (responseData) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
               vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false)
       }
        
    }
}

extension ChooseLanguageController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected_position = languages[indexPath.row].id
        self.languageView.reloadData()
        self.sentToTrending()
    }

    private func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return languages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LanguageCollectionViewCell
        cell.configure(with: languages[indexPath.row])
        if languages[indexPath.row].id == selected_position {
            cell.selected_image.isHidden = false
        } else {
            cell.selected_image.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/3.2), height: (collectionView.frame.width/3.2 + 20))
    }
}

