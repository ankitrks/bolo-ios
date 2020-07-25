//
//  CreateVideoViewController.swift
//  BoloIndya
//
//  Created by apple on 7/11/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import SwiftyCam

class CreateVideoViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate {

    let captureButton = SwiftyCamButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureButton.delegate = self
        
        view.addSubview(captureButton)
        
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        captureButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        captureButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        captureButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        captureButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        print("Take Photo")
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Start Recording")
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        
    }
}
