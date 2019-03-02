//
//  ActiveWorkoutViewController.swift
//  LosingWait
//
//  Created by Mike Choi on 3/1/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit

class ActiveWorkoutViewController: UIViewController {
    
    @IBOutlet weak var elapsedLabel: UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var workoutLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var alternatesTableView: UITableView!
    
    var workout: Workout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "prev-mini"), style: .plain, target: nil, action: nil)
        let next = UIBarButtonItem(image: #imageLiteral(resourceName: "next-mini"), style: .plain, target: nil, action: nil)
        popupItem.image = #imageLiteral(resourceName: "arnold-chest")
        popupItem.rightBarButtonItems = [back, next]
        popupItem.title = "Hello World"
    }
}
