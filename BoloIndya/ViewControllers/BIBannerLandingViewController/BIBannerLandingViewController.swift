//
//  BIBannerLandingViewController.swift
//  BoloIndya
//
//  Created by Rahul Garg on 05/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

final class BIBannerLandingViewController: UIViewController {
    @IBOutlet private weak var titleLable: UILabel!
    @IBOutlet private weak var bannerImageView: UIImageView!
    @IBOutlet private weak var viewContainer: UIView!
    
    @IBOutlet private weak var optionsView: UIView! {
        didSet {
            optionsView.layer.shadowColor = UIColor(white: 0, alpha: 0.08).cgColor
            optionsView.layer.shadowOffset = CGSize(width: 0, height: 4)
            optionsView.layer.shadowRadius = 4
//            optionsView.layer.shadowOpacity = 1
        }
    }
    @IBOutlet private weak var rulesButton: UIButton! {
        didSet {
            rulesButton.setTitleColor(UIColor(hex: "39ABFF"), for: .selected)
            rulesButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    @IBOutlet private weak var rulesLabel: UILabel!
    @IBOutlet private weak var participantsButton: UIButton! {
        didSet {
            participantsButton.setTitleColor(UIColor(hex: "39ABFF"), for: .selected)
            participantsButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    @IBOutlet private weak var participantsLabel: UILabel!
    @IBOutlet private weak var winnerButton: UIButton! {
        didSet {
            winnerButton.setTitleColor(UIColor(hex: "39ABFF"), for: .selected)
            winnerButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    @IBOutlet private weak var winnerLabel: UILabel!
    @IBOutlet private weak var createVideoButton: UIButton! {
        didSet {
            createVideoButton.layer.cornerRadius = 5
            createVideoButton.clipsToBounds = true
        }
    }
    @IBOutlet private weak var inviteButton: UIButton! {
        didSet {
            inviteButton.layer.cornerRadius = 5
            inviteButton.clipsToBounds = true
        }
    }
    
    private var pageController: UIPageViewController?
    private var currentIndex: Int = 0
    private var controllers = [UIViewController]()
    
    var banner: BICampaignModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = banner?.bannerImgURL, let url = URL(string: image) {
            bannerImageView.kf.setImage(with: url)
        }
        titleLable.text = banner?.hashtagName
        
        setupPageController()
        setPageIndexSelection(indexPage: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = true
        
        BIDeeplinkHandler.campaignHashtag2 = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setupPageController() {
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController?.dataSource = self
        pageController?.delegate = self
        pageController?.view.backgroundColor = .clear
        pageController?.view.frame = CGRect(x: 0, y: 0, width: viewContainer.frame.width, height: viewContainer.frame.height)
        addChild(self.pageController!)
        viewContainer.addSubview(self.pageController!.view)
        
        let vc1 = BIBannerRulesViewController.loadFromNib()
        vc1.banner = banner
        
        let vc2 = BIVideoCollectionViewController.loadFromNib()
        vc2.banner = banner
        
        let vc3 = BIBannerWinnerViewController.loadFromNib()
        vc3.banner = banner

        controllers.append(vc1)
        controllers.append(vc2)
        controllers.append(vc3)

        pageController?.setViewControllers([controllers[0]], direction: .forward, animated: true, completion: nil)
        pageController?.didMove(toParent: self)
    }
    
    private func setPageIndexSelection(indexPage: Int) {
        if indexPage == 0 {
            rulesButton.isSelected = true
            rulesLabel.isHidden = false
            
            participantsButton.isSelected = false
            participantsLabel.isHidden = true
            
            winnerButton.isSelected = false
            winnerLabel.isHidden = true
        } else if indexPage == 1 {
            rulesButton.isSelected = false
            rulesLabel.isHidden = true
            
            participantsButton.isSelected = true
            participantsLabel.isHidden = false
            
            winnerButton.isSelected = false
            winnerLabel.isHidden = true
        } else {
            rulesButton.isSelected = false
            rulesLabel.isHidden = true
            
            participantsButton.isSelected = false
            participantsLabel.isHidden = true
            
            winnerButton.isSelected = true
            winnerLabel.isHidden = false
        }
    }
    
    @IBAction private func didTapRulesButton(_ sender: UIButton) {
        pageController?.setViewControllers([controllers[0]], direction: .reverse, animated: true, completion: nil)
        setPageIndexSelection(indexPage: 0)
    }
    
    @IBAction private func didTapParticipantsButton(_ sender: UIButton) {
        pageController?.setViewControllers([controllers[1]], direction: .forward, animated: true, completion: nil)
        setPageIndexSelection(indexPage: 1)
    }
    
    @IBAction private func didTapWinnerButton(_ sender: UIButton) {
        pageController?.setViewControllers([controllers[2]], direction: .forward, animated: true, completion: nil)
        setPageIndexSelection(indexPage: 2)
    }
    
    @IBAction private func didTapCreateVideoButton(_ sender: UIButton) {
        guard let hashtag = banner?.hashtagName,
              !hashtag.isEmpty
            else { return }
        
        BIDeeplinkHandler.campaignHashtag2 = hashtag
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateVideoViewController") as! CreateVideoViewController
        vc.isFromCampaign = true
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true, completion: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func didTapInviteButton(_ sender: UIButton) {
        guard let hashtag = banner?.hashtagName,
              !hashtag.isEmpty
            else { return }
        
        let text = "Did you participate in Bolo Indya's \(hashtag) campaign yet? If not, then what are you waiting for? Participate in this campaign by making a video and win exciting prizes! Check out this link for rules. 😍"
        let link = "https://www.boloindya.com/campaign/\(hashtag)"
        let urlString = "\(text)\n\n\(link)"
        
        guard let urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.whatsapp.com/send?text=\(urlStringEncoded)"),
              UIApplication.shared.canOpenURL(url)
            else { return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction private func didTapBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension BIBannerLandingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController) {
            if index > 0 {
//                setPageIndexSelection(indexPage: index-1)
                return controllers[index - 1]
            } else {
                return nil
            }
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController) {
            if index < controllers.count - 1 {
//                setPageIndexSelection(indexPage: index+1)
                return controllers[index + 1]
            } else {
                return nil
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentViewController = pageViewController.viewControllers?.first,
               let index = controllers.firstIndex(of: currentViewController) {
                setPageIndexSelection(indexPage: index)
            }
        }
    }
}
