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
        if segue.identifier == "showDetails" {
            let vc = segue.destination as? BrowseDetailViewController
            
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
//        performSegue(withIdentifier: "showDetails", sender: self)
    }
}
