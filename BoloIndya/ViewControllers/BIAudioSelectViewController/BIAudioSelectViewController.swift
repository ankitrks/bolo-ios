//
//  BIAudioSelectViewController.swift
//  BoloIndya
//
//  Created by Rahul Garg on 13/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SVProgressHUD
import AVKit

final class BIAudioSelectViewController: UIViewController {
    @IBOutlet private weak var titleImageView: UIImageView! {
        didSet {
            titleImageView.contentMode = .scaleAspectFill
            titleImageView.layer.cornerRadius = 5
            titleImageView.clipsToBounds = true
        }
    }
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var videoCountLabel: UILabel!
    
    @IBOutlet private weak var musicButton: UIButton!
    @IBOutlet private weak var musicSlider: UISlider! {
        didSet {
            musicSlider.isContinuous = true
            if #available(iOS 13.0, *) {
                let image = UIImage(named: "circle_black")?.withTintColor(UIColor(hex: "10A5F9") ?? .white)
                musicSlider.setThumbImage(image, for: .normal)
            }
        }
    }
    @IBOutlet private weak var remTimeLabel: UILabel!
    
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 50, right: 10)
            collectionView.showsVerticalScrollIndicator = false
            collectionView.isPrefetchingEnabled = true
            
            collectionView.register(cellType: BIAudioSelectCell.self)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.prefetchDataSource = self
        }
    }
    
    @IBOutlet private weak var useAudioButton: UIButton! {
        didSet {
            useAudioButton.imageView?.contentMode = .scaleAspectFill
            useAudioButton.contentMode = .scaleAspectFill
        }
    }
    
    private var trimView: BIAudioTrimmerView?
    private var reportViewController: BIReportViewController?
    
    private var player: AVPlayer?
    
    private var musicModel: BIMusicResultNextCountModel?
    private var results = [BIMusicResultModel]()
    
    private var isLoading = false
    private var isLastPageReached = false
    
    var music: Music?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = true
        
        videoCountLabel.isHidden = true
        
        musicButton.isUserInteractionEnabled = false
        useAudioButton.isUserInteractionEnabled = false
        
        if let id = music?.id, let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsURL.appendingPathComponent("audio/\(id).mp3")
            
            if FileManager.default.fileExists(atPath: fileURL.path) {
                loadMusic(from: fileURL)
            } else if let urlString = music?.s3_file_path {
                let destination: DownloadRequest.Destination = { _, _ in
                    return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                }
                
                SVProgressHUD.show()
                AF.download(urlString, to: destination).response { [weak self] response in
                    debugPrint(response)
                    
                    SVProgressHUD.dismiss()
                    
                    if response.error == nil, let path = response.fileURL {
                        self?.loadMusic(from: path)
                    }
                }
            }
        }
        
        titleLabel.text = music?.title
        subtitleLabel.text = music?.author_name
        if let image = music?.image_path, let url = URL(string: image) {
            titleImageView.kf.setImage(with: url)
        }
        
        SVProgressHUD.show()
        fetchData(isFirstTime: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SVProgressHUD.dismiss()
        
        player?.pause()
        
        if trimView != nil {
            dismissTrimView()
        }
    }
    
    private func loadMusic(from url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        let seconds = playerItem.asset.duration.seconds
        remTimeLabel.text = stringFromTimeInterval(interval: seconds)
        
        musicSlider.maximumValue = Float(seconds)
        musicSlider.isContinuous = true
        
        player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { [weak self] _ in
            guard let player = self?.player else { return }
            
            if player.currentItem?.status == .readyToPlay {
                let time = CMTimeGetSeconds(player.currentTime())
                self?.musicSlider.value = Float(time)
                
                if time > 0 {
                    self?.remTimeLabel.text = self?.stringFromTimeInterval(interval: time)
                }
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)),
               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        musicButton.isUserInteractionEnabled = true
        useAudioButton.isUserInteractionEnabled = true
    }
    
    private func fetchData(isFirstTime: Bool = false) {
        var url: String
        if isFirstTime {
            if let musicId = music?.id {
                url = "https://www.boloindya.com/api/v1/music/\(musicId)/videos/"
            } else {
                return
            }
        } else if let next = musicModel?.next, !next.isEmpty {
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
                    if let json_data = data.data(using: .utf8) {

                        do {
                            let model = try JSONDecoder().decode(BIMusicResultNextCountModel.self, from: json_data)
                            self?.musicModel = model
                            
                            if let r = model.results {
                                self?.results.append(contentsOf: r)
                            }
                            
                            let count = model.count ?? 0
                            if count == 0 {
                                self?.videoCountLabel.isHidden = true
                            } else if count == 1 {
                                self?.videoCountLabel.isHidden = false
                                self?.videoCountLabel.text = "1 Video"
                            } else {
                                self?.videoCountLabel.isHidden = false
                                self?.videoCountLabel.text = "\(count) Videos"
                            }
                            
                            if let result = model.results, !result.isEmpty {
                                self?.isLastPageReached = false
                            } else {
                                self?.isLastPageReached = true
                            }
                            
                            self?.collectionView.reloadData()
                        } catch {
                            print(error)
                        }
                    }
                case.failure(let error):
                    print(error)
                }
        }
    }
    
    private func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func fetchReportOptionsView() {
        SVProgressHUD.show()
        
        var headers: HTTPHeaders?
        if let token = UserDefaults.standard.getAuthToken(), !token.isEmpty {
            headers = ["Authorization": "Bearer \(token)"]
        }
        
        let url = "https://www.boloindya.com/api/v1/music/report/"
        
        AF.request(url, method: .get, encoding: URLEncoding.default, headers: headers)
            .responseString  { [weak self] (responseData) in
                SVProgressHUD.dismiss()
                
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                        do {
                            let jsonObject = try JSONDecoder().decode(BIReportModel.self, from: json_data)
                            
                            let vc = BIReportViewController.loadFromNib()
                            vc.delegate = self
                            vc.model = jsonObject
//                            vc.video = self?.videos[selected_postion]
                            vc.type = .music
                            vc.modalPresentationStyle = .overCurrentContext
                            vc.modalTransitionStyle = .crossDissolve
                            self?.present(vc, animated: true, completion: nil)
                            
                            self?.reportViewController = vc
                            
                            return
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    print(error)
                }
                
                self?.showToast(message: "Something went wrong. Please try again.")
        }
    }
    
    @objc private func playerDidFinishPlaying(_ notification: NSNotification) {
        musicButton.setImage(UIImage(named: "play"), for: .normal)
        player?.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
        
        if let seconds = player?.currentItem?.asset.duration.seconds {
            remTimeLabel.text = stringFromTimeInterval(interval: seconds)
        }
    }
    
    @IBAction private func didTapPlayButton(_ sender: UIButton) {
        if trimView != nil {
            dismissTrimView()
        }
        
        if player?.rate == 0 {
            player?.play()
            musicButton.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            player?.pause()
            musicButton.setImage(UIImage(named: "play"), for: .normal)
        }
    }
    
    @IBAction private func sliderValueChanged(_ sender: Any) {
        let seconds = Int64(musicSlider.value)
        let targetTime = CMTimeMake(value: seconds, timescale: 1)
        player?.seek(to: targetTime)
    }
    
    @IBAction private func didTapBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func didTapOptionsView(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Report", style: .destructive, handler: { (_) in
            self.fetchReportOptionsView()
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func didTapUseAudio(_ sender: UIButton) {
        guard let url = (player?.currentItem?.asset as? AVURLAsset)?.url else { return }
        
        player?.pause()
        musicButton.setImage(UIImage(named: "play"), for: .normal)
        
        useAudioButton.isUserInteractionEnabled = false
        showTrimView(url: url)
    }
    
    private func showTrimView(url: URL) {
        trimView = BIAudioTrimmerView.fromNib()
        
        let y = view.bounds.height - 275
        let frame = CGRect(x: 0, y: y, width: view.bounds.width, height: 275)
        self.view.addSubview(trimView!)
        
        let frame2 = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: 275)
        trimView?.frame = frame2
        trimView?.delegate = self
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve, animations: {
            self.trimView?.frame.origin.y = frame.origin.y
            self.trimView?.layoutIfNeeded()
        }, completion: { _ in 
            self.trimView?.config(url: url)
            self.useAudioButton.isUserInteractionEnabled = true
        })
    }
    
    private func dismissTrimView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve, animations: {
            self.trimView?.frame.origin.y = self.view.bounds.height
            self.trimView?.layoutIfNeeded()
        }, completion: { _ in
            self.trimView?.removeFromSuperview()
            self.trimView = nil
        })
    }
}

extension BIAudioSelectViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item > results.count - 5, !isLastPageReached, !isLoading {
            fetchData()
        }
        
        let cell = collectionView.dequeueReusableCell(with: BIAudioSelectCell.self, for: indexPath)
        if results.count > indexPath.item {
            cell.config(music: results[indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard results.count > indexPath.item,
              let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoViewController") as? VideoViewController
            else { return }
        
        vc.topic_id = "\(results[indexPath.item].id)"
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BIAudioSelectViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 40
        let itemWidth = (collectionView.bounds.width - spacing) / 3
        return CGSize(width: itemWidth, height: itemWidth*1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension BIAudioSelectViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        var urls = [URL]()
        for indexpath in indexPaths {
            guard results.count > indexpath.row,
                  let url = URL(string: results[indexpath.row].questionImage)
                else { continue }
            
            urls.append(url)
        }
        
        ImagePrefetcher(urls: urls).start()
    }
}

extension BIAudioSelectViewController: BIAudioTrimmerViewDelegate {
    func didTapDoneButton(url: URL) {
        dismissTrimView()
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateVideoViewController") as! CreateVideoViewController
        vc.isFromSelectAudio = true
        vc.selectedAudioUrl = url
        vc.selectedAudioMusic = music
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapCancelButton() {
        dismissTrimView()
    }
}

extension BIAudioSelectViewController: BIReportViewControllerDelegate {
    func didTapDismissButton() {
        reportViewController?.dismiss(animated: true, completion: {
            self.reportViewController = nil
        })
    }
    
    func didTapSubmit(text: String, object: BIReportResult, video: Topic?) {
        
    }
    
    func didTapSubmit(object: BIReportResult) {
        guard let id = music?.id else { return }
        
        SVProgressHUD.show()
        
        var headers: HTTPHeaders?
        if let token = UserDefaults.standard.getAuthToken(), !token.isEmpty {
            headers = ["Authorization": "Bearer \(token)"]
        }
        
        let paramters: [String: Any] = [
            "report": "\(object.id)"
        ]
        
        let url = "https://www.boloindya.com/api/v2/music/\(id)/report/"
        
        AF.request(url, method: .post, parameters: paramters, encoding: URLEncoding.default, headers: headers)
            .responseString { [weak self] (responseData) in
                SVProgressHUD.dismiss()
                
                switch responseData.result {
                case.success(let data):
                    if let json_data = data.data(using: .utf8) {
                        do {
                            let _ = try
                                JSONSerialization.jsonObject(with: json_data, options: []) as? [String: AnyObject]
                            
                            self?.reportViewController?.dismiss(animated: true, completion: {
                                self?.reportViewController = nil
                            })
                            
                            self?.showToast(message: "Music Reported Successfully")
                            return
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                case.failure(let error):
                    print(error)
                }
                
                self?.showToast(message: "Something went wrong. Please try again.")
            }
    }
}
