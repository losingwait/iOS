//
//  CustomsFormViewController.swift
//  LosingWait
//
//  Created by Karsen Keith on 4/11/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit
import Eureka

class CustomsFormViewController: FormViewController {
    
    var isExercise: Bool = true {
        didSet {
            if isExercise {
                form +++ Section("Custom Exercise")
                    // Exercise Name
                    <<< TextRow(){ row in
                        row.title = "Name"
                        row.placeholder = "Enter text here"
                    }
                    // Exercise Muscle
                    <<< PickerRow<String>("Muscle Picker Exercises") { (row : PickerRow<String>) -> Void in
                        
                        var muscleList: [String] = []
                        for item in WKManager.shared.muscles as! [Muscle] {
                            muscleList.append(item.name)
                        }
                        muscleList.sort()
                        row.options = muscleList
                    }
                    // Exercise Machine Group
                    <<< PickerRow<String>("Machine Group Picker Exercise") { (row : PickerRow<String>) -> Void in
                        
                        var groupList: [String] = []
                        for item in WKManager.shared.machine_groups as! [MachineGroup] {
                            groupList.append(item.name)
                        }
                        groupList.sort()
                        row.options = groupList
                    }
                
            } else {
                form +++ Section("Custom Workout")
                    <<< TextRow(){ row in
                        row.title = "Name"
                        row.placeholder = "Enter text here"
                    }
                    <<< TextRow(){ row in
                        row.title = "Description"
                        row.placeholder = "Enter text here"
                    }
                    
                +++ Section("Difficulty")
                    <<< SegmentedRow<String>() {
                        $0.options = ["Beginner", "Intermediate", "Advanced"]
                    }
                    
                +++ MultivaluedSection(multivaluedOptions: [.Insert, .Delete, .Reorder],
                       header: "Add Exercises",
                       footer: "") {
                        
                        var exerciseList: [String] = []
                        for item in WKManager.shared.exercises as! [Exercise] {
                            exerciseList.append(item.name)
                        }
                        exerciseList.sort()
                        
                        $0.tag = "push"
                        $0.multivaluedRowToInsertAt = { index in
                            return PushRow<String>{
                                $0.title = "Tap to select.."
                                $0.options = exerciseList
                            }
                        }
                                        
                    }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
