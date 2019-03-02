//
//  WKManager.swift
//  LosingWait
//
//  Created by Mike Choi on 2/21/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import Alamofire

struct WKManager {
    
    static let shared = WKManager()
    
    let parameters: Parameters = ["key": "value"]
    let headers: HTTPHeaders = [
        "Authorization": "Token c502d5d6401f53edcaf74fb6506e5c1c731a3b20",
        "Accept": "application/json"
    ]
    
    func getMuscles(completion: @escaping ([Muscle]) -> ()) {
        let endpoint = URL(string: "https://wger.de/api/v2/muscle/")!
        
        Alamofire.request(endpoint, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                print("Validation Successful")
            case .failure(let error):
                BannerNotification.fatalError(msg: "Could not access server").show()
                print(error)
            }
            
            guard let response = response.value as? [String : Any] else { return }
            guard let results = response["results"] as? [[String : Any]] else { return }
            completion(results.compactMap(Muscle.init))
        }
    }
    
    func getEquipments(completion: @escaping ([Equipment]) -> ()) {
        let endpoint = URL(string: "https://wger.de/api/v2/equipment/")!
        
        Alamofire.request(endpoint, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                print("Validation Successful")
            case .failure(let error):
                BannerNotification.fatalError(msg: "Could not access server").show()
                print(error)
            }
            
            guard let response = response.value as? [String : Any] else { return }
            guard let results = response["results"] as? [[String : Any]] else { return }
            completion(results.compactMap(Equipment.init))
        }
    }
}
