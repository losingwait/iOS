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
    var exercise: Exercise?
    
    var player: AVQueuePlayer?
    var playerItem: AVPlayerItem?
    var timer: Timer?
    var timeElapsed: TimeInterval = 0
    
    var paused = false
    var exerciseIdxOffset = 1
    
    lazy var pauseItem: UIBarButtonItem = {
        UIBarButtonItem(image: #imageLiteral(resourceName: "pause-mini"), style: .plain, target: self, action: #selector(togglePause))
    }()
    
    lazy var playItem: UIBarButtonItem = {
        UIBarButtonItem(image: #imageLiteral(resourceName: "play-mini"), style: .plain, target: self, action: #selector(togglePause))
    }()

    lazy var backItem: UIBarButtonItem = {
        UIBarButtonItem(image: #imageLiteral(resourceName: "prev-mini"), style: .plain, target: self, action: nil)
    }()
    
    lazy var nextItem: UIBarButtonItem = {
        UIBarButtonItem(image: #imageLiteral(resourceName: "next-mini"), style: .plain, target: self, action: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alternatesTableView.dataSource = self
        alternatesTableView.delegate = self
        
        configurePopupItem()
        
        videoView.backgroundColor = .lightGray
        
        if let excercise = self.exercise {
            setActive(exercise: excercise)
        } else {
            setActive(exercise: workout?.exercies.first)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        createTimer()
      
        if player != nil && !paused {
            player?.play()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player?.currentItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
        player?.pause()
        player?.currentItem?.removeObserver(self, forKeyPath: "status")
    }
    
    func setActive(exercise: Exercise?) {
        timeElapsed = 0
        
        guard let exercise = exercise else {
            // RESET VIEW
            return
        }
        
        exerciseLabel.text = exercise.name
        setsLabel.text = "3"
        repsLabel.text = "\(exercise.reps)"
        playVideo(with: exercise.url)
    }
}

extension ActiveWorkoutViewController {
   
    func createTimer() {
        if timer == nil {
            let timer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(updateTimer),
                                         userInfo: nil,
                                         repeats: true)
            RunLoop.current.add(timer, forMode: .common)
            timer.tolerance = 0.1
            self.timer = timer
        }
    }
    
    @objc func updateTimer() {
        timeElapsed += 1
        elapsedLabel.text = timeElapsed.stringTime
    }
    
    @objc func togglePause() {
        videoTapped(UITapGestureRecognizer(target: nil, action: nil))
        
        if paused {
            popupItem.rightBarButtonItems = [pauseItem]
        } else {
            popupItem.rightBarButtonItems = [playItem]
        }
        
        paused = !paused
    }
    
    func configurePopupItem() {
        popupItem.image = #imageLiteral(resourceName: "arnold-chest")
        
        if workout == nil {
            popupItem.rightBarButtonItems = [pauseItem]
        } else {
            popupItem.rightBarButtonItems = [backItem, nextItem]
        }
        
        popupItem.title = workout == nil ? exercise?.name : workout?.name
    }
    
    func playVideo(with url: URL) {
        player?.removeAllItems()
        
        playerItem = AVPlayerItem(url: url)
        player = AVQueuePlayer(playerItem: playerItem)
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

extension ActiveWorkoutViewController {
    
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
}

extension ActiveWorkoutViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ExerciseTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        player?.currentItem?.removeObserver(self, forKeyPath: "status")
        
        exerciseIdxOffset += indexPath.row + 1
        
        guard let selectedExercise = workout?.exercies[exerciseIdxOffset - 1] else {
            return
        }
        
        setActive(exercise: selectedExercise)
        player?.currentItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowCnt = (workout?.exercies.count ?? 0) - exerciseIdxOffset
        return max(0, rowCnt)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseTableViewCell.identifier, for: indexPath) as? ExerciseTableViewCell else {
            return UITableViewCell()
        }
        
        guard let exercise = workout?.exercies[exerciseIdxOffset + indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configure(with: exercise, isCurrentWorkout: true)
        return cell
    }
}
