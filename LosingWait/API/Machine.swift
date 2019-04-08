//
//  Machine.swift
//  LosingWait
//
//  Created by Mike Choi on 4/1/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

struct Machine: Decodable {
    let name: String
    let id: String
    let muscle_id: String
    let machine_group_id: String
    let station_id: String
    let in_use: String
    
    init(response: [String : Any]) {
        id = response["_id"] as! String
        name = response["name"] as! String
        muscle_id = response["muscle_id"] as! String
        in_use = response["in_use"] as! String == "open"
    }
}
