//
//  WorkoutBrowseListViewController.swift
//  LosingWait
//
//  Created by Mike Choi on 2/25/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit

class WorkoutBrowseListViewController: UITableViewController {
    
    var category:Int = 0
    var muscles: [Muscle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(category == 0) {
            title = "Workouts"
        } else if(category == 1) {
            title = "Muscles"
            WKManager.getMuscles { muscles in
                self.muscles = muscles
                self.tableView.reloadData()
            }
        } else if(category == 2) {
            title = "Equipment"
        }
    }
}

extension WorkoutBrowseListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category == 1 ? muscles.count : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        if(category == 0) {
            // list workouts here
        } else if(category == 1) {
            cell.textLabel?.text = muscles[indexPath.row].name
        } else if(category == 2) {
            // list equipment here
        }
        return cell
    }
}
