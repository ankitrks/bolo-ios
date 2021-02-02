//
//  CreateVideoViewController.swift
//  BoloIndya
//
//  Created by apple on 7/11/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Photos
import YPImagePicker
import AVFoundation
import AVKit
import AssetsLibrary
import SVProgressHUD
import MarqueeLabel

class CreateVideoViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var captureButton =  UIImageView()
    
    var timer_label = UILabel()
    var timeMin = 0
    var timeSec = 0
    var timeMax: Double?
    var totalTime = 0
    weak var timer: Timer?
    
    var go_back =  UIImageView()
    var galleryButton = UIImageView()
    var switchFrontCamera = UIImageView()
    var flashCamera = UIImageView()
    let songStack = UIStackView()
    let selectAudioLabel = MarqueeLabel()
    
    var songStackViewConstraint: NSLayoutConstraint?
    
    var isRecording: Bool = false
    var video_url: URL!
    
    var isFromCampaign = false
    var isFromSelectAudio = false
    var selectedAudioUrl: URL?
    var selectedAudioMusic: Music?
    var selectedAudioMusicTrack: BIMusicTrackModel?
    
    private var player: AVPlayer?
    
    private var trimView: BIAudioTrimmerView?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var isLoggedin: Bool
        if let guest = UserDefaults.standard.getGuestLoggedIn(), !guest {
            isLoggedin = true
        } else if let name = UserDefaults.standard.getName(), !name.isEmpty, let gender = UserDefaults.standard.getGender(), !gender.isEmpty, let dob = UserDefaults.standard.getDOB(), !dob.isEmpty {
            isLoggedin = true
        } else {
            isLoggedin = false
        }
        
        if (isLoggedin) {
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.isNavigationBarHidden = true
            performSegue(withIdentifier: "LoginAndSignUpViewController", sender: self)
        } else {
        
            cameraDelegate = self
            defaultCamera = .front
            
            view.addSubview(captureButton)
            view.addSubview(go_back)
            captureButton.translatesAutoresizingMaskIntoConstraints = false
            captureButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
            captureButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            captureButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
            captureButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -70).isActive = true
            
            captureButton.isUserInteractionEnabled = true
            
            let tapGestureRecord = UITapGestureRecognizer(target: self, action: #selector(record(_:)))
            captureButton.addGestureRecognizer(tapGestureRecord)
            
            captureButton.image = UIImage(named: "start_record")
            
            view.addSubview(galleryButton)
            
            galleryButton.translatesAutoresizingMaskIntoConstraints = false
            galleryButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
            galleryButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            galleryButton.rightAnchor.constraint(equalTo: captureButton.leftAnchor, constant: -15).isActive = true
            galleryButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -70).isActive = true
            
            galleryButton.isUserInteractionEnabled = true
            
            let tapGesturegallery = UITapGestureRecognizer(target: self, action: #selector(openGallery(_:)))
            galleryButton.addGestureRecognizer(tapGesturegallery)
           
            galleryButton.image = UIImage(named: "gallery")
            
            view.addSubview(switchFrontCamera)
            
            switchFrontCamera.translatesAutoresizingMaskIntoConstraints = false
            switchFrontCamera.widthAnchor.constraint(equalToConstant: 40).isActive = true
            switchFrontCamera.heightAnchor.constraint(equalToConstant: 40).isActive = true
            switchFrontCamera.leftAnchor.constraint(equalTo: captureButton.rightAnchor, constant: 15).isActive = true
            switchFrontCamera.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -70).isActive = true

            switchFrontCamera.isUserInteractionEnabled = true

            let tapGestureswitch = UITapGestureRecognizer(target: self, action: #selector(switchFront(_:)))
            switchFrontCamera.addGestureRecognizer(tapGestureswitch)
          
            switchFrontCamera.image = UIImage(named: "switch_camera")
            
            view.addSubview(flashCamera)
            
            flashCamera.translatesAutoresizingMaskIntoConstraints = false
            flashCamera.widthAnchor.constraint(equalToConstant: 40).isActive = true
            flashCamera.heightAnchor.constraint(equalToConstant: 40).isActive = true
            flashCamera.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
            flashCamera.topAnchor.constraint(equalTo: self.view.topAnchor, constant: getStatusBarHeight()).isActive = true
            
            flashCamera.isHidden = true
            flashCamera.isUserInteractionEnabled = true
            
            let tapGestureFlash = UITapGestureRecognizer(target: self, action: #selector(flashCameraEnabled))
            flashCamera.addGestureRecognizer(tapGestureFlash)
            
            flashCamera.image = UIImage(named: "flash")
            
            
            
            go_back.translatesAutoresizingMaskIntoConstraints = false
            go_back.widthAnchor.constraint(equalToConstant: 30).isActive = true
            
            go_back.heightAnchor.constraint(equalToConstant: 30).isActive = true
            go_back.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
            go_back.topAnchor.constraint(equalTo: self.view.topAnchor, constant: getStatusBarHeight()).isActive = true
            
            go_back.image = UIImage(named: "close_white")
            go_back.tintColor = UIColor.white
            
            go_back.isUserInteractionEnabled = true
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goBack(_:)))
            go_back.addGestureRecognizer(tapGesture)
           
            view.addSubview(timer_label)
            
            timer_label.translatesAutoresizingMaskIntoConstraints = false
            timer_label.widthAnchor.constraint(equalToConstant: 100).isActive = true
            
            timer_label.heightAnchor.constraint(equalToConstant: 20).isActive = true
            timer_label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
            timer_label.bottomAnchor.constraint(equalTo: captureButton.topAnchor, constant: -10).isActive = true
            timer_label.textAlignment = .center
            
            timer_label.textColor = UIColor.white
            
            
            
            let songImageView = UIImageView()
            songImageView.translatesAutoresizingMaskIntoConstraints = false
            songImageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
            songImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
            songImageView.image = UIImage(named: "music_note_white")
            
            selectAudioLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
            selectAudioLabel.textColor = UIColor.white
            selectAudioLabel.textAlignment = .center
            selectAudioLabel.fadeLength = 5
            selectAudioLabel.speed = MarqueeLabel.SpeedLimit.rate(50)
            selectAudioLabel.animationDelay = 2
            selectAudioLabel.trailingBuffer = 50
            
            selectAudioLabel.isUserInteractionEnabled = true
            let audioGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSelectAudioLabel(_:)))
            selectAudioLabel.addGestureRecognizer(audioGesture)
            
            songStack.axis = .horizontal
            songStack.spacing = 8
            songStack.alignment = .center
            songStack.distribution = .fill
            songStack.addArrangedSubview(songImageView)
            songStack.addArrangedSubview(selectAudioLabel)
            songStack.isUserInteractionEnabled = true
            
            view.addSubview(songStack)
            songStack.translatesAutoresizingMaskIntoConstraints = false
//            songStack.leftAnchor.constraint(greaterThanOrEqualTo: self.view.leftAnchor, constant: 40).isActive = true
//            songStack.rightAnchor.constraint(greaterThanOrEqualTo: self.go_back.leftAnchor, constant: 0).isActive = true
            songStack.centerYAnchor.constraint(equalTo: self.go_back.centerYAnchor, constant: 0).isActive = true
            songStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
            songStack.heightAnchor.constraint(equalTo: self.go_back.heightAnchor).isActive = true
        }
        
        if !isFromCampaign {
            BIDeeplinkHandler.campaignHashtag2 = nil
        }
        
        if let url = selectedAudioUrl {
            let playerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
            
            let seconds = playerItem.asset.duration.seconds
            timeMax = seconds
            
            showToast(message: "Shoot upto \(seconds.removeZerosFromEnd()) seconds")
            
            if let musicTitle = selectedAudioMusic?.title {
                selectAudioLabel.text = musicTitle
            } else if let musicTitle = selectedAudioMusicTrack?.title {
                selectAudioLabel.text = musicTitle
            } else {
                selectAudioLabel.text = "Audio Selected"
            }
        } else {
            selectAudioLabel.text = "Select Audio"
        }
        
        setSelectAudioWidth()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ThumbailViewController {
            let vc = segue.destination as? ThumbailViewController
            vc?.url = video_url
        }
    }
    
    func startTimer(){
         
        let timeNow = String(format: "%02d:%02d", timeMin, timeSec)
        timer_label.text = timeNow
        
        stopTimer()
        totalTime = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {[weak self] _ in
            self?.timerTick()
        })
    }
    
    
    @objc func timerTick(){
        timeSec += 1
        totalTime += 1
        
        if let timeMax = timeMax, Int(timeMax) <= totalTime {
            totalTime = 0
            stopTimer()
            stopVideoRecording()
            captureButton.image = UIImage(named: "start_record")
            galleryButton.isHidden = false
            switchFrontCamera.isHidden = false
            
            selectAudioLabel.isUserInteractionEnabled = true
            
            if selectedAudioUrl != nil {
                player?.pause()
            }
        } else {
            selectAudioLabel.isUserInteractionEnabled = false
        }
        
        if timeSec == 60 {
            timeSec = 0
            timeMin += 1
        }
        
        if timeMin == 2 {
            totalTime = 0
            stopTimer()
            stopVideoRecording()
            captureButton.image = UIImage(named: "start_record")
            galleryButton.isHidden = false
            switchFrontCamera.isHidden = false
            
            selectAudioLabel.isUserInteractionEnabled = true
            
            if selectedAudioUrl != nil {
                player?.pause()
            }
        } else {
            selectAudioLabel.isUserInteractionEnabled = false
        }
        
        let timeNow = String(format: "%02d:%02d", timeMin, timeSec)
        timer_label.text = timeNow
    }
    
    @objc func resetTimerToZero() {
        timeSec = 0
        timeMin = 0
        totalTime = 0
        stopTimer()
    }
    
    @objc func resetTimerAndLabel() {
       resetTimerToZero()
       timer_label.text = String(format: "%02d:%02d", timeMin, timeSec)
    }
    
    @objc func stopTimer(){
        timer?.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        stopVideoRecording()
        captureButton.image = UIImage(named: "start_record")
        galleryButton.isHidden = false
        switchFrontCamera.isHidden = false
        resetTimerAndLabel()
        
        selectAudioLabel.isUserInteractionEnabled = true
        
        if selectedAudioUrl != nil {
            player?.pause()
        }
    }
     
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        if trimView != nil {
            dismissTrimView()
        }
    }
     
     @objc func openGallery(_ sender: UITapGestureRecognizer) {
        var config = YPImagePickerConfiguration()
        config.screens = [.library]
        config.showsVideoTrimmer = false
        config.library.mediaType = .video
        
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            if let video = items.singleVideo {
                self.video_url = video.url
                self.tabBarController?.tabBar.isHidden = true
                self.navigationController?.isNavigationBarHidden = true
                self.performSegue(withIdentifier: "videoThumbnail", sender: self)
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    @objc func switchFront(_ sender: UITapGestureRecognizer) {
        switchCamera()
    }
    
    @objc func flashCameraEnabled(_ sender: UITapGestureRecognizer) {
    }
    
    @objc func record(_ sender: UITapGestureRecognizer) {
        if isRecording {
            print("record ## 1")
            totalTime = 0
            stopTimer()
            stopVideoRecording()
            captureButton.image = UIImage(named: "start_record")
            galleryButton.isHidden = false
            switchFrontCamera.isHidden = false
            
            selectAudioLabel.isUserInteractionEnabled = true
            
            if selectedAudioUrl != nil {
                player?.pause()
            }
        } else {
            print("record ## 2")
            startTimer()
            
            if selectedAudioUrl != nil {
                audioEnabled = false
                player?.play()
            } else {
                audioEnabled = true
            }
            
            startVideoRecording()
            captureButton.image = UIImage(named: "stop_record")
            galleryButton.isHidden = true
            switchFrontCamera.isHidden = true
            
            selectAudioLabel.isUserInteractionEnabled = false
        }
        isRecording = !isRecording
    }
    
    @objc func goBack(_ sender: UITapGestureRecognizer) {
        selectedAudioUrl = nil
        selectedAudioMusic = nil
        selectedAudioMusicTrack = nil
        timeMax = nil
        player?.pause()
        player = nil
        
        stopTimer()
        stopVideoRecording()
        
        selectAudioLabel.text = "Select Audio"
        
        setSelectAudioWidth()
        
        if self.isFromCampaign {
            self.navigationController?.popViewController(animated: true)
        } else if self.isFromSelectAudio {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.tabBarController?.selectedIndex = 0
            
            self.navigationController?.isNavigationBarHidden = false
            self.tabBarController?.tabBar.isHidden = false
        }
        
        self.isFromCampaign = false
        self.isFromSelectAudio = false
    }
    
    @objc private func didTapSelectAudioLabel(_ sender: UITapGestureRecognizer) {
        if selectedAudioUrl != nil {
            let alert = UIAlertController(title: "Are you sure you want to delete the selected audio?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { (_) in
                self.selectedAudioUrl = nil
                self.selectedAudioMusic = nil
                self.selectedAudioMusicTrack = nil
                self.timeMax = nil
                self.player = nil
                
                self.selectAudioLabel.text = "Select Audio"
                
                self.setSelectAudioWidth()
            }))
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            let vc = BIAudioGallerySelectorViewController.loadFromNib()
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        print("Take Photo")
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("record ## 3")
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        print("record ## 4")
        
        if let audioUrl = selectedAudioUrl {
            SVProgressHUD.show()
            player?.pause()
            
            mergeVideoAndAudio(videoUrl: url, audioUrl: audioUrl) { [weak self] (error, mergedUrl) in
                if let mergedUrl = mergedUrl {
                    self?.video_url = mergedUrl
                    
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        
                        self?.tabBarController?.tabBar.isHidden = true
                        self?.navigationController?.isNavigationBarHidden = true
                        self?.performSegue(withIdentifier: "videoThumbnail", sender: self)
                    }
                    
                }
            }
        } else {
            video_url = url
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.isNavigationBarHidden = true
            performSegue(withIdentifier: "videoThumbnail", sender: self)
        }
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("record ## 5")
        
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        print("record ## 6")
        
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        print("record ## 7")
        
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        print("record ## 8")
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("record ## 9")
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
    
    private func mergeVideoAndAudio(videoUrl: URL, audioUrl: URL, completion: @escaping (_ error: Error?, _ url: URL?) -> Void) {
        let mixComposition = AVMutableComposition()
        var mutableCompositionVideoTrack = [AVMutableCompositionTrack]()
        var mutableCompositionAudioTrack = [AVMutableCompositionTrack]()
        var mutableCompositionAudioOfVideoTrack = [AVMutableCompositionTrack]()

        let aVideoAsset = AVAsset(url: videoUrl)
        let aAudioAsset = AVAsset(url: audioUrl)

        guard let compositionAddVideo = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid),
              let compositionAddAudio = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid),
              let compositionAddAudioOfVideo = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid),
              let aVideoAssetTrack = aVideoAsset.tracks(withMediaType: AVMediaType.video).first,
              let aAudioOfVideoAssetTrack = aVideoAsset.tracks(withMediaType: AVMediaType.audio).first,
              let aAudioAssetTrack = aAudioAsset.tracks(withMediaType: AVMediaType.audio).first
        else {
            completion(nil, nil)
            return
        }

        // Default must have tranformation
        compositionAddVideo.preferredTransform = aVideoAssetTrack.preferredTransform

        mutableCompositionVideoTrack.append(compositionAddVideo)
        mutableCompositionAudioTrack.append(compositionAddAudio)
        mutableCompositionAudioOfVideoTrack.append(compositionAddAudioOfVideo)

        do {
            try mutableCompositionVideoTrack.first?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero,
                                                                                    duration: aVideoAssetTrack.timeRange.duration),
                                                                    of: aVideoAssetTrack,
                                                                    at: CMTime.zero)
            
            try mutableCompositionAudioTrack.first?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero,
                                                                                    duration: aVideoAssetTrack.timeRange.duration),
                                                                    of: aAudioAssetTrack,
                                                                    at: CMTime.zero)
            
            try mutableCompositionAudioOfVideoTrack.first?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero,
                                                                                           duration: aVideoAssetTrack.timeRange.duration),
                                                                           of: aAudioOfVideoAssetTrack,
                                                                           at: CMTime.zero)
        } catch {
            print(error.localizedDescription)
        }
        
        // Exporting
        let savePathUrl = URL(fileURLWithPath: NSTemporaryDirectory().appending("video.mov"))
        
        if FileManager.default.fileExists(atPath: savePathUrl.path) {
            do {
                try FileManager.default.removeItem(atPath: savePathUrl.path)
            } catch {
                print(error.localizedDescription)
            }
        }

        let assetExport = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)!
        assetExport.outputFileType = AVFileType.mov
        assetExport.outputURL = savePathUrl
        assetExport.shouldOptimizeForNetworkUse = true

        assetExport.exportAsynchronously { () -> Void in
            switch assetExport.status {
            case AVAssetExportSessionStatus.completed:
                print("success")
                completion(nil, savePathUrl)
            case AVAssetExportSessionStatus.failed:
                print("failed \(assetExport.error?.localizedDescription ?? "error nil")")
                completion(assetExport.error, nil)
            case AVAssetExportSessionStatus.cancelled:
                print("cancelled \(assetExport.error?.localizedDescription ?? "error nil")")
                completion(assetExport.error, nil)
            default:
                print("complete")
                completion(assetExport.error, nil)
            }
        }
    }
    
    private func setSelectAudioWidth() {
        let textWidth = selectAudioLabel.intrinsicContentSize.width + 25
        let maxWidth = view.bounds.width - 40 - 40
        
        let constraint = min(textWidth, maxWidth)
        if songStackViewConstraint == nil  {
            songStackViewConstraint = songStack.widthAnchor.constraint(equalToConstant: constraint)
            songStackViewConstraint?.isActive = true
        } else {
            songStackViewConstraint?.constant = constraint
        }
    }
}

extension CreateVideoViewController: BIAudioGallerySelectorViewControllerDelegate {
    func didSelectAudio(with object: BIMusicTrackModel, url: URL) {
        selectedAudioUrl = url
        selectedAudioMusicTrack = object
        
        if trimView == nil {
            showTrimView(url: url)
        }
    }
    
    func didDismissAudioSelector() {
        navigationController?.popViewController(animated: true)
    }
}

extension CreateVideoViewController: BIAudioTrimmerViewDelegate {
    func didTapDoneButton(url: URL) {
        dismissTrimView()
        
        selectedAudioUrl = url
        
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        let seconds = playerItem.asset.duration.seconds
        timeMax = seconds
        
        showToast(message: "Shoot upto \(seconds.removeZerosFromEnd()) seconds")
        
        selectAudioLabel.text = selectedAudioMusicTrack?.title
        
        setSelectAudioWidth()
    }
    
    func didTapCancelButton() {
        dismissTrimView()
        
        selectedAudioUrl = nil
        selectedAudioMusic = nil
        selectedAudioMusicTrack = nil
        timeMax = nil
        player = nil
        
        selectAudioLabel.text = "Select Audio"
        
        setSelectAudioWidth()
    }
}
