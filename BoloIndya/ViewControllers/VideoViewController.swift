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
    
    var selected_position = 0
    
    var current_video_cell: VideoCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setVideoViewDelegate()
    }

    func setVideoViewDelegate() {
        videoView.isScrollEnabled = true
        videoView.isPagingEnabled = true
        videoView.delegate = self
        videoView.dataSource = self
        videoView.register(VideoCell.self, forCellReuseIdentifier: "Cell")
    
        view.addSubview(videoView)
        
        let screenSize = UIScreen.main.bounds.size
        
        self.videoView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
    }
    
    func fetchData() {
        
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
        video_cell.tag = indexPath.row
        return video_cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let video_cell = self.videoView.visibleCells[0] as? VideoCell
        if current_video_cell != nil {
            current_video_cell.player.player?.pause()
        }
        current_video_cell = video_cell
        selected_position = video_cell?.tag ?? 0
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
    
    func goToProfile(with selected_postion: Int) {
        self.selected_position = selected_postion
    }

}
