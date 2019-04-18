//
//  CustomsViewController.swift
//  LosingWait
//
//  Created by Karsen Keith on 4/10/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit

class CustomsViewController: UITableViewController {

    var category: String = ""
    var items: [Displayable] = []
    var exercises: [Exercise] = []
    var workouts: [Workout] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = category
        
        if category == "Custom Exercises" {
            self.exercises = WKManager.shared.customExercises?.sorted(by: {$0.name < $1.name}) ?? []
        } else if category == "Custom Workouts" {
            self.workouts = WKManager.shared.customWorkouts?.sorted(by: {$0.name < $1.name}) ?? []
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCustomSegue" {
            guard let vc = segue.destination as? UINavigationController else {
                fatalError("Expected UINavigationController")
            }
            
            guard let childVC = vc.children.first as? AddCustomViewController else {
                fatalError("Expected AddCustomViewController")
            }
            
            childVC.category = self.category
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if category == "Custom Exercises" {
            WKManager.shared.getCustomSingleExercises(completion: { ok in
                self.exercises = WKManager.shared.customExercises?.sorted(by: {$0.name < $1.name}) ?? []
                self.tableView.reloadData()
            })
        } else if category == "Custom Workouts" {
            WKManager.shared.getCustomWorkouts(completion: {ok in
                self.workouts = WKManager.shared.customWorkouts?.sorted(by: {$0.name < $1.name}) ?? []
                self.tableView.reloadData()
            })
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CustomsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category == "Custom Exercises" ? exercises.count : workouts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = category == "Custom Exercises" ? exercises[indexPath.row].name : workouts[indexPath.row].name
        return cell
    }
}
