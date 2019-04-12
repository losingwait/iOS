//
//  WKManager.swift
//  LosingWait
//
//  Created by Mike Choi on 2/21/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import Alamofire

class WKManager {
    
    static let shared = WKManager()
    var muscles: [Muscle]?
    var machine_groups: [MachineGroup]?
    var workouts: [Workout]?
    var exercises: [Exercise]?
    var equipment: [Machine]?
    
    func getMuscles(completion: @escaping (Bool) -> ()) {
        let endpoint = URL(string: "https://losing-wait.herokuapp.com/muscles/all/all")!
        
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        Alamofire.request(endpoint, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                print("Validation Successful")
            case .failure(let error):
                BannerNotification.fatalError(msg: "Could not access server").show()
                print(error)
            }
            
            guard let json = response.value as? [String : [String : String]] else { return }
            var results = Array<Dictionary<String, String>>()
            for(_, value) in json {
                results.append(value)
            }
            self.muscles = results.compactMap(Muscle.init)
            completion(true)
        }
    }
    
    func getMachineGroups(completion: @escaping (Bool) -> ()) {
        let endpoint = URL(string: "https://losing-wait.herokuapp.com/machine_groups/all/all")!
        
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        Alamofire.request(endpoint, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                print("Validation Successful")
            case .failure(let error):
                BannerNotification.fatalError(msg: "Could not access server").show()
                print(error)
            }
            
            guard let json = response.value as? [String : [String : Any]] else { return }
            var results = Array<Dictionary<String, Any>>()
            for(_, value) in json {
                results.append(value)
            }
            self.machine_groups = results.compactMap(MachineGroup.init)
            completion(true)
        }
    }
    
    func getMachines(completion: @escaping ([Machine]) -> ()) {
        let endpoint = URL(string: "https://losing-wait.herokuapp.com/machines/all/all")!
        
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        Alamofire.request(endpoint, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                print("Validation Successful")
            case .failure(let error):
                BannerNotification.fatalError(msg: "Could not access server").show()
                print(error)
            }
            
            guard let json = response.value as? [String : [String : Any]] else { return }
            var results = Array<Dictionary<String, Any>>()
            for(_, value) in json {
                results.append(value)
            }
            completion(results.compactMap(Machine.init))
        }
    }
    
    func getUserStatus(completion: @escaping (String) -> ()) {
        let myID = UserDefaults.standard.string(forKey: "id") ?? ""
        let endpoint = URL(string: "https://losing-wait.herokuapp.com/gym_users/user_id/\(myID)")!
        
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        Alamofire.request(endpoint, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                print("Validation Successful")
            case .failure(let error):
                BannerNotification.fatalError(msg: "Could not access server").show()
                print(error)
            }
            
            guard let json = response.value as? [String : [String : Any]],
                let machineID = json.first?.value["machine_id"] as? String else {
                    return
            }
            
            completion(machineID)
        }
    }
    
    func populateMachines(completion: @escaping (Bool) -> ()) {
        let endpoint = URL(string: "https://losing-wait.herokuapp.com/machines/all/all")!
        
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        Alamofire.request(endpoint, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                print("Validation Successful")
            case .failure(let error):
                BannerNotification.fatalError(msg: "Could not access server").show()
                print(error)
            }
            
            guard let json = response.value as? [String : [String : Any]] else { return }
            var results = Array<Dictionary<String, Any>>()
            for(_, value) in json {
                results.append(value)
            }
            self.equipment = results.compactMap(Machine.init)
            completion(true)
        }
    }
    
    func getWorkouts(completion: @escaping (Bool) -> ()) {
        let endpoint = URL(string: "https://losing-wait.herokuapp.com/workouts/all/all")!
        
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        Alamofire.request(endpoint, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                print("Validation Successful")
            case .failure(let error):
                BannerNotification.fatalError(msg: "Could not access server").show()
                print(error)
            }
            
            guard let json = response.value as? [String : [String : Any]] else { return }
            var results = Array<Dictionary<String, Any>>()
            for(_, value) in json {
                results.append(value)
            }
            self.workouts = results.compactMap(Workout.init)
            completion(true)
        }
    }
    
    func getSingleExercises(completion: @escaping (Bool) -> ()) {
        let endpoint = URL(string: "https://losing-wait.herokuapp.com/exercises/all/all")!
        
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        Alamofire.request(endpoint, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                print("Validation Successful")
            case .failure(let error):
                BannerNotification.fatalError(msg: "Could not access server").show()
                print(error)
            }
            
            guard let json = response.value as? [String : [String : Any]] else { return }
            var results = Array<Dictionary<String, Any>>()
            for(_, value) in json {
                results.append(value)
            }
            self.exercises = results.compactMap(Exercise.init)
            completion(true)
        }
    }
}
