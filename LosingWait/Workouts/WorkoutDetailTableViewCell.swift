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
    @IBOutlet weak var availabilityLabel: UILabel!
    
    static let identifier = "ExerciseCell"
    static let height: CGFloat = 55
    
    func configure(with exercise: Exercise, isCurrentWorkout: Bool, index: IndexPath) {
        nameLabel.text = exercise.name
        setLabel.text = exercise.setDescription
        repLabel.text = exercise.repDescription
        
        if let machineID = exercise.machine_group_id,
            let machineGroup = WKManager.shared.machine_groups?.filter({ $0.id == machineID }).first, isCurrentWorkout == true {
            availabilityLabel.text = "-"
            availabilityLabel.backgroundColor = .lightGray
            if let queue = machineGroup.queue, queue.count > 0 {
                availabilityLabel.text = "Occupied"
                availabilityLabel.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            } else {
                availabilityLabel.text = "Available"
                availabilityLabel.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            }
        } else {
            numberLabel.isHidden = false
            numberLabel.text = "\(index.row + 1)"
        }
    }
}
