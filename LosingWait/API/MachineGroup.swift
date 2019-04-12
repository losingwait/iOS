//
//  MachineGroup.swift
//  LosingWait
//
//  Created by Salman Mithani on 3/27/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

struct MachineGroup: Displayable {
    let name: String
    let id: String
    var queue: [String]?
    
    init(response: [String : Any]) {
        id = response["_id"] as! String
        name = response["name"] as! String
        
        if let queue = response["queue"] as? [String] {
            self.queue = queue
        }
    }
}
