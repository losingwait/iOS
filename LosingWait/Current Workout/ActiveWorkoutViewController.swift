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
    
    @IBOutlet weak var playButton: UIButton!
    
    var workout: Workout?
    var exercise: Exercise?
    
    var player: AVQueuePlayer?
    var playerItem: AVPlayerItem?
    var observer: NSKeyValueObservation?
    
    var timer: Timer?
    var timeElapsed: TimeInterval = 0
    
    var _paused = false
    var paused : Bool {
        set {
            _paused = newValue
            updatePopupItem()
        } get {
            return _paused
        }
    }
    
    var _idx: Int = 0
    var currentExerciseIdx: Int {
        set {
            _idx = newValue
            updatePopupItem()
        } get {
            return _idx
        }
    }
    
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
        
        alternatesTableView.dataSource = self
        alternatesTableView.delegate = self
        
        configurePopupItem()

        videoView.backgroundColor = .lightGray
        
        if let excercise = self.exercise {
            setActive(exercise: excercise)
        } else {
            setActive(exercise: workout?.exercises.first)
        }
        
        registerForPreviewing(with: self, sourceView: alternatesTableView)
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
        
        exerciseLabel.text = targetExercise.name
        setsLabel.text = exercise.sets ?? "-"
        repsLabel.text = exercise.reps ?? "-"
        playVideo(with: URL(string: targetExercise.exercise_media!)!)
    }
    
    @IBAction func previous(_ sender: Any) {
        if currentExerciseIdx != 0 {
            currentExerciseIdx -= 1
        }
        
        setActive(exercise: workout?.exercises[currentExerciseIdx])
        alternatesTableView.reloadData()
    }
    
    @IBAction func toggleWorkoutPause(_ sender: Any) {
        togglePause()
    }
    
    @IBAction func next(_ sender: Any) {
        guard let exercises = workout?.exercises else {
            return
        }
        
        if currentExerciseIdx != exercises.count - 1 {
            currentExerciseIdx += 1
        }
        
        setActive(exercise: workout?.exercises[currentExerciseIdx])
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

        updatePopupItem()
    }
    
    func updatePopupItem() {
        if workout == nil {
            popupItem.title = exercise?.name
        } else {
            let currentExercise = workout?.exercises[currentExerciseIdx]
            popupItem.title = currentExercise?.name
            popupItem.subtitle = workout?.name
        }
    }
    
    func playVideo(with url: URL) {
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
}

extension ActiveWorkoutViewController {
    
    @IBAction func videoTapped(_ sender: UITapGestureRecognizer) {
        if player == nil {
            return
        }
        
        setMediaState(play: !(player!.isPlaying))
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

extension ActiveWorkoutViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ExerciseTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        currentExerciseIdx += indexPath.row + 1
        guard let selectedExercise = workout?.exercises[currentExerciseIdx] else {
            return
        }
        
        setActive(exercise: selectedExercise)
       
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowCnt = (workout?.exercises.count ?? 0) - currentExerciseIdx - 1
        return max(0, rowCnt)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseTableViewCell.identifier, for: indexPath) as? ExerciseTableViewCell else {
            return UITableViewCell()
        }
        
        guard let exercise = workout?.exercises[currentExerciseIdx + indexPath.row + 1],
            let targetExercise = WKManager.shared.exercises?.filter( {$0.name == exercise.name }).first else {
            return UITableViewCell()
        }
        
        cell.configure(with: targetExercise, isCurrentWorkout: true, index: indexPath)
        cell.repLabel.text = exercise.repDescription
        cell.setLabel.text = exercise.setDescription
        return cell
    }
}

extension ActiveWorkoutViewController : UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = alternatesTableView.indexPathForRow(at: location),
            let cell = alternatesTableView.cellForRow(at: indexPath) else {
            return nil
        }
        
        previewingContext.previewingGestureRecognizerForFailureRelationship.addObserver(self, forKeyPath: "state", options: .new, context: nil)
        
        let detailViewController = UIViewController()
        detailViewController.view.backgroundColor = .blue
        detailViewController.preferredContentSize = CGSize(width: 0.0, height: 300.0)
        previewingContext.sourceRect = cell.frame
        return detailViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let object = object else {
            return
        }
        
        if keyPath == "state" {
            let newValue = change![NSKeyValueChangeKey.newKey] as! Int
            let state = UIGestureRecognizer.State(rawValue: newValue)!
            switch state {
            case .began, .changed:
                (object as! UIGestureRecognizer).isEnabled = false
                print("began|changed")
                
            case .ended, .failed, .cancelled:
                print("ended|cancelled")
                //(object as AnyObject).removeObserver(self, forKeyPath: "state")
                
                DispatchQueue.main.async(execute: {
                    (object as! UIGestureRecognizer).isEnabled = true
                })

            case .possible:
                break
            }
        }
    }
}
