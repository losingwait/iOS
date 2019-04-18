//
//  CustomsFormViewController.swift
//  LosingWait
//
//  Created by Karsen Keith on 4/11/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit
import Eureka

class CustomsFormViewController: FormViewController  {
    
    var exercisesArray: [Any]?
    
    func getFormValues() -> [String : Any?]? {
        return form.values()
    }
    
    var _isFilledOut: Bool = false
    var isFilledOut: Bool {
        get {
            var entries = form.values()
            
            
            if isExercise {
                if entries["Exercise Name"]! == nil {
                    _isFilledOut = false
                } else {
                    _isFilledOut = true
                }
            } else {
                let values = (entries["Add Exercises"]!! as! [Any?]).compactMap { $0 } // gets values from multivaluedSection
                exercisesArray = values
                
                if entries["Workout Name"]! == nil {
                    _isFilledOut = false
                } else if entries["Workout Description"] == nil {
                    _isFilledOut = false
                } else if entries["Difficulty"]! == nil {
                    _isFilledOut = false
                } else if values.isEmpty {
                    _isFilledOut = false
                } else {
                    _isFilledOut = true
                }
                
            }
            
            return _isFilledOut
        }
        set(val) {
            _isFilledOut = val
        }
    }
    
    var isExercise: Bool = true {
        didSet {
            let hideExercise: Bool = !isExercise
            let hideWorkout: Bool = isExercise
            form +++ Section("Custom Exercise") {$0.hidden = hideExercise ? true : false}
                /********** EXERCISE ROWS ************/
                // Exercise Name
                <<< TextRow("Exercise Name"){ row in
                    row.title = "Name"
                    row.placeholder = "Enter text here"
                    row.hidden = hideExercise ? true : false
                }
                +++ Section("Muscle Group Worked") {$0.hidden = hideExercise ? true : false}
                // Exercise Muscle
                <<< PickerRow<String>("Muscle Picker Exercises") { (row : PickerRow<String>) -> Void in
                    
                    var muscleList: [String] = []
                    for item in WKManager.shared.muscles as! [Muscle] {
                        muscleList.append(item.name)
                    }
                    muscleList.sort()
                    row.options = muscleList
                    row.hidden = hideExercise ? true : false
                }
                +++ Section("Machine Used") {$0.hidden = hideExercise ? true : false}
                // Exercise Machine Group
                <<< PickerRow<String>("Machine Group Picker Exercise") { (row : PickerRow<String>) -> Void in
                    
                    var groupList: [String] = []
                    for item in WKManager.shared.machine_groups as! [MachineGroup] {
                        groupList.append(item.name)
                    }
                    groupList.sort()
                    row.options = groupList
                    row.hidden = hideExercise ? true : false
                }
            
                /********** WORKOUT ROWS ************/
                +++ Section("Custom Workout") {$0.hidden = hideWorkout ? true : false}
                <<< TextRow("Workout Name"){ row in
                    row.title = "Name"
                    row.placeholder = "Enter text here"
                    row.hidden = hideWorkout ? true : false
                }
                <<< TextRow("Workout Description"){ row in
                    row.title = "Description"
                    row.placeholder = "Enter text here"
                    row.hidden = hideWorkout ? true : false
                }
                
                +++ Section("Difficulty") {$0.hidden = hideWorkout ? true : false}
                <<< SegmentedRow<String>("Difficulty") {
                    $0.options = ["Beginner", "Intermediate", "Advanced"]
                    $0.hidden = hideWorkout ? true : false
                }
                
                +++ MultivaluedSection(multivaluedOptions: [.Insert, .Delete, .Reorder], header: "Add Exercises", footer: "") {
                        
                    var exerciseList: [String] = []
                    for item in WKManager.shared.exercises as! [Exercise] {
                        exerciseList.append(item.name)
                    }
                    exerciseList.sort()
        
                    $0.hidden = hideWorkout ? true : false
                    $0.tag = "Add Exercises"
                    $0.multivaluedRowToInsertAt = { index in
                        return PushRow<String>("tag_\(index)"){
                            $0.title = "Tap to select.."
                            $0.options = exerciseList
                        }
                    }
                }
            
        }
    }
    


    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }

}
