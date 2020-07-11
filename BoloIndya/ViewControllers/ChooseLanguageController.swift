//
//  ChooseLanguageController.swift
//  BoloIndya
//
//  Created by apple on 7/9/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

class ChooseLanguageController: UIViewController {
    
    @IBAction func chooseLanguage(_ sender: UIButton) {
        UserDefaults.standard.setValueForLanguageId(value: sender.tag)
        sentToTrending()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ChooseLanguage")
        // Do any additional setup after loading the view.
    }
    
    func sentToTrending() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
    
}
