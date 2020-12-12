//
//  VideoHelper.swift
//  BoloIndya
//
//  Created by Rahul Garg on 10/12/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import AssetsLibrary
import AVFoundation
import Photos
import SpriteKit

enum VideoWatermarkPosition {
    case TopLeft
    case TopRight
    case BottomLeft
    case BottomRight
    case Default
}

class VideoHelper {
    func watermark(videoURL: URL, outputURL: URL? = nil, imageName name: String, watermarkText text: String? = nil, saveToLibrary flag: Bool = false, watermarkPosition position: VideoWatermarkPosition, completion: ((_ status: AVAssetExportSession.Status?, _ session: AVAssetExportSession?, _ outputURL: URL?) -> ())?) {
        self.watermark(videoURL: videoURL, outputURL: outputURL, watermarkText: text, imageName: name, saveToLibrary: flag, watermarkPosition: position) { (status, session, outputURL) -> () in
            completion?(status, session, outputURL)
        }
    }

    private func watermark(videoURL: URL, outputURL: URL? = nil, watermarkText text : String!, imageName: String, saveToLibrary flag : Bool, watermarkPosition position : VideoWatermarkPosition, completion : ((_ status : AVAssetExportSession.Status?, _ session: AVAssetExportSession?, _ outputURL : URL?) -> ())?) {
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            let mixComposition = AVMutableComposition()

            let videoAsset = AVAsset(url: videoURL)
            
            guard let compositionVideoTrack = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: Int32(kCMPersistentTrackID_Invalid)),
                  let clipVideoTrack = videoAsset.tracks(withMediaType: AVMediaType.video).first
            else {
                completion!(nil, nil, nil)
                return
            }

            self.addAudioTrack(composition: mixComposition, videoAsset: videoAsset)

            do {
                try compositionVideoTrack.insertTimeRange(CMTimeRangeMake(start: .zero, duration: videoAsset.duration), of: clipVideoTrack, at: .zero)
            } catch {
                print(error.localizedDescription)
            }

            let videoSize = clipVideoTrack.naturalSize

            let parentLayer = CALayer()
            parentLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
            
            let videoLayer = CALayer()
            videoLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
            parentLayer.addSublayer(videoLayer)

            let watermarkImage = UIImage(named: imageName)
            let imageLayer = CALayer()
            imageLayer.contents = watermarkImage?.cgImage

            var xPosition: CGFloat = 0.0
            var yPosition: CGFloat = 0.0
            let imageWidth: CGFloat = watermarkImage?.size.width ?? 50
            let imageHeight: CGFloat = watermarkImage?.size.height ?? 50

            switch position {
            case .TopLeft:
                xPosition = 0
                yPosition = 0
            case .TopRight:
                xPosition = videoSize.width - imageWidth - 30
                yPosition = 30
            case .BottomLeft:
                xPosition = 0
                yPosition = videoSize.height - imageHeight
            case .BottomRight, .Default:
                xPosition = videoSize.width - imageWidth - 20
                yPosition = videoSize.height - imageHeight - 20
            }

            imageLayer.frame = CGRect(x: xPosition, y: yPosition, width: imageWidth, height: imageHeight)
            imageLayer.opacity = 1
            parentLayer.addSublayer(imageLayer)

            if text != nil {
                let titleLayer = CATextLayer()
                titleLayer.backgroundColor = UIColor.clear.cgColor
                titleLayer.string = text
                titleLayer.font = "Helvetica" as CFTypeRef
                titleLayer.fontSize = 20
                titleLayer.alignmentMode = CATextLayerAlignmentMode.right
                titleLayer.frame = CGRect(x: 0, y: yPosition - imageHeight, width: videoSize.width - imageWidth/2 - 4, height: 57)
                titleLayer.foregroundColor = UIColor.red.cgColor
                parentLayer.addSublayer(titleLayer)
            }

            let videoComp = AVMutableVideoComposition()
            videoComp.renderSize = videoSize
            videoComp.frameDuration = CMTimeMake(value: 1, timescale: 30)
            videoComp.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)

            let instruction = AVMutableVideoCompositionInstruction()
            instruction.timeRange = CMTimeRangeMake(start: .zero, duration: mixComposition.duration)
            instruction.backgroundColor = UIColor.gray.cgColor
            _ = mixComposition.tracks(withMediaType: AVMediaType.video).first

            if let layerInstruction = self.videoCompositionInstructionForTrack(track: compositionVideoTrack, asset: videoAsset) {
                instruction.layerInstructions = [layerInstruction]
            }
            videoComp.instructions = [instruction]

            var url: URL
            if let outputURL = outputURL {
                url = outputURL
            } else if let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
                url = URL(fileURLWithPath: documentDirectory).appendingPathComponent("watermarkVideo-\(Date().timeIntervalSince1970).mp4")
            } else {
                completion?(nil, nil, nil)
                return
            }

            let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetMediumQuality)
            exporter?.outputURL = url
            exporter?.outputFileType = AVFileType.mp4
            exporter?.shouldOptimizeForNetworkUse = false
            exporter?.videoComposition = videoComp

            exporter?.exportAsynchronously() {
                DispatchQueue.main.async {

                    if exporter?.status == AVAssetExportSession.Status.completed {
                        if flag, let outputURL = exporter?.outputURL {
                            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(outputURL.path) {
                                PHPhotoLibrary.shared().performChanges({
                                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL)
                                }) { saved, error in
                                    if saved {
                                        completion?(AVAssetExportSession.Status.completed, exporter, outputURL)
                                    }
                                }
                            }

                        } else {
                            completion?(AVAssetExportSession.Status.completed, exporter, outputURL)
                        }

                    } else {
                        // Error
                        completion?(exporter?.status, exporter, nil)
                    }
                }
            }
        }
    }

    private func addAudioTrack(composition: AVMutableComposition, videoAsset: AVAsset) {
        guard let compositionAudioTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: CMPersistentTrackID()) else { return }
        
        let audioTracks = videoAsset.tracks(withMediaType: .audio)
        for audioTrack in audioTracks {
            do {
                try compositionAudioTrack.insertTimeRange(audioTrack.timeRange, of: audioTrack, at: .zero)
            } catch {
                print(error)
            }
        }
    }


    private func orientationFromTransform(transform: CGAffineTransform) -> (orientation: UIImage.Orientation, isPortrait: Bool) {
        var assetOrientation = UIImage.Orientation.up
        var isPortrait = false
        if transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0 {
            assetOrientation = .right
            isPortrait = true
        } else if transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0 {
            assetOrientation = .left
            isPortrait = true
        } else if transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0 {
            assetOrientation = .up
        } else if transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0 {
            assetOrientation = .down
        }

        return (assetOrientation, isPortrait)
    }

    private func videoCompositionInstructionForTrack(track: AVCompositionTrack, asset: AVAsset) -> AVMutableVideoCompositionLayerInstruction? {
        guard let assetTrack = asset.tracks(withMediaType: AVMediaType.video).first else { return nil }

        let transform = assetTrack.preferredTransform
        let assetInfo = orientationFromTransform(transform: transform)
        
        let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)

        var scaleToFitRatio = UIScreen.main.bounds.width / 375
        if assetInfo.isPortrait {
            scaleToFitRatio = UIScreen.main.bounds.width / assetTrack.naturalSize.height
            let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
            instruction.setTransform(assetTrack.preferredTransform.concatenating(scaleFactor),
                                     at: .zero)
        } else {
            let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
            var concat = assetTrack.preferredTransform.concatenating(scaleFactor).concatenating(CGAffineTransform(translationX: 0, y: 0))
            if assetInfo.orientation == .down {
                let fixUpsideDown = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                let windowBounds = UIScreen.main.bounds
                let yFix = 375 + windowBounds.height
                let centerFix = CGAffineTransform(translationX: assetTrack.naturalSize.width, y: CGFloat(yFix))
                concat = fixUpsideDown.concatenating(centerFix).concatenating(scaleFactor)
            }
            instruction.setTransform(concat, at: .zero)

        }

        return instruction
    }
}
