//
//  BIAudioGallerySelectorViewController.swift
//  BoloIndya
//
//  Created by Rahul Garg on 15/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

protocol BIAudioGallerySelectorViewControllerDelegate: class {
    func didSelectAudio(with object: BIMusicTrackModel, url: URL)
    func didDismissAudioSelector()
}

final class BIAudioGallerySelectorViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            tableView.register(cellType: TrackCell.self)
            
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    private var readyFiles = [BIMusicTrackModel]()
    
    private var page = 1
    private var isLoading = false
    private var isLastPageReached = false
    
    weak var delegate: BIAudioGallerySelectorViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SVProgressHUD.dismiss()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func fetchData() {
        guard let token = UserDefaults.standard.getAuthToken(),
              !token.isEmpty,
              let language = UserDefaults.standard.getValueForLanguageId()
        else { return }
        
        isLoading = true
        
        var headers: HTTPHeaders?
        if let token = UserDefaults.standard.getAuthToken(), !token.isEmpty {
            headers = ["Authorization": "Bearer \(token)"]
        }
        
        let url = "https://www.boloindya.com/api/v2/fetch_audio_list/?page=\(page)&language_id=\(language)"
        
        AF.request(url, method: .get, encoding: URLEncoding.default, headers: headers)
            .responseString { [weak self] (responseData) in
                
                self?.isLoading = false
                SVProgressHUD.dismiss()
                
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                        do {
                            let jsonObject = try JSONDecoder().decode(BIMusicTrackSuccessModel.self, from: json_data)
                            
                            let result = jsonObject.results
                            if result.isEmpty {
                                self?.isLastPageReached = true
                            } else {
                                self?.isLastPageReached = false
                                
                                self?.readyFiles.append(contentsOf: result)
                            }
                            
                            self?.page += 1
                            self?.tableView.reloadData()
                            
                        } catch {
                            print(error)
                        }
                    }
                case.failure(let error):
                    print(error)
                }
            }
    }
    
    @IBAction func closeTrackSelection(_ sender: UIButton) {
        delegate?.didDismissAudioSelector()
    }
}

extension BIAudioGallerySelectorViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readyFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > readyFiles.count - 5, !isLastPageReached, !isLoading {
            fetchData()
        }
        
        let cell = tableView.dequeueReusableCell(with: TrackCell.self, for: indexPath)
        if readyFiles.count > indexPath.row {
            cell.model = readyFiles[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? TrackCell)?.player?.pause()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? TrackCell
        cell?.player?.pause()
        
        guard readyFiles.count > indexPath.row else { return }
        
        let item = readyFiles[indexPath.row]
        
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileURL = documentsURL.appendingPathComponent("/audio/\(item.id).mp3")
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            delegate?.didSelectAudio(with: item, url: fileURL)
            navigationController?.popViewController(animated: true)
        } else {
            SVProgressHUD.show()
            
            let destination: DownloadRequest.Destination = { _, _ in
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            AF.download(readyFiles[indexPath.row].s3FilePath, to: destination)
                .downloadProgress(closure: { (progress) in
                    DispatchQueue.main.async {
                        let fraction = progress.fractionCompleted
                        let percent = Int(fraction * 100)
                        SVProgressHUD.showProgress(Float(fraction), status: "Downloading... \(percent)%")
                    }
                })
                .response { [weak self] response in
                    debugPrint(response)
                    
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        
                        if response.error == nil, let path = response.fileURL {
                            self?.delegate?.didSelectAudio(with: item, url: path)
                            self?.navigationController?.popViewController(animated: true)
                        }
                    }
                }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
