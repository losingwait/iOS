//
//  Equipment.swift
//  LosingWait
//
//  Created by Mike Choi on 2/22/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

struct Equipment: Displayable {
    let name: String
    let id: String
    let muscle_id: String
    let machine_group_id: String
    let station_id: String
    let in_use: Bool
    
    static var all: [Equipment] = {
        return []
    }()
    
    init(response: [String : Any]) {
        id = response["_id"] as! String
        name = response["name"] as! String
        muscle_id = response["muscle_id"] as! String
        machine_group_id = response["machine_group_id"] as! String
        station_id = response["station_id"] as! String
        in_use = response["in_use"] as! Bool
    }
}
