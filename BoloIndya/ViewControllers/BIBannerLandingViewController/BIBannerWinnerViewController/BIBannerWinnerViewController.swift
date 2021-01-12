//
//  BIBannerWinnerViewController.swift
//  BoloIndya
//
//  Created by Rahul Garg on 05/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

final class BIBannerWinnerViewController: UIViewController {
    @IBOutlet private weak var noWinnerLabel: UILabel!
    @IBOutlet private weak var winnerStackView: UIStackView!
    @IBOutlet private weak var topHeaderView: UIView!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: BIBannerWinnerTableCell.self)
            
            tableView.separatorStyle = .none
            tableView.tableFooterView = UIView()
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var banner: BICampaignModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.topHeaderView.roundedCorners([.topLeft, .topRight], radius: 20)
        }
                
        if let winners = banner?.winners, !winners.isEmpty {
            tableView.reloadData()
            
            if let winners = banner?.winners, winners.count < 5 {
                tableView.layoutIfNeeded()
                tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height).isActive = true
            }
            
            winnerStackView.isHidden = false
            noWinnerLabel.isHidden = true
        } else {
            winnerStackView.isHidden = true
            noWinnerLabel.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension BIBannerWinnerViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return banner?.winners.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: BIBannerWinnerTableCell.self, for: indexPath)
        if let winners = banner?.winners, winners.count > indexPath.row {
            cell.winner = winners[indexPath.row]
        }
        cell.delegate = self
        return cell
    }
}

extension BIBannerWinnerViewController: BIBannerWinnerTableCellDelegate {
    func didTapVideo(winner: BICampaignWinner?) {
        
    }
}
