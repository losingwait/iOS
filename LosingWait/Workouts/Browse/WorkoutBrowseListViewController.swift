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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = category
    
        if category == "Muscle" {
            self.items = WKManager.shared.muscles!
            self.tableView.reloadData()
        } else if category == "Equipment" {
            self.items = WKManager.shared.machine_groups!
            self.tableView.reloadData()
        } else if category == "Workout" {
            self.items = WKManager.shared.workouts!
            self.tableView.reloadData()
        } else if category == "Single Exercises" {
            self.items = WKManager.shared.exercises!
            self.tableView.reloadData()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "machineDetails" {
            let vc = segue.destination as? MachineGroupDetailViewController
            vc?.group = items[clicked] as? MachineGroup
        } else if segue.identifier == "muscleDetails" {
            print("muscle segue not done yet")
        } else if segue.identifier == "workoutDetails" {
            print("workout segue not done yet")
        } else if segue.identifier == "exerciseDetails" {
            print("exercise segue not done yet")
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
        // logic here
//        print(items[indexPath.row].name + " clicked")
        clicked = indexPath.row
        if category == "Muscle" {
//            performSegue(withIdentifier: "muscleDetails", sender: self)
        } else if category == "Equipment" {
            performSegue(withIdentifier: "machineDetails", sender: self)
        } else if category == "Workout" {
//            performSegue(withIdentifier: "workoutDetails", sender: self)
        } else if category == "Single Exercises" {
//            performSegue(withIdentifier: "exerciseDetails", sender: self)
        }
    }
}
