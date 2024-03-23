//
//  PlayerViewClass.swift
//  BoloIndya
//
//  Created by apple on 7/14/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

protocol PlayerViewClassDelegate: class {
    func playerStatus(status: AVPlayerItem.Status)
}

class PlayerViewClass: UIView {
    
    private var playerItemContext = 0
    private var playerItem: AVPlayerItem?
    
    weak var delegate: PlayerViewClassDelegate?

    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        
        set {
            playerLayer.player = newValue
            playerLayer.videoGravity = .resizeAspectFill
        }
    }
    
    private var url: URL?
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // Only handle observations for the playerItemContext
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
            
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            // Switch over status value
            switch status {
            case .readyToPlay:
                print(".readyToPlay")
                play()
            case .failed:
                print(".failed")
            case .unknown:
                print(".unknown")
            @unknown default:
                print("@unknown default")
            }
            
            delegate?.playerStatus(status: status)
        }
    }
    
    private func setUpAsset(with url: URL, completion: ((_ asset: AVAsset) -> Void)?) {
        let mimeType = "video/mp4; codecs=\"avc1.42E01E, mp4a.40.2\""
        let asset = AVURLAsset(url: url, options:["AVURLAssetOutOfBandMIMETypeKey": mimeType])
        
//        completion?(asset)
        asset.loadValuesAsynchronously(forKeys: ["playable"]) {
            var error: NSError? = nil
            let status = asset.statusOfValue(forKey: "playable", error: &error)
            switch status {
            case .loaded:
                completion?(asset)
            case .failed:
                print(".failed")
            case .cancelled:
                print(".cancelled")
            default:
                print("default")
            }
        }
    }
    
    private func setUpPlayerItem(with asset: AVAsset) {
        playerItem = AVPlayerItem(asset: asset)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &playerItemContext)

        DispatchQueue.main.async {
            if self.player == nil {
                self.player = AVPlayer(playerItem: self.playerItem!)
                self.player?.automaticallyWaitsToMinimizeStalling = false
            } else {
                self.play()
            }
        }
    }
    
    func play(with url: URL) {
        self.url = url
        
        DispatchQueue.global().async {
            self.setUpAsset(with: url) { [weak self] (asset: AVAsset) in
                self?.setUpPlayerItem(with: asset)
            }
        }
    }
    
    func play() {
        pauseVideo()
        player?.play()
//        player?.play()//playImmediately(atRate: 1.0)
    }
    
    func pauseVideo() {
        player?.pause()
    }
    
    deinit {
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
    }
}
