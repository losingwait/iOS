//
//  Exercise.swift
//  LosingWait
//
//  Created by Salman Mithani on 3/27/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

struct Exercise_API: Displayable {
    let name: String
    let id: String
    let muscle_id: String
    let machine_group_id: String
    let exercise_media: String
    
    let reps: String
    let sets: String
    
    init(response: [String : Any]) {
        id = response["_id"] as! String
        name = response["name"] as! String
        muscle_id = response["muscle_id"] as! String
        machine_group_id = response["machine_group_id"] as! String
        exercise_media = response["exercise_media"] as! String
        reps = "0"
        sets = "0"
    }
    
    init(id: String, name: String, reps: String, sets: String) {
        self.id = id
        self.name = name
        self.reps = reps
        self.sets = sets
        
        muscle_id = "n/a"
        machine_group_id = "n/a"
        exercise_media = "n/a"
    }
}
