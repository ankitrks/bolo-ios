//
//  DiscoverBannerTableCell.swift
//  BoloIndya
//
//  Created by Rahul Garg on 05/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

protocol DiscoverBannerTableCellDelegate: class {
    func goToBanner(banner: BICampaignModel)
}


final class DiscoverBannerTableCell: UITableViewCell {
    var banner = [BICampaignModel]()
    var userVideoView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var bannerTimer: Timer?
    private var selectedBannerTimerIndex = 0

    weak var delegate: DiscoverBannerTableCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = true
        
        selectionStyle = .none
        backgroundColor = UIColor.black
        
        addSubview(userVideoView)
        
        let height = CGFloat(0.3797) * UIScreen.main.bounds.width
        
        let screenSize = UIScreen.main.bounds.size
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: screenSize.width - 20, height: height)
        userVideoView.collectionViewLayout = layout
        userVideoView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: height)
        userVideoView.showsHorizontalScrollIndicator = false
        userVideoView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        userVideoView.isPagingEnabled = true
        userVideoView.delegate = self
        userVideoView.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(banner: [BICampaignModel]) {
        self.banner = banner
        
        var height: CGFloat
        if !banner.isEmpty {
            height = CGFloat(0.3797) * UIScreen.main.bounds.width
            
            userVideoView.reloadData()
            userVideoView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        } else {
            height = CGFloat.leastNormalMagnitude
        }
        
        userVideoView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
        
        bannerTimer?.invalidate()
        bannerTimer = nil
        
        selectedBannerTimerIndex = 0
        
        if banner.count > 1 {
            bannerTimer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true, block: { (_) in
                if banner.count > self.selectedBannerTimerIndex + 1 {
                    self.selectedBannerTimerIndex += 1
                } else {
                    self.selectedBannerTimerIndex = 0
                }
                
                if self.userVideoView.numberOfItems(inSection: 0) > self.selectedBannerTimerIndex {
                    self.userVideoView.scrollToItem(at: IndexPath(item: self.selectedBannerTimerIndex, section: 0), at: .top, animated: true)
                }
            })
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if banner.count > selectedBannerTimerIndex + 1 {
            selectedBannerTimerIndex += 1
        } else {
            selectedBannerTimerIndex = 0
        }
    }
}

extension DiscoverBannerTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.banner.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BannerCollectionViewCell
        if indexPath.item < banner.count {
            cell.configure(with: banner[indexPath.row].bannerImgURL)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.goToBanner(banner: banner[indexPath.item])
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = banner.isEmpty ? CGFloat.leastNormalMagnitude : CGFloat(0.3797) * UIScreen.main.bounds.width
        return CGSize(width: collectionView.frame.width - 10, height: height)
    }
}
