//
//  TrendingAndFollowingViewController.swift
//  BoloIndya
//
//  Created by apple on 7/10/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

class TrendingAndFollowingViewController: UIViewController {
    
    @IBOutlet weak var profile: UIButton!
    
    @IBOutlet weak var notification: UIButton!
    
    @IBOutlet weak var discover: UIButton!
    
    @IBOutlet weak var trendingView: UITableView!
    
    var videos: [Topic] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Trending")
        videos = fetchData()
        setTrendingViewDelegate()
    }
    
    func setTrendingViewDelegate() {
        trendingView.delegate = self
        trendingView.dataSource = self
    }
    
    @IBAction func goToNextScreens(_ sender: UIButton) {
        let isLoggedIn = UserDefaults.standard.isLoggedIn() ?? false
        switch(sender) {
        case profile:
            if (isLoggedIn) {
            goToCurrentUSerProfile()
            } else {
                goToLoginPage()
            }
            break
        case notification:
            if (isLoggedIn) {
                goToNotification()
            } else {
                goToLoginPage()
            }
            break
        case discover:
            goToDiscoverPage()
            break
        default:
            break
        }
    }
    
    func goToNotification() {
        let vc = storyboard?.instantiateViewController(identifier: "NotificationViewController") as! NotificationViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
    
    func goToCurrentUSerProfile() {
        let vc = storyboard?.instantiateViewController(identifier: "CurrentUserViewController") as! CurrentUserViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
    
    func goToDiscoverPage() {
        let vc = storyboard?.instantiateViewController(identifier: "DiscoverViewController") as! DiscoverViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
    
    func goToLoginPage() {
       let vc = storyboard?.instantiateViewController(identifier: "LoginAndSignUpViewController") as! LoginAndSignUpViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
}


extension TrendingAndFollowingViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let video_cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as! VideoCell
        return video_cell
    }
    
}

extension TrendingAndFollowingViewController {
    
    func fetchData() -> [Topic] {
        let topic = Topic(user: User())
        topic.setTitle(title: "Test 1")
        let topic1 = Topic(user: User())
        topic1.setTitle(title: "Test 1")
        return [topic, topic1]
    }
}
