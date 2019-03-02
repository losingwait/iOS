//
//  ActiveWorkoutViewController.swift
//  LosingWait
//
//  Created by Mike Choi on 3/1/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit
import AVFoundation

class ActiveWorkoutViewController: UIViewController {
    
    @IBOutlet weak var elapsedLabel: UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var workoutLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var alternatesTableView: UITableView!
    
    var workout: Workout?
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePopupItem()
        initializeVideoPlayerWithVideo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if player != nil {
            player?.play()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player?.pause()
    }
    
    func configurePopupItem() {
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "prev-mini"), style: .plain, target: nil, action: nil)
        let next = UIBarButtonItem(image: #imageLiteral(resourceName: "next-mini"), style: .plain, target: nil, action: nil)
        popupItem.image = #imageLiteral(resourceName: "arnold-chest")
        popupItem.rightBarButtonItems = [back, next]
        popupItem.title = "Hello World"
    }
    
    func initializeVideoPlayerWithVideo(){
        videoView.backgroundColor = .lightGray
        
        playerItem =  AVPlayerItem(url: URL(string: "https://videos.bodybuilding.com/video/mp4/70000/71792l.mp4")!)
        player = AVPlayer(playerItem: playerItem)
        player?.allowsExternalPlayback = true

        let layer = AVPlayerLayer(player: player)
        layer.frame = videoView.bounds
        layer.videoGravity = .resizeAspectFill
        videoView.layer.addSublayer(layer)
        
        player?.currentItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let currentPlayer = player,
            let playerObject = object as? AVPlayerItem,
            playerObject == currentPlayer.currentItem,
            keyPath == "status" {
            
            if currentPlayer.currentItem!.status == .readyToPlay {
                currentPlayer.play()
                currentPlayer.rate = 1.0
            }
        }
    }
}
