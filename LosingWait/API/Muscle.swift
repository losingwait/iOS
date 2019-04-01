//
//  Muscle.swift
//  LosingWait
//
//  Created by Mike Choi on 2/21/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

struct Muscle: Displayable {
    let name: String
    let id: String
    
    static var all: [Muscle] = {
        return []
    }()
    
    init(response: [String : Any]) {
        id = response["_id"] as! String
        name = response["name"] as! String
    }
}
