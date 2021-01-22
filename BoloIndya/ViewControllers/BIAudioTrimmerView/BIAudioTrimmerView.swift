//
//  BIAudioTrimmerView.swift
//  BoloIndya
//
//  Created by Rahul Garg on 14/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import AVKit
import ZHWaveform
import SVProgressHUD

protocol BIAudioTrimmerViewDelegate: class {
    func didTapDoneButton(url: URL)
    func didTapCancelButton()
}

final class BIAudioTrimmerView: UIView {
    
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
    @IBOutlet private weak var waveformView: UIView!
    @IBOutlet private weak var remTimeLabel: UILabel!
    
    @IBOutlet private weak var doneButton: UIButton! {
        didSet {
            doneButton.layer.cornerRadius = 4
            doneButton.clipsToBounds = true
        }
    }
    @IBOutlet private weak var cancelButton: UIButton! {
        didSet {
            cancelButton.layer.cornerRadius = 4
            cancelButton.clipsToBounds = true
        }
    }
    
    lazy var waveform: ZHWaveformView = {
        let bundle = Bundle(for: type(of: self))
        let waveform = ZHWaveformView(
            frame: waveformView.bounds,
            fileURL: audioUrl!.absoluteURL
        )
        waveform.backgroundColor = UIColor.clear
        waveform.trackScale = 1
        waveform.croppedDelegate = self
        waveform.waveformDelegate = self
        waveform.beginningPartColor = .gray
        waveform.endPartColor = .gray
        waveform.wavesColor = UIColor(hex: "10A5F9") ?? .blue
        return waveform
    }()
    
    private var player: AVPlayer?
    
    private var startCroppedRate: CGFloat = 0
    private var endCroppedRate: CGFloat = 1
    
    var audioUrl: URL?
    weak var delegate: BIAudioTrimmerViewDelegate?
    
    func config(url: URL) {
        self.audioUrl = url
        
        waveformView.addSubview(waveform)
        
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        let duration = playerItem.asset.duration
        let seconds = CMTimeGetSeconds(duration)
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
    }
    
    private func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func getTime() -> (start: CMTime, end: CMTime)? {
        guard let url = audioUrl else { return nil }
        
        let asset = AVAsset(url: url)
        let seconds = asset.duration.seconds
        let startValue = seconds * Float64(startCroppedRate)
        let endValue = seconds * Float64(endCroppedRate)
        
        let startTime = CMTime(value: Int64(startValue), timescale: 1)
        let stopTime = CMTime(value: Int64(endValue), timescale: 1)
        
        return (startTime, stopTime)
    }
    
    private func playAudio() {
        guard let time = getTime() else { return }
        
        player?.seek(to: time.start)
        player?.currentItem?.forwardPlaybackEndTime = time.end
        player?.play()
        
        musicButton.setImage(UIImage(named: "pause"), for: .normal)
    }
    
    private func pauseAudio() {
        if let startTime = getTime()?.start {
            player?.seek(to: startTime)
        }
        
        if let duration = player?.currentItem?.duration {
            let seconds = CMTimeGetSeconds(duration)
            remTimeLabel.text = stringFromTimeInterval(interval: seconds)
        }
        
        player?.pause()
        musicButton.setImage(UIImage(named: "play"), for: .normal)
    }
    
    @objc private func playerDidFinishPlaying(_ notification: NSNotification) {
        pauseAudio()
    }
    
    @IBAction private func didTapPlayButton(_ sender: UIButton) {
        if player?.rate == 0 {
            playAudio()
        } else {
            pauseAudio()
        }
    }
    
    @IBAction private func sliderValueChanged(_ sender: Any) {
        let seconds = Int64(musicSlider.value)
        let targetTime = CMTimeMake(value: seconds, timescale: 1)
        player?.seek(to: targetTime)
    }
    
    @IBAction private func didTapDoneButton(_ sender: UIButton) {
        guard let url = audioUrl,
              let exportUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("audio/trimmed.m4a"),
              let time = getTime()
            else { return }
        
        SVProgressHUD.show()
        
        player?.pause()
        
        if FileManager.default.fileExists(atPath: exportUrl.path) {
            do {
                try FileManager.default.removeItem(atPath: exportUrl.path)
            } catch {
                print(error)
                return
            }
        }
        
        let asset = AVAsset(url: url)
        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)
        exporter?.outputFileType = AVFileType.m4a
        exporter?.outputURL = exportUrl
        
        let exportTimeRange = CMTimeRangeFromTimeToTime(start: time.start, end: time.end)
        exporter?.timeRange = exportTimeRange
        
        if exportTimeRange.duration < CMTime(value: 1, timescale: 1) {
            return
        }
        
        exporter?.exportAsynchronously(completionHandler: { [weak self] in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            
            switch exporter?.status {
            case .completed:
                guard let url = exporter?.outputURL else { return }
                
                DispatchQueue.main.async {
                    self?.delegate?.didTapDoneButton(url: url)
                }
                
            default:
                print(exporter?.error ?? "Error")
            }
        })
    }
    
    @IBAction private func didTapCancelButton(_ sender: UIButton) {
        player?.pause()
        delegate?.didTapCancelButton()
    }
}


extension BIAudioTrimmerView: ZHCroppedDelegate {
    func waveformView(startCropped waveformView: ZHWaveformView) -> UIView? {
        let iv = UIImageView()
        iv.frame = CGRect(x: 0, y: 10, width: 20, height: 20)
        iv.image = UIImage(named: "music_note_white")
        return iv
    }

    func waveformView(endCropped waveformView: ZHWaveformView) -> UIView? {
        let iv = UIImageView()
        iv.frame = CGRect(x: 0, y: 10, width: 20, height: 20)
        iv.image = UIImage(named: "music_note_white")
        return iv
    }

    func waveformView(startCropped: UIView, progress rate: CGFloat) {
        if rate < 0 {
            return
        }
        
        if let rate = player?.rate, rate > 0 {
            pauseAudio()
        }
        
        startCroppedRate = rate
    }

    func waveformView(endCropped: UIView, progress rate: CGFloat) {
        if rate > 1 {
            return
        }
        
        if let rate = player?.rate, rate > 0 {
            pauseAudio()
        }
        
        endCroppedRate = rate
    }
}

extension BIAudioTrimmerView: ZHWaveformViewDelegate {
    func waveformViewStartDrawing(waveformView: ZHWaveformView) {
        
    }
    
    func waveformViewDrawComplete(waveformView: ZHWaveformView) {
        
    }
}
