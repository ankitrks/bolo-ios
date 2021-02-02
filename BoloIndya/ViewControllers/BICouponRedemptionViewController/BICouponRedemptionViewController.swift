//
//  BICouponRedemptionViewController.swift
//  BoloIndya
//
//  Created by Rahul Garg on 01/02/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

final class BICouponRedemptionViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.showsVerticalScrollIndicator = false
            tableView.isPagingEnabled = true
            tableView.separatorStyle = .none
            
            tableView.register(cellType: BICouponRedemptionTableCell.self)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    private var dataModel: BIRedeemedCouponsResultNextCountModel?
    private var results = [BIRedeemedCouponResultModel]()
    
    private var isLoading = false
    private var isLastPageReached = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "All Redemptions"
        
        SVProgressHUD.show()
        fetchCoupons(isFirstTime: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SVProgressHUD.dismiss()
    }
    
    private func fetchCoupons(isFirstTime: Bool = false) {
        var url: String
        if isFirstTime {
            url = "https://www.boloindya.com/api/v1/marketing/brand-partner/order/"
        } else if let next = dataModel?.next, !next.isEmpty {
            url = next
        } else {
            return
        }

        isLoading = true
        
        var headers: HTTPHeaders? = nil
        if let token = UserDefaults.standard.getAuthToken(), !token.isEmpty {
            headers = ["Authorization": "Bearer \(token)"]
        }
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseString { [weak self] (responseData) in
                
                self?.isLoading = false
                SVProgressHUD.dismiss()
                
                switch responseData.result {
                case.success(let data):
                    guard let json_data = data.data(using: .utf8) else { return }
                    
                    do {
                        let model = try JSONDecoder().decode(BIRedeemedCouponsResultNextCountModel.self, from: json_data)
                        
                        self?.dataModel = model
                        
                        if let r = model.results {
                            self?.results.append(contentsOf: r)
                        }
                        
                        if isFirstTime, self?.results.isEmpty == true {
                            self?.tableView.setMessage("No Redemptions")
                        } else {
                            self?.tableView.removeMessage()
                        }

                        if let result = model.results, !result.isEmpty {
                            self?.isLastPageReached = false
                        } else {
                            self?.isLastPageReached = true
                        }
                        
                        self?.tableView.reloadData()
                    } catch {
                        print(error)
                    }
                    
                case.failure(let error):
                    print(error)
                }
        }
    }
}

extension BICouponRedemptionViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !results.isEmpty, indexPath.item > results.count - 5, !isLastPageReached, !isLoading {
            fetchCoupons()
        }
        
        let cell = tableView.dequeueReusableCell(with: BICouponRedemptionTableCell.self, for: indexPath)
        if results.count > indexPath.row {
            cell.model = results[indexPath.row]
        }
        cell.delegate = self
        return cell
    }
}

extension BICouponRedemptionViewController: BICouponRedemptionTableCellDelegate {
    func didTapCopyCouponCode(model: BIRedeemedCouponResultModel?) {
        guard let coupon = model?.voucher?.voucher, !coupon.isEmpty else { return }

        UIPasteboard.general.string = coupon

        showToast(message: "Copied to clipboard")
    }
}
