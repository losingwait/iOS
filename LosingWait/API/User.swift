//
//  User.swift
//  LosingWait
//
//  Created by Salman Mithani on 3/19/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

struct User {
    let name: String
    let id: String
    let email: String
    
    init(response: [String : Any]) {
        id = response["_id"] as! String
        name = response["name"] as! String
        email = response["email"] as! String
    }
}
