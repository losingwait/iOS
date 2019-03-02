//
//  WorkoutBrowseListViewController.swift
//  LosingWait
//
//  Created by Mike Choi on 2/25/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit

class WorkoutBrowseListViewController: UITableViewController {
    
    var data: [Muscle]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension WorkoutBrowseListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        //cell.textLabel?.text = data[indexPath.row]?.name
        return cell
    }
}
