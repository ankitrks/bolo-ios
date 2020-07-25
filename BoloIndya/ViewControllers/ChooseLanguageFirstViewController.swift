//
//  ChooseLanguageFirstViewController.swift
//  BoloIndya
//
//  Created by apple on 7/25/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

class ChooseLanguageFirstViewController: UIViewController {
    
    @IBAction func chooseLanguage(_ sender: UIButton) {
        UserDefaults.standard.setValueForLanguageId(value: sender.tag)
        UserDefaults.standard.setLanguageSet(value: true)
        sentToTrending()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func sentToTrending() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
}
