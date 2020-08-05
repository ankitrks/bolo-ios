//
//  VideoViewController.swift
//  BoloIndya
//
//  Created by apple on 7/14/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import AVFoundation

class VideoViewController: UIViewController {

    var videos: [Topic] = []
    var videoView = UITableView()
    var go_back =  UIImageView()
    
    var selected_position = 0
    var isLoaded: Bool = false
    var self_user: Bool = false
    
    var current_video_cell: VideoCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setVideoViewDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    func setVideoViewDelegate() {
        view.addSubview(videoView)
        view.addSubview(go_back)
        
        videoView.translatesAutoresizingMaskIntoConstraints = false
        videoView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        videoView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        videoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        videoView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        
        videoView.isScrollEnabled = true
        videoView.isPagingEnabled = true
        videoView.delegate = self
        videoView.dataSource = self
        videoView.register(VideoCell.self, forCellReuseIdentifier: "Cell")
        
        go_back.translatesAutoresizingMaskIntoConstraints = false
        go_back.widthAnchor.constraint(equalToConstant: 40).isActive = true
        go_back.heightAnchor.constraint(equalToConstant: 40).isActive = true
        go_back.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5).isActive = true
        go_back.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        
        go_back.image = UIImage(named: "close")
        go_back.tintColor = UIColor.white
        
        go_back.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goBack(_:)))
        go_back.addGestureRecognizer(tapGesture)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if current_video_cell != nil {
            current_video_cell.player.player?.pause()
        }
    }
    
    func fetchData() {
        
    }
    
    @objc func goBack(_ sender: UITapGestureRecognizer) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ProfileViewController {
            let vc = segue.destination as? ProfileViewController
            vc?.user = videos[selected_position].user
        }
    }

}

extension VideoViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let video_cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! VideoCell
        video_cell.title.text = videos[indexPath.row].title.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        let url = URL(string: videos[indexPath.row].thumbnail)
        video_cell.video_image.kf.setImage(with: url)
        video_cell.username.text = "@"+videos[indexPath.row].user.username
        if selected_position == indexPath.row {
           if current_video_cell != nil {
               current_video_cell.player.player?.pause()
           }
           
           current_video_cell = video_cell
           let videoUrl = NSURL(string: videos[indexPath.row].video_url)
           let avPlayer = AVPlayer(url: videoUrl! as URL)

           video_cell.player.playerLayer.player = avPlayer
           video_cell.player.player?.play()
        }
        if (!videos[indexPath.row].user.profile_pic.isEmpty) {
            let pic_url = URL(string: videos[indexPath.row].user.profile_pic)
            video_cell.user_image.kf.setImage(with: pic_url)
        }
        if (!self.isLoaded && indexPath.row <= selected_position) {
            if (indexPath.row == selected_position) {
                self.isLoaded = true
                self.videoView.scrollToRow(at: IndexPath(row:  indexPath.row, section: 0), at: .none, animated: false)
            } else {
                self.videoView.scrollToRow(at: IndexPath(row:  indexPath.row + 1 , section: 0), at: .none, animated: false)
            }
        }
        video_cell.tag = indexPath.row
        video_cell.selected_postion = indexPath.row
        video_cell.delegate = self
        return video_cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let video_cell = self.videoView.visibleCells[0] as? VideoCell
        if current_video_cell != nil {
            current_video_cell.player.player?.pause()
        }
        current_video_cell = video_cell
        selected_position = video_cell?.tag ?? 0
        print(videos[video_cell?.tag ?? 0].video_url)
        let videoUrl = NSURL(string: videos[video_cell?.tag ?? 0].video_url)
        let avPlayer = AVPlayer(url: videoUrl! as URL)

        current_video_cell.player.playerLayer.player = avPlayer
        current_video_cell.player.player?.play()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        
        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
            self.fetchData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension VideoViewController: VideoCellDelegate {
    func renderComments(with selected_postion: Int) {
        
    }
    
    func goToProfile(with selected_postion: Int) {
        if self.self_user {
            if current_video_cell != nil {
                current_video_cell.player.player?.pause()
            }
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.selected_position = selected_postion
            self.performSegue(withIdentifier: "videoProfile", sender: self)
            self.tabBarController?.tabBar.isHidden = true
        }
    }

    func downloadAndShareVideoWhatsapp(with selected_postion: Int) {
        let videoUrl = videos[selected_postion].video_url

        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let destinationUrl = docsUrl.appendingPathComponent("boloindya_videos"+videos[selected_postion].id+".mp4")
        if(FileManager().fileExists(atPath: destinationUrl.path)){
            let activityController = UIActivityViewController(activityItems: [destinationUrl], applicationActivities: nil)
            activityController.completionWithItemsHandler = { (nil, completed, _, error) in
                if completed {
                    print("completed")
                } else {
                    print("error")
                }
            }
            self.present(activityController, animated: true) {
                print("Done")
            }
            print("\n\nfile already exists\n\n")
        } else{
            var request = URLRequest(url: URL(string: videoUrl)!)
            request.httpMethod = "GET"
            _ = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if(error != nil){
                print("\n\nsome error occured\n\n")
                return
            }
            if let response = response as? HTTPURLResponse{
                if response.statusCode == 200 {
                    DispatchQueue.main.async {
                        if let data = data{
                            if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic){
                                
                                print("\n\nurl data written\n\n")
                                print(destinationUrl)
                                let activityController = UIActivityViewController(activityItems: [destinationUrl], applicationActivities: nil)
                                activityController.completionWithItemsHandler = { (nil, completed, _, error) in
                                    if completed {
                                        print("completed")
                                    } else {
                                        print("error")
                                    }
                                    
                                    }
                                    self.present(activityController, animated: true) {
                                }
                            
                            }
                            else{
                                print("\n\nerror again\n\n")
                            }
                        }
                    }
                }
            }
        }).resume()
            
        }
    }
}
