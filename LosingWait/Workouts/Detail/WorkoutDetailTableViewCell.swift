//
//  WorkoutDetailTableViewCell.swift
//  LosingWait
//
//  Created by Mike Choi on 3/25/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit

class WorkoutDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    static let identifier = "ExerciseCell"
    static let height: CGFloat = 55
}
