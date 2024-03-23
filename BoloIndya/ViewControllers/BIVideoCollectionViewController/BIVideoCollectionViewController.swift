//
//  BIVideoCollectionViewController.swift
//  BoloIndya
//
//  Created by Rahul Garg on 05/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SVProgressHUD

final class BIVideoCollectionViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            collectionView.showsVerticalScrollIndicator = false
            collectionView.isPrefetchingEnabled = true
            
            collectionView.register(cellType: BIVideoCollectionCell.self)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.prefetchDataSource = self
        }
    }
    
    var banner: BICampaignModel?
    
    private var topics = [Topic]()
    
    private var page = 1
    private var isLoading = false
    private var isLastPageReached = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        page = 1
        isLoading = false
        isLastPageReached = false
        
        topics.removeAll()
        collectionView.reloadData()
        
        SVProgressHUD.show()
        fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SVProgressHUD.dismiss()
    }
    
    private func fetchData() {
        guard let language = UserDefaults.standard.getValueForLanguageId(),
              let hashtag = banner?.hashtagName,
              !hashtag.isEmpty
            else { return }
        
        isLoading = true
        
        var headers: HTTPHeaders? = nil
        if let token = UserDefaults.standard.getAuthToken(), !token.isEmpty {
            headers = ["Authorization": "Bearer \(token)"]
        }
        
        let url = "https://www.boloindya.com/api/v1/get_challenge/?challengehash=\(hashtag)&page=\(page)&language_id=\(language)"
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseString { [weak self] (responseData) in
                
                self?.isLoading = false
                SVProgressHUD.dismiss()
                
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                        
                        do {
                            let json_object = try JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                            if let content = json_object?["results"] as? [[String:Any]] {
                                for each in content {
                                    self?.topics.append(getTopicFromJson(each: each))
                                }
                                
                                if content.isEmpty {
                                    self?.isLastPageReached = true
                                } else {
                                    self?.isLastPageReached = false
                                }
                                
                                self?.page += 1
                                self?.collectionView.reloadData()
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    print(error)
                }
        }
    }
}

extension BIVideoCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item > topics.count - 5, !isLastPageReached, !isLoading {
            fetchData()
        }
        
        let cell = collectionView.dequeueReusableCell(with: BIVideoCollectionCell.self, for: indexPath)
        if topics.count > indexPath.item {
            cell.config(topic: topics[indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard topics.count > indexPath.item,
              let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoViewController") as? VideoViewController
            else { return }
        
        vc.videos = topics
        vc.self_user = false
        vc.selected_position = indexPath.item
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BIVideoCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 40
        let itemWidth = (collectionView.bounds.width - spacing) / 3
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension BIVideoCollectionViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        var urls = [URL]()
        for indexpath in indexPaths {
            guard topics.count > indexpath.row,
                  let url = URL(string: topics[indexpath.row].thumbnail)
                else { continue }
            
            urls.append(url)
        }
        
        ImagePrefetcher(urls: urls).start()
    }
}
