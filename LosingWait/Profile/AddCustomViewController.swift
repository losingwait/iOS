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
import Alamofire

class AddCustomViewController: UIViewController, WorkoutDetailsDelegate {
    
    var category: String = ""
    var isExercise: Bool = false
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var workoutFormValues: [String : Any?]?
    var exerciseFormValues: [String : Any?]?
    var exerciseDetails: [String : Any?]?
    
    
    func formFilledOut(_ data: [String : Any?]?) {
        exerciseDetails = data
        
        // GET DATA FROM THE FORMS AND FORMAT FOR ALAMOFIRE
        WKManager.shared.getSingleExercises(completion: { ok in
            // basic strings
            let userWorkoutName: String = self.workoutFormValues!["Workout Name"]!! as! String
            let userWorkoutDescription: String = self.workoutFormValues!["Workout Description"]!! as! String
            let userWorkoutDifficulty: String = self.workoutFormValues!["Difficulty"]!! as! String
            let userWorkoutExerciseList: [Any?] = self.workoutFormValues!["Add Exercises"]!! as! [Any?]
            
            // get the sets and reps for each workout
            var arrayToUpload: [[String : String]] = []
            
            for item in userWorkoutExerciseList {
                
                var combo: [String : String] = [:]
                var currExercise: [Exercise] = WKManager.shared.exercises?.filter({$0.name == item! as! String}) ?? []
                if currExercise.count > 0 {
                    combo["_id"] = currExercise[0].id
                }
                combo["name"] = item! as? String
                combo["reps"] = self.exerciseDetails!["\(item!)_reps"]!! as? String
                combo["sets"] = self.exerciseDetails!["\(item!)_sets"]!! as? String
                
                arrayToUpload.append(combo)
            }
            
            var basicWorkoutInfo: [String : String] = [:]
            
            basicWorkoutInfo["name"] = userWorkoutName
            basicWorkoutInfo["description"] = userWorkoutDescription
            basicWorkoutInfo["difficulty"] = userWorkoutDifficulty
            
            print(arrayToUpload)
            
            print(arrayToUpload as AnyObject)
            
            /****************** TRYING THIS ********************/
            // prepare json data
            
            guard let id: String = UserDefaults.standard.string(forKey: "id") else {
                fatalError("User not logged in. Need User ID")
            }
            
            let json: [String : Any] = [
                "name": basicWorkoutInfo["name"],
                "description": basicWorkoutInfo["description"],
                "difficulty": basicWorkoutInfo["difficulty"],
                "user_id" : id,
                "array_exercises_dictionary" : arrayToUpload
            ]
            
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            // create post request
            let url = URL(string: "https://losing-wait.herokuapp.com/workouts")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // insert json data to the request
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                }
            }
            
            task.resume()
            /****************** TRYING THIS ********************/
            
//            self.addWorkoutToDatabase(basicInfo: basicWorkoutInfo, arrayExercises: arrayToUpload, completion: { ok in })
           
        })
        
        // dismiss the form view
        self.dismiss(animated: true, completion: nil)
    }
    
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
        // do stuff
        guard let childVC = children.first as? CustomsFormViewController else {
            fatalError("Couldnt get child form view controller")
        }
        // find out if the first view is filled out
        var isInitialGood: Bool = childVC.isFilledOut
        print("Form filled out: \(isInitialGood)")
        
        if isExercise {
            // first view is all that is needed
            exerciseFormValues = childVC.getFormValues()
            
            // extra is good checking for the pickers
            if (exerciseFormValues!["Muscle Picker Exercises"]! == nil || exerciseFormValues!["Machine Group Picker Exercise"]! == nil) {
                isInitialGood = false
            }
            
            // check if filled out
            if !isInitialGood {
                // present an alert box to fill out all the fields
                let alert = UIAlertController(title: "Alert", message: "Please make sure all fields are filled.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                
                WKManager.shared.getMachineGroups(completion: {ok in
                    // get the info from the form
                    let userExerciseName: String = self.exerciseFormValues!["Exercise Name"]! as! String
                    let userExerciseMuscle: String = self.exerciseFormValues!["Muscle Picker Exercises"]! as! String
                    let userExerciseMachineGroup: String = self.exerciseFormValues!["Machine Group Picker Exercise"]! as! String
                    
                    // muscle and machine group need to be id
                    var muscles: [Muscle] = WKManager.shared.muscles?.filter({$0.name == userExerciseMuscle}) ?? []
                    var machine_groups: [MachineGroup] = WKManager.shared.machine_groups?.filter({$0.name == userExerciseMachineGroup}) ?? []
                    
                    var basicInfo: [String] = [userExerciseName]
                    
                    if (muscles.count > 0 && machine_groups.count > 0) {
                        basicInfo.append(muscles[0].id)
                        basicInfo.append(machine_groups[0].id)
                        self.addExerciseToDatabase(basicInfo: basicInfo, completion: {ok in})
                    }
                    
                })
                
                
                self.dismiss(animated: true, completion: nil)
            }
           
        } else {
            // check if filled out
            if !isInitialGood {
                let alert = UIAlertController(title: "Alert", message: "Please make sure all fields are filled.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                // need to get sets and reps for every exercises so push new view
                if let setExercisesViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SetExercises") as? SetExercisesViewController {
                    // send data
                    setExercisesViewController.exercises = childVC.exercisesArray!
                    setExercisesViewController.delegate = self
                    // push the view
                    navigationController?.pushViewController(setExercisesViewController, animated: true)
                }
                
                // get the data values from child view
                workoutFormValues = childVC.getFormValues()
            }
            
        }
        
        
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addExerciseToDatabase(basicInfo: [String],completion: @escaping (Bool) -> ()) -> () {
        let endpoint = URL(string: "https://losing-wait.herokuapp.com/exercises")!
        
        guard let id: String = UserDefaults.standard.string(forKey: "id") else {
            fatalError("User not logged in. Need User ID")
        }
        
        
        let parameters: Parameters = ["name": basicInfo[0], "muscle_id": basicInfo[1], "machine_group_id": basicInfo[2], "user_id" : id]
        
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        Alamofire.request(endpoint, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                print("Successfully added user exercise")
            case .failure(let error):
                BannerNotification.fatalError(msg: "Could not access server").show()
                print(error)
            }
            completion(true)
            
            let code = response.response?.statusCode
            if(code == 401 || code == 400) {
                print("User exercise not added")
            }
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

