//
//  Equipment.swift
//  LosingWait
//
//  Created by Mike Choi on 2/22/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

struct Equipment {
    let name: String
    let id: Int
    
    init(response: [String : Any]) {
        id = response["_id"] as! Int
        name = response["name"] as! String
    }
}
