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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = category
    
        if category == "Muscle" {
            WKManager.getMuscles { muscles in
                self.items = muscles
                self.tableView.reloadData()
            }
        } else if category == "Equipment" {
            WKManager.getMachineGroups { equipment in
                self.items = equipment
                self.tableView.reloadData()
            }
        } else if category == "Workout" {
            WKManager.getWorkouts { workouts in
                self.items = workouts
                self.tableView.reloadData()
            }
        } else if category == "Single Exercises" {
            WKManager.getSingleExercises { exercises in
                self.items = exercises
                self.tableView.reloadData()
            }
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
}
