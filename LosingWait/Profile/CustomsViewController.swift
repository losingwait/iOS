//
//  CustomsViewController.swift
//  LosingWait
//
//  Created by Karsen Keith on 4/10/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit
import Alamofire

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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if category == "Custom Exercises" {
            let currExercise: Exercise = exercises[indexPath.row]
            
            // set exercise
            let vc = currExercise.viewController
            tabBarController?.popupBar.tintColor = UIColor(white: 38.0 / 255.0, alpha: 1.0)
            tabBarController?.popupBar.imageView.layer.cornerRadius = 5
            tabBarController?.presentPopupBar(withContentViewController: vc, animated: true, completion: nil)
        } else {
            let currWorkout: Workout = workouts[indexPath.row]
            
            // start workout
            let vc = currWorkout.viewController
            tabBarController?.popupBar.tintColor = UIColor(white: 38.0 / 255.0, alpha: 1.0)
            tabBarController?.popupBar.imageView.layer.cornerRadius = 5
            tabBarController?.presentPopupBar(withContentViewController: vc, animated: true, completion: nil)
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if category == "Custom Exercises" {
                // networking call
                let endpoint = URL(string: "https://losing-wait.herokuapp.com/exercises")!
                
                let action: String = "remove"
                
                let parameters: Parameters = ["del_id": exercises[indexPath.row].id, "action": action]
                
                let headers: HTTPHeaders = [
                    "Accept": "application/json"
                ]
                
                Alamofire.request(endpoint, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                    switch response.result {
                    case .success:
                        print("Successfully removed exercise")
                        
                    case .failure(let error):
                        BannerNotification.fatalError(msg: "Could not access server").show()
                        print(error)
                    }
                    
                    let code = response.response?.statusCode
                    if(code == 401 || code == 400) {
                        print("Exercise not removed")
                    } else if (code == 200) {
                        print("Successful deletion")
                    }
                }
                
                exercises.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                // networking call
                let json: [String : Any] = [
                    "del_id": workouts[indexPath.row].id,
                    "action": "remove"
                ]
                
                let jsonData = try? JSONSerialization.data(withJSONObject: json)
                
                // create post request
                let url = URL(string: "https://losing-wait.herokuapp.com/workouts")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                // insert json data to the request
                request.httpBody = jsonData
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    
                    // dismiss the form view
                    self.dismiss(animated: true, completion: nil)
                    
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
                
                workouts.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}
