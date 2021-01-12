//
//  ChooseLanguageController.swift
//  BoloIndya
//
//  Created by apple on 7/9/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Alamofire

class ChooseLanguageController : BaseVC {
    
    var languages: [Languages]!
    
    var languageView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    var upper_tab = UIView()
    var back_image = UIImageView()
    var label = UILabel()
    var tick_image = UIImageView()
    
    var loader = UIActivityIndicatorView()
    
    var isLoading = false
    
    var selected_position: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selected_position = UserDefaults.standard.getValueForLanguageId() ?? 1
        
        languages = getLanguages()
        
        setUpperTab()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setUpperTab() {
        
        upper_tab.addSubview(back_image)
        upper_tab.addSubview(label)
        upper_tab.addSubview(tick_image)
        
        view.addSubview(upper_tab)
        
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
        back_image.image = UIImage(named: "back")
        back_image.contentMode = .scaleAspectFit
        back_image.addGestureRecognizer(tapGestureBack)
        
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
        
        setLangugeView()
    }
    
    func setLangugeView() {
        
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
        
        view.addSubview(loader)
        loader.center = self.view.center
        loader.color = UIColor.white
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func setLanguage(_ sender: Any) {
        self.sentToTrending()
    }
    
    func sentToTrending() {
        
        if isLoading {
            return
        }
        
        UserDefaults.standard.setValueForLanguageId(value: languages[selected_position].id)
        UserDefaults.standard.setLanguageSet(value: true)
        
        let paramters: [String: Any] = [
            KEY_ACTIVITY: "settings_changed",
            KEY_LANGUAGE: languages[selected_position].id
        ]
        
        
        loader.isHidden = false
        loader.startAnimating()
        
        isLoading = true
        
        
        setParam(auth: true, url: PROFILE_URL , param: paramters, className: LoginUserInfo.self)
        
        let values = ["language": languages[selected_position].title]
        WebEngageHelper.trackEvent(eventName: EventName.languageSelected, values: values)
        
        WebEngageHelper.setLanguageAttribute(id: languages[selected_position].id, name: languages[selected_position].title)
    }
    
    override func onSuccessResponse(response: Any) {
        switch response {
        case is LoginUserInfo:
            setDataUserInfo(info: response as! LoginUserInfo)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
            break;
        default:
            break
        }
    }
    
}

extension ChooseLanguageController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isLoading {
            selected_position = indexPath.row
            languageView.reloadData()
            sentToTrending()
        }
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

