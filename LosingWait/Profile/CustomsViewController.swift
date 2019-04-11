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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = category
        
        if category == "Custom Exercises" {
            self.items = WKManager.shared.exercises!
        } else if category == "Custom Workouts" {
            self.items = WKManager.shared.workouts!
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
