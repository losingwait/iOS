//
//  Muscle.swift
//  LosingWait
//
//  Created by Mike Choi on 2/21/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

struct Muscle {
    let name: String
    let id: Int
    
    init(response: [String : Any]) {
        id = response["id"] as! Int
        name = response["name"] as! String
    }
}
