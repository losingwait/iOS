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
    var machines: [Machine]?
    var workouts: [Workout]?
    var exercises: [Exercise]?
    var customWorkouts: [Workout]?
    var customExercises: [Exercise]?
    
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
            
            self.machines = results.compactMap(Machine.init)
            completion(self.machines!)
        }
    }
    
    func getUserStatus(completion: @escaping (String?) -> ()) {
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
                    completion(nil)
                    return
            }
            
            completion(machineID)
        }
    }

    func getGymUserCount(completion: @escaping (Int) -> ()) {
        let myID = UserDefaults.standard.string(forKey: "id") ?? ""
        let endpoint = URL(string: "https://losing-wait.herokuapp.com/gym_users/all/all")!
        
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
            
            guard let json = response.value as? [String : [String : Any]] else {
                completion(0)
                return
            }
            
            completion(json.count)
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
            self.workouts = results.compactMap(Workout.init).filter({$0.user_id == nil})
            completion(true)
        }
    }
    
    func getCustomWorkouts(completion: @escaping (Bool) -> ()) {
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
            
            guard let id: String = UserDefaults.standard.string(forKey: "id") else {
                fatalError("User not logged in. Need User ID")
            }
            
            let allWorkouts = results.compactMap(Workout.init)
            self.customWorkouts = allWorkouts.filter({$0.user_id == id})
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
            self.exercises = results.compactMap(Exercise.init).filter({$0.user_id == nil})
            completion(true)
        }
    }
    
    func getCustomSingleExercises(completion: @escaping (Bool) -> ()) {
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
            
            guard let id: String = UserDefaults.standard.string(forKey: "id") else {
                fatalError("User not logged in. Need User ID")
            }
            
            let allExercises = results.compactMap(Exercise.init)
            self.customExercises = allExercises.filter({$0.user_id == id})
            completion(true)
        }
    }
    
    
}
