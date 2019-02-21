//
//  WorkoutHeaderTableViewCell.swift
//  LosingWait
//
//  Created by Mike Choi on 2/21/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit

class WorkoutHeaderTableViewCell: UITableViewCell {
    
    static let identifier: String = "WorkoutHeaderTableViewCell"
    @IBOutlet private weak var mainTextLabel: UILabel!
    
    func configure(idx: IndexPath) {
        switch idx.row {
        case 0:
            mainTextLabel.text = "Browse"
        case 1:
            mainTextLabel.text = "Recently Viewed"
        case 2:
            mainTextLabel.text = "My Workouts"
        default:
            fatalError("Uh I don't know what this row is :(")
        }
    }
}
