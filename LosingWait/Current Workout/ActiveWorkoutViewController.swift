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
    
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
    
    var workout: Workout?
    var exercise: Exercise?
    
    var player: AVQueuePlayer?
    var playerItem: AVPlayerItem?
    var observer: NSKeyValueObservation?
    
    var timer: Timer?
    var timeElapsed: TimeInterval = 0
    
    var paused : Bool = false {
        didSet {
            updatePopupItem(currentIndex: manager.currentExerciseIdx)
        }
    }
    
    lazy var manager: ActiveWorkoutTableManager = {
        let manager = ActiveWorkoutTableManager(workout: workout, exercise: exercise)
        manager.popupDelegate = self
        return manager
    }()
    
    lazy var pauseItem: UIBarButtonItem = {
        UIBarButtonItem(image: #imageLiteral(resourceName: "pause-mini"), style: .plain, target: self, action: #selector(togglePause))
    }()
    
    lazy var playItem: UIBarButtonItem = {
        UIBarButtonItem(image: #imageLiteral(resourceName: "play-mini"), style: .plain, target: self, action: #selector(togglePause))
    }()

    lazy var backItem: UIBarButtonItem = {
        UIBarButtonItem(image: #imageLiteral(resourceName: "prev-mini"), style: .plain, target: self, action: #selector(previous(_:)))
    }()
    
    lazy var nextItem: UIBarButtonItem = {
        UIBarButtonItem(image: #imageLiteral(resourceName: "next-mini"), style: .plain, target: self, action: #selector(next(_:)))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alternatesTableView.dataSource = manager
        alternatesTableView.delegate = manager
        alternatesTableView?.sectionHeaderHeight = 55
        alternatesTableView?.register(ExpandableTableHeaderView.nib, forHeaderFooterViewReuseIdentifier: ExpandableTableHeaderView.identifier)
        stackViewHeightConstraint.constant = CGFloat((workout?.exercises.count ?? 0 + 2) * 55)
        
        configurePopupItem()

        videoView.backgroundColor = .black
        
        if let excercise = self.exercise {
            setActive(exercise: excercise)
        } else {
            setActive(exercise: workout?.exercises.first)
        }
        
        favoriteButton.setImage(#imageLiteral(resourceName: "star_selected"), for: UIControl.State.selected.union(.highlighted))
        NotificationCenter.default.addObserver(self, selector: #selector(videoFinishedPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        if player != nil && !paused {
            player?.play()
            createTimer()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
        timer = nil
        player?.pause()
        
        if observer != nil {
            observer?.invalidate()
        }
    }
    
    func setActive(exercise: Exercise?) {
        timeElapsed = 0
        
        guard let exercise = exercise,
            let allExercises = WKManager.shared.exercises,
            let targetExercise = allExercises.filter({ $0.name == exercise.name }).first else {
            return
        }
        
        self.exercise = targetExercise
        
        exerciseLabel.text = targetExercise.name
        setsLabel.text = exercise.sets ?? "-"
        repsLabel.text = exercise.reps ?? "-"
        playVideo(with: URL(string: targetExercise.exercise_media!)!)
    }
    
    @IBAction func previous(_ sender: Any) {
        if manager.currentExerciseIdx != 0 {
            manager.currentExerciseIdx -= 1
        }
        
        setActive(exercise: workout?.exercises[manager.currentExerciseIdx])
        alternatesTableView.reloadData()
    }
    
    @IBAction func toggleWorkoutPause(_ sender: Any) {
        togglePause()
    }
    
    @IBAction func favoritePressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func locationPressed(_ sender: Any) {
        
    }
    
    @IBAction func replayPressed(_ sender: Any) {
        guard let currentExercise = exercise else {
            return
        }
        playVideo(with: URL(string: currentExercise.exercise_media!)!)
    }
    
    @IBAction func next(_ sender: Any) {
        guard let exercises = workout?.exercises else {
            return
        }
        
        if manager.currentExerciseIdx != exercises.count - 1 {
            manager.currentExerciseIdx += 1
        }
        
        setActive(exercise: workout?.exercises[manager.currentExerciseIdx])
        alternatesTableView.reloadData()
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
        if paused {
            setMediaState(play: true)
            playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            popupItem.rightBarButtonItems = workout == nil ? [pauseItem] : [backItem, pauseItem, nextItem]
            createTimer()
        } else {
            setMediaState(play: false)
            playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            popupItem.rightBarButtonItems = workout == nil ? [playItem] : [backItem, playItem, nextItem]
            timer?.invalidate()
            timer = nil
        }
        
        paused = !paused
    }
    
    func configurePopupItem() {
        popupItem.image = #imageLiteral(resourceName: "arnold-chest")
        
        if workout == nil {
            popupItem.rightBarButtonItems = [pauseItem]
        } else {
            popupItem.rightBarButtonItems = [backItem, pauseItem, nextItem]
        }

        updatePopupItem(currentIndex: manager.currentExerciseIdx)
    }
    
    func playVideo(with url: URL) {
        replayButton.isHidden = true
        player?.removeAllItems()
        
        playerItem = AVPlayerItem(url: url)
        
        observer = playerItem?.observe(\.status, options:  [.new, .old], changeHandler: { (playerItem, change) in
            if playerItem.status == .readyToPlay && !self.paused {
                self.player?.play()
                self.player?.rate = 1.0
            }
        })
        
        player = AVQueuePlayer(playerItem: playerItem)
        player?.allowsExternalPlayback = true

        let layer = AVPlayerLayer(player: player)
        layer.frame = videoView.bounds
        layer.videoGravity = .resizeAspectFill
        videoView.layer.addSublayer(layer)
    }
    
    @objc func videoFinishedPlaying() {
        replayButton.isHidden = false
    }
}

extension ActiveWorkoutViewController {
    
    @IBAction func videoTapped(_ sender: UITapGestureRecognizer) {
        if player == nil {
            return
        }
        
        togglePause()
    }
    
    func setMediaState(play: Bool) {
        if play {
            self.player?.play()
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                self.videoView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        } else {
            self.player?.pause()
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                self.videoView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }, completion: nil)
        }
    }
}

extension ActiveWorkoutViewController: PopupUpdater {
    
    func updatePopupItem(currentIndex: Int) {
        if workout == nil {
            popupItem.title = exercise?.name
        } else {
            let currentExercise = workout?.exercises[currentIndex]
            popupItem.title = currentExercise?.name
            popupItem.subtitle = workout?.name
        }
    }
    
    func updateTableViewHeight(numRows: Int, refreshSection: IndexSet) {
        alternatesTableView.beginUpdates()
        stackViewHeightConstraint.constant = CGFloat(55 * numRows)
        alternatesTableView.reloadSections(refreshSection, with: .fade)
        alternatesTableView.endUpdates()
    }
}
