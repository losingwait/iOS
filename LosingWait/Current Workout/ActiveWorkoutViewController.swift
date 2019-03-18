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
    
    var exercise: Exercise?
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePopupItem()
        initializeVideoPlayerWithVideo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.currentItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
        if player != nil {
            player?.play()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player?.pause()
        player?.currentItem?.removeObserver(self, forKeyPath: "status")
    }
    
    @IBAction func videoTapped(_ sender: UITapGestureRecognizer) {
        if player == nil {
            return
        }
        
        if player!.isPlaying {
            self.player?.pause()
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                self.videoView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }, completion: nil)
            
        } else {
            self.player?.play()
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                self.videoView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        }
    }
    
    func configurePopupItem() {
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "prev-mini"), style: .plain, target: nil, action: nil)
        let next = UIBarButtonItem(image: #imageLiteral(resourceName: "next-mini"), style: .plain, target: nil, action: nil)
        popupItem.image = #imageLiteral(resourceName: "arnold-chest")
        popupItem.rightBarButtonItems = [back, next]
        popupItem.title = exercise?.name
    }
    
    func initializeVideoPlayerWithVideo(){
        videoView.backgroundColor = .lightGray
        
        playerItem =  AVPlayerItem(url: URL(string: "https://content.jwplatform.com/videos/FcwwX2gf-1zuboWt3.mp4")!)
        player = AVPlayer(playerItem: playerItem)
        player?.allowsExternalPlayback = true

        let layer = AVPlayerLayer(player: player)
        layer.frame = videoView.bounds
        layer.videoGravity = .resizeAspectFill
        videoView.layer.addSublayer(layer)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let currentPlayer = player,
            let playerObject = object as? AVPlayerItem,
            playerObject == currentPlayer.currentItem,
            keyPath == "status" {
            if playerObject.status == .readyToPlay {
                currentPlayer.play()
                currentPlayer.rate = 1.0
            }
        }
    }
}
