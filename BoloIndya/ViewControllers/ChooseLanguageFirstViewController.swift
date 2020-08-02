//
//  ChooseLanguageFirstViewController.swift
//  BoloIndya
//
//  Created by apple on 7/25/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

class ChooseLanguageFirstViewController: UIViewController {
    
    var languages: [Languages] = []
    
    var languageView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    @IBAction func chooseLanguage(_ sender: UIButton) {
        UserDefaults.standard.setValueForLanguageId(value: sender.tag)
        UserDefaults.standard.setLanguageSet(value: true)
        sentToTrending()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLanguage()
            
        languageView.isScrollEnabled = true
        languageView.delegate = self
        languageView.dataSource = self
        languageView.backgroundColor = UIColor.black

        let screenSize = UIScreen.main.bounds.size
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (screenSize.width/3.2), height: (screenSize.width/3.2))
        languageView.collectionViewLayout = layout

        languageView.register(LanguageCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")

        view.addSubview(languageView)

        languageView.translatesAutoresizingMaskIntoConstraints = false
        languageView.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        languageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        languageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
    }
    
    func sentToTrending() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
    
    func setLanguage() {
            
        var language = Languages()
        language.id = 2
        language.title = "Hindi"
        language.image = "hindi"
        
        languages.append(language)
        
        language = Languages()
        language.id = 3
        language.title = "Tamil"
        language.image = "tamil"
        
        languages.append(language)
        
        language = Languages()
        language.id = 4
        language.title = "Telugu"
        language.image = "telugu"
        
        languages.append(language)
        
        language = Languages()
        language.id = 5
        language.title = "Kannada"
        language.image = "kanada"
        
        languages.append(language)
        
        language = Languages()
        language.id = 6
        language.title = "Bengali"
        language.image = "bengali"
        
        languages.append(language)
        
        language = Languages()
        language.id = 7
        language.title = "Marathi"
        language.image = "marathi"
        
        languages.append(language)
        
        language = Languages()
        language.id = 8
        language.title = "Gujrati"
        language.image = "gujrati"
        
        languages.append(language)
        
        language = Languages()
        language.id = 9
        language.title = "Malayalam"
        language.image = "malayalam"

        languages.append(language)
        
        language = Languages()
        language.id = 10
        language.title = "Punjabi"
        language.image = "punjabi"

        languages.append(language)
        
        language = Languages()
        language.id = 11
        language.title = "Oriya"
        language.image = "oriya"

        languages.append(language)
        
        language = Languages()
        language.id = 12
        language.title = "Bhojpuri"
        language.image = "bhojpuri"

        languages.append(language)
        
        
        language = Languages()
        language.id = 13
        language.title = "Haryanvi"
        language.image = "harayanvi"

        languages.append(language)
        
        language = Languages()
        language.id = 1
        language.title = "English"
        language.image = "english"
        
        languages.append(language)
        
        language = Languages()
        language.id = 14
        language.title = "Sinhala"
        language.image = "sinhala"

        languages.append(language)
    }
        
}

extension ChooseLanguageFirstViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return languages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LanguageCollectionViewCell
        cell.configure(with: languages[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/3.2), height: (collectionView.frame.width/3.2))
    }
}
