//
//  WKManager.swift
//  LosingWait
//
//  Created by Mike Choi on 2/21/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import Alamofire

struct WKManager {
    
//    static let shared = WKManager()
    
    static func getMuscles(completion: @escaping ([Muscle]) -> ()) {
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
            completion(results.compactMap(Muscle.init))
        }
    }
    
    static func getEquipment(completion: @escaping ([Equipment]) -> ()) {
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
            completion(results.compactMap(Equipment.init))
        }
    }
    
}
