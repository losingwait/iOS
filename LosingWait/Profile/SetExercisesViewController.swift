//
//  SetExercisesViewController.swift
//  LosingWait
//
//  Created by Karsen Keith on 4/15/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit
import Eureka

class SetExercisesViewController: FormViewController {
    
    var data: [String: Any?]?
    
    weak var delegate:WorkoutDetailsDelegate?
    
    var _isFilledOut: Bool = false
    var isFilledOut: Bool {
        get {
            data = form.values()
            _isFilledOut = true
            if data == nil {
                _isFilledOut = false
                
            } else {
                for (key, value) in data! {
                    if value == nil {
                        _isFilledOut = false
                    }
                }
            }
            
            return _isFilledOut
        }
        set(val) {
            _isFilledOut = val
        }
    }
    
    var exercises: [Any] = [] {
        didSet {
            for item in exercises {
                form +++ Section(item as! String)
                <<< TextRow("\(item)_reps") { row in
                    row.title = "Reps"
                    row.placeholder = "Number of Reps"
                }
                <<< TextRow("\(item)_sets") { row in
                    row.title = "Sets"
                    row.placeholder = "Number of Sets"
                }
            }
            
            form +++ Section()
            <<< ButtonRow("Submit Button") { row in
                row.title = "Submit"
                row.value = "Submit"
                row.onCellSelection(self.submitTapped)
            }
        }
    }
    
    func submitTapped(cell: ButtonCellOf<String>, row: ButtonRow) {
        data = form.values()
        if isFilledOut {
            data = form.values()
            delegate?.formFilledOut(data)
            navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Alert", message: "Please make sure all fields are filled.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        data = form.values()
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
