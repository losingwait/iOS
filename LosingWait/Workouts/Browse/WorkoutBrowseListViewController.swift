//
//  WorkoutBrowseListViewController.swift
//  LosingWait
//
//  Created by Mike Choi on 2/25/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit

class WorkoutBrowseListViewController: UITableViewController {
    
    var category: String!
    var items: [Displayable] = []
    var clicked: Int = 0
    
    var originMuscle: Muscle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = category
    
        if category == "Muscle" {
            self.items = WKManager.shared.muscles!.sorted(by: {$0.name < $1.name})
            self.tableView.reloadData()
        } else if category == "Equipment" {
            self.items = WKManager.shared.machine_groups!.sorted(by: {$0.name < $1.name})
            self.tableView.reloadData()
        } else if category == "Workout" {
            self.items = WKManager.shared.workouts!.sorted(by: {$0.name < $1.name})
            self.tableView.reloadData()
        } else if category == "Single Exercises" {
            self.items = WKManager.shared.exercises!.sorted(by: {$0.name < $1.name})
            self.tableView.reloadData()
        } else if category == "Muscle Exercises" {
            self.items = (WKManager.shared.exercises?.filter{$0.muscle_id == originMuscle?.id})!
            self.category = "Single Exercises"
            title = (originMuscle?.name ?? "Muscle") + " Exercises"
            self.tableView.reloadData()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "machineDetails" {
            let vc = segue.destination as? MachineGroupDetailViewController
            vc?.group = items[clicked] as? MachineGroup
        }
    }
}

extension WorkoutBrowseListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clicked = indexPath.row
        if category == "Muscle" {
            let workoutStoryboard = UIStoryboard(name: "Workouts", bundle: nil)
            guard let vc = workoutStoryboard.instantiateViewController(withIdentifier: "WorkoutBrowseListViewController") as? WorkoutBrowseListViewController else {
                return
            }
            vc.category = "Muscle Exercises"
            vc.originMuscle = items[indexPath.row] as? Muscle
            navigationController?.pushViewController(vc, animated: true)
        } else if category == "Equipment" {
            performSegue(withIdentifier: "machineDetails", sender: self)
        } else if category == "Workout" {
            let workoutStoryboard = UIStoryboard(name: "Workouts", bundle: nil)
            guard let vc = workoutStoryboard.instantiateViewController(withIdentifier: "WorkoutDetailViewController") as? WorkoutDetailViewController else {
                return
            }
            guard let selectedWorkout = items[indexPath.row] as? Workout else {
                fatalError("Couldn't load workout")
            }
            vc.workout = selectedWorkout
            navigationController?.pushViewController(vc, animated: true)
        } else if category == "Single Exercises" {
            guard let targetExercise = items[indexPath.row] as? Exercise else {
                fatalError("Couldn't load exercise")
            }
            let vc = targetExercise.viewController
            tabBarController?.popupBar.tintColor = UIColor(white: 38.0 / 255.0, alpha: 1.0)
            tabBarController?.popupBar.imageView.layer.cornerRadius = 5
            tabBarController?.presentPopupBar(withContentViewController: vc, animated: true, completion: nil)
        }
    }
}
