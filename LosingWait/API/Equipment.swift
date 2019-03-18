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
    
    init(response: [String : Any]) {
        id = response["_id"] as! String
        name = response["name"] as! String
    }
}
