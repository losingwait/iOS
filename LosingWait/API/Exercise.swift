//
//  Exercise.swift
//  LosingWait
//
//  Created by Mike Choi on 2/25/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import Foundation
import UIKit

struct Exercise: Displayable {
    let name: String
    let id: String
    
    var muscle_id: String?
    var machine_group_id: String?
    var exercise_media: String?
    
    var reps: String?
    var sets: String?
    
    init(response: [String : Any]) {
        id = response["_id"] as! String
        name = response["name"] as! String
        muscle_id = response["muscle_id"] as? String
        machine_group_id = response["machine_group_id"] as? String
        exercise_media = response["exercise_media"] as? String
    }
    
    init(id: String, name: String, reps: String, sets: String) {
        self.id = id
        self.name = name
        self.reps = reps
        self.sets = sets
    }
    
    var viewController: ActiveWorkoutViewController {
        let storyboard = UIStoryboard(name: "CurrentWorkout", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ActiveWorkoutViewController") as! ActiveWorkoutViewController
        vc.exercise = self
        return vc
    }
}

extension Exercise {
    var setDescription: String {
        return "\(sets ?? "-") Sets"
    }
    
    var repDescription: String {
        if reps == "To Failure" {
            return reps ?? "-"
        } else {
            return "\(reps ?? "-") Sets"
        }
    }
}
