//
//  ThumbailViewController.swift
//  BoloIndya
//
//  Created by apple on 8/5/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Photos
import YPImagePicker
import Kingfisher

class ThumbailViewController: UIViewController {

    var upper_tab = UIView()
    var back_image = UIImageView()
    var label = UILabel()
    var tick_image = UIImageView()
    
    var thumb_view = UIView()
    var thumb_one = UIImageView()
    var thumb_two = UIImageView()
    var selected_thumb = UIImageView()
    
    var player_thumb = UIImageView()
    var player_holder = UIView()
    var player = PlayerViewClass()
    var choosen_image = UIImage()
    
    var add_icon = UIImageView()
    
    var play_and_pause_image = UIImageView()
    var isHidden = false
    var url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Thumbail")
        setView()
    }
    
    func setView() {

        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        let screenSize = UIScreen.main.bounds.size
        
        upper_tab.addSubview(back_image)
        upper_tab.addSubview(label)
        upper_tab.addSubview(tick_image)
        
        view.addSubview(upper_tab)
        
        upper_tab.translatesAutoresizingMaskIntoConstraints = false
        upper_tab.heightAnchor.constraint(equalToConstant: 40).isActive = true
        upper_tab.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 0).isActive = true
        upper_tab.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: 0).isActive = true
        upper_tab.topAnchor.constraint(equalTo: self.view.topAnchor, constant: getStatusBarHeight()).isActive = true
        
        upper_tab.layer.backgroundColor = UIColor(hex: "10A5F9")?.cgColor
        
        back_image.translatesAutoresizingMaskIntoConstraints = false
        back_image.heightAnchor.constraint(equalToConstant: 20).isActive = true
        back_image.widthAnchor.constraint(equalToConstant: 40).isActive = true
        back_image.centerYAnchor.constraint(equalTo: upper_tab.centerYAnchor,constant: 0).isActive = true
        back_image.leftAnchor.constraint(equalTo: upper_tab.leftAnchor,constant: 10).isActive = true
        
        back_image.isUserInteractionEnabled = true
        let tapGestureBack = UITapGestureRecognizer(target: self, action: #selector(goBack(_:)))
        back_image.addGestureRecognizer(tapGestureBack)
        
        back_image.image = UIImage(named: "back")
        back_image.contentMode = .scaleAspectFit
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.centerYAnchor.constraint(equalTo: upper_tab.centerYAnchor,constant: 0).isActive = true
        label.leftAnchor.constraint(equalTo: back_image.rightAnchor,constant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: tick_image.leftAnchor,constant: -10).isActive = true
        
        label.text = "Choose Thumbnail"
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        tick_image.translatesAutoresizingMaskIntoConstraints = false
        tick_image.heightAnchor.constraint(equalToConstant: 20).isActive = true
        tick_image.widthAnchor.constraint(equalToConstant: 40).isActive = true
        tick_image.centerYAnchor.constraint(equalTo: upper_tab.centerYAnchor,constant: 0).isActive = true
        tick_image.rightAnchor.constraint(equalTo: upper_tab.rightAnchor,constant: -10).isActive = true
        
        tick_image.image = UIImage(named: "tick")
        tick_image.contentMode = .scaleAspectFit
        
        tick_image.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(setThumbnail(_:)))
        tick_image.addGestureRecognizer(tapGesture)
        
        thumb_view.addSubview(thumb_one)
        thumb_view.addSubview(thumb_two)
        thumb_view.addSubview(selected_thumb)
        thumb_view.addSubview(add_icon)
        
        view.addSubview(thumb_view)
        
        thumb_view.translatesAutoresizingMaskIntoConstraints = false
        thumb_view.widthAnchor.constraint(equalToConstant: screenSize.width*0.8).isActive = true
        thumb_view.heightAnchor.constraint(equalToConstant: 130).isActive = true
        thumb_view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        thumb_view.topAnchor.constraint(equalTo: upper_tab.bottomAnchor, constant: 10).isActive = true
     
        thumb_one.translatesAutoresizingMaskIntoConstraints = false
        thumb_one.widthAnchor.constraint(equalToConstant: ((screenSize.width*0.8)/3)-10).isActive = true
        thumb_one.heightAnchor.constraint(equalToConstant: 130).isActive = true
        thumb_one.leftAnchor.constraint(equalTo: thumb_view.leftAnchor, constant: 5).isActive = true
        
        thumb_two.translatesAutoresizingMaskIntoConstraints = false
        thumb_two.widthAnchor.constraint(equalToConstant: ((screenSize.width*0.8)/3)-10).isActive = true
        thumb_two.heightAnchor.constraint(equalToConstant: 130).isActive = true
        thumb_two.leftAnchor.constraint(equalTo: thumb_one.rightAnchor, constant: 10).isActive = true
        
        selected_thumb.translatesAutoresizingMaskIntoConstraints = false
        selected_thumb.widthAnchor.constraint(equalToConstant: ((screenSize.width*0.8)/3)-10).isActive = true
        selected_thumb.heightAnchor.constraint(equalToConstant: 130).isActive = true
        selected_thumb.leftAnchor.constraint(equalTo: thumb_two.rightAnchor, constant: 10).isActive = true
        
        thumb_one.contentMode = .scaleAspectFit
        thumb_two.contentMode = .scaleAspectFit
        
        thumb_one.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.8470588235)
        thumb_two.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.8470588235)
        selected_thumb.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.8470588235)
        
        thumb_one.clipsToBounds = true
        thumb_two.clipsToBounds = true
        
        add_icon.translatesAutoresizingMaskIntoConstraints = false
        add_icon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        add_icon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        add_icon.centerYAnchor.constraint(equalTo: selected_thumb.centerYAnchor, constant: 0).isActive = true
        
        add_icon.centerXAnchor.constraint(equalTo: selected_thumb.centerXAnchor, constant: 0).isActive = true
        
        add_icon.image = UIImage(named: "choose_thumb")
        
        view.addSubview(play_and_pause_image)
        
        play_and_pause_image.translatesAutoresizingMaskIntoConstraints = false
        play_and_pause_image.heightAnchor.constraint(equalToConstant: 40).isActive = true
        play_and_pause_image.widthAnchor.constraint(equalToConstant: 40).isActive = true
        play_and_pause_image.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: screenSize.width*0.1).isActive = true
        play_and_pause_image.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
        play_and_pause_image.image = UIImage(named: "play")
        
        play_and_pause_image.isUserInteractionEnabled = true
        let pauseGesture = UITapGestureRecognizer(target: self, action: #selector(pausePlayer(_:)))
        play_and_pause_image.addGestureRecognizer(pauseGesture)
        
        view.addSubview(player_holder)
        
        player_holder.translatesAutoresizingMaskIntoConstraints = false
        player_holder.widthAnchor.constraint(equalToConstant: screenSize.width*0.8).isActive = true
        player_holder.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        player_holder.topAnchor.constraint(equalTo: thumb_view.bottomAnchor, constant: 10).isActive = true
        player_holder.bottomAnchor.constraint(equalTo: play_and_pause_image.topAnchor, constant: -10).isActive = true
        
        player_holder.addSubview(player)
        
        player.translatesAutoresizingMaskIntoConstraints = false
        player.playerLayer.videoGravity = .resizeAspect
        player.leftAnchor.constraint(equalTo: player_holder.leftAnchor, constant: 0).isActive = true
        player.bottomAnchor.constraint(equalTo: player_holder.bottomAnchor, constant: 0).isActive = true
        player.rightAnchor.constraint(equalTo: player_holder.rightAnchor, constant: 0).isActive = true
        player.topAnchor.constraint(equalTo: player_holder.topAnchor, constant: 0).isActive = true
        
        player_holder.addSubview(player_thumb)
        
        player_thumb.translatesAutoresizingMaskIntoConstraints = false
        player_thumb.leftAnchor.constraint(equalTo: player_holder.leftAnchor, constant: 0).isActive = true
        player_thumb.bottomAnchor.constraint(equalTo: player_holder.bottomAnchor, constant: 0).isActive = true
        player_thumb.rightAnchor.constraint(equalTo: player_holder.rightAnchor, constant: 0).isActive = true
        player_thumb.topAnchor.constraint(equalTo: player_holder.topAnchor, constant: 0).isActive = true
        
        player.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.8470588235)
        player_holder.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.8470588235)
        
        player_thumb.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.8470588235)
        
        player_thumb.contentMode = .scaleAspectFit
        
        thumb_one.image = generateThumbnail(url: url)
        thumb_two.image = generateThumbnail(url: url)
        
        player_thumb.image = thumb_one.image
        
        let avPlayer = AVPlayer(url: url)

        player.playerLayer.player = avPlayer
        player.playerLayer.isHidden = true

        selected_thumb.isUserInteractionEnabled = true
        let selectGesture = UITapGestureRecognizer(target: self, action: #selector(selectThumbnail))
        selected_thumb.addGestureRecognizer(selectGesture)
        
    }
    
    @objc func selectThumbnail(_ sender: UITapGestureRecognizer) {
        var config = YPImagePickerConfiguration()
        config.screens = [.library]
        config.showsVideoTrimmer = false
        config.library.mediaType = .photo
        config.showsPhotoFilters = false
        
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            if let image = items.singlePhoto {
                self.player_thumb.image = image.image
                self.selected_thumb.image = image.image
                self.choosen_image = image.image
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
           player.player?.pause()
    }
    
    @objc func pausePlayer(_ sender: UITapGestureRecognizer) {
        if isHidden {
            player_thumb.isHidden = false
            player.isHidden = true
            player.player?.pause()
            play_and_pause_image.image = UIImage(named: "play")
        } else {
            player_thumb.isHidden = true
            player.isHidden = false
            player.player?.play()
            play_and_pause_image.image = UIImage(named: "pause")
        }
        isHidden = !isHidden
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is UploadVideoDetailsViewController {
            let vc = segue.destination as? UploadVideoDetailsViewController
            vc?.video_url = url
            vc?.image = thumb_one.image
        }
    }
    
    @IBAction func setThumbnail(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        performSegue(withIdentifier: "uploadVideo", sender: self)
    }

    @IBAction func goBack(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func generateThumbnail(url: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imageGenerator.copyCGImage(at: .zero, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
    }
}
