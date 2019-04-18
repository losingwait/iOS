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
    
    var user_id: String?
    
    init(response: [String : Any]) {
        id = response["_id"] as! String
        name = response["name"] as! String
        muscle_id = response["muscle_id"] as? String
        machine_group_id = response["machine_group_id"] as? String
        exercise_media = response["exercise_media"] as? String
        user_id = response["user_id"] as? String
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
    
    var setDescription: String {
        return "\(sets ?? "-") Sets"
    }
    
    var repDescription: String {
        if reps == "To Failure" {
            return reps ?? "-"
        } else {
            return "\(reps ?? "-") Reps"
        }
    }
    
    var similar: [Exercise] {
        let exercises = WKManager.shared.exercises?.filter( { $0.muscle_id == self.muscle_id && $0.name != self.name }) ?? []
        return exercises.sorted { (lfs, rhs) -> Bool in
            return lfs.machineGroup.queue?.count ?? 0 > rhs.machineGroup.queue?.count ?? 0
        }
    }
    
    var machineGroup: MachineGroup {
        var betterSelf: Exercise
        if self.user_id == nil {
            betterSelf = WKManager.shared.exercises!.filter({ $0.name == self.name }).first!
        } else {
            betterSelf = WKManager.shared.customExercises!.filter({ $0.name == self.name }).first!
        }
        return WKManager.shared.machine_groups!.filter({ $0.id == betterSelf.machine_group_id ?? "" }).first!
    }
    
    func machines(completion: @escaping ([Machine]) -> ()) {
        WKManager.shared.getMachines { machines in
            let matchingMachines = machines.filter({ $0.machine_group_id == self.machine_group_id })
            completion(matchingMachines)
        }
    }
}
