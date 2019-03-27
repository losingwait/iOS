//
//  ExerciseTableViewCell.swift
//  LosingWait
//
//  Created by Mike Choi on 3/25/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var repLabel: UILabel!
    
    static let identifier = "ExerciseCell"
    static let height: CGFloat = 55
    
    func configure(with exercise: Exercise, isCurrentWorkout: Bool) {
        numberLabel.isHidden = true
        nameLabel.text = exercise.name
        setLabel.text = "3 Sets"
        repLabel.text = "\(exercise.reps) Reps"
    }
}
