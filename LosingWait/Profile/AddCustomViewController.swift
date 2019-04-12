//
//  AddCustomViewController.swift
//  LosingWait
//
//  Created by Karsen Keith on 4/11/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit
import Foundation
import Eureka

class AddCustomViewController: UIViewController {
    
    var category: String = ""
    var isExercise: Bool = false
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let childVC = children.first as? CustomsFormViewController else {
            fatalError("Couldnt get child form view controller")
        }

        // Do any additional setup after loading the view.
        isExercise = category == "Custom Exercises"
        self.title = isExercise ? "Add Exercise" : "Add Workout"
        
        childVC.isExercise = isExercise
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

