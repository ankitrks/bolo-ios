//
//  CreateVideoViewController.swift
//  BoloIndya
//
//  Created by apple on 7/11/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import SwiftyCam
import Photos
import YPImagePicker

class CreateVideoViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var captureButton =  UIImageView()
    
    var timer_label = UILabel()
    var timeMin = 0
    var timeSec = 0
    weak var timer: Timer?
    
    var go_back =  UIImageView()
    var galleryButton = UIImageView()
    var switchFrontCamera = UIImageView()
    var flashCamera = UIImageView()
    
    var isRecording: Bool = false
    var video_url: URL!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isLoggedIn = UserDefaults.standard.isLoggedIn() ?? false
        if (!isLoggedIn) {
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.isNavigationBarHidden = true
            performSegue(withIdentifier: "createLogin", sender: self)
        } else {
        
            cameraDelegate = self
            defaultCamera = .front
            
            view.addSubview(captureButton)
            
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
            
            view.addSubview(go_back)
            
            go_back.translatesAutoresizingMaskIntoConstraints = false
            go_back.widthAnchor.constraint(equalToConstant: 40).isActive = true
            
            go_back.heightAnchor.constraint(equalToConstant: 40).isActive = true
            go_back.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5).isActive = true
            go_back.topAnchor.constraint(equalTo: self.view.topAnchor, constant: getStatusBarHeight()).isActive = true
            
            go_back.image = UIImage(named: "close")
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
        }
        
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
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {[weak self] _ in
            self?.timerTick()
        })
    }
    
    
    @objc func timerTick(){
        timeSec += 1
        
        if timeSec == 60 {
            timeSec = 0
            timeMin += 1
        }
        let timeNow = String(format: "%02d:%02d", timeMin, timeSec)
        timer_label.text = timeNow
    }
    
    @objc func resetTimerToZero(){
        timeSec = 0
        timeMin = 0
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
     }
     
     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         self.navigationController?.isNavigationBarHidden = true
        stopVideoRecording()
        captureButton.image = UIImage(named: "start_record")
        galleryButton.isHidden = false
        switchFrontCamera.isHidden = false
        resetTimerToZero()
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
            stopTimer()
            stopVideoRecording()
            captureButton.image = UIImage(named: "start_record")
            galleryButton.isHidden = false
            switchFrontCamera.isHidden = false
        } else {
            startTimer()
            startVideoRecording()
            captureButton.image = UIImage(named: "stop_record")
            galleryButton.isHidden = true
            switchFrontCamera.isHidden = true
        }
        isRecording = !isRecording
    }
    
    @objc func goBack(_ sender: UITapGestureRecognizer) {
        self.tabBarController?.selectedIndex = 0
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        print("Take Photo")
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Start Recording")
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        print("Stop Recording")
        video_url = url
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        performSegue(withIdentifier: "videoThumbnail", sender: self)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    }
    
}
