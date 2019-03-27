//
//  Workout.swift
//  LosingWait
//
//  Created by Salman Mithani on 3/27/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

struct Workout_API: Displayable {
    let name: String
    let id: String
    let exercises_dict_array: [[String: Any]]
    var exercises: [Exercise_API]
    let difficulty: String
    let workout_image_url: String
    
    init(response: [String : Any]) {
        id = response["_id"] as! String
        name = response["name"] as! String
        difficulty = response["difficulty"] as! String
        workout_image_url = response["workout_image"] as! String
        exercises = []
        exercises_dict_array = response["array_exercises_dictionary"] as! [[String: Any]]
        for ex in exercises_dict_array {
            exercises.append(Exercise_API(id: ex["_id"] as! String, name: ex["name"] as! String, reps: ex["reps"] as! String, sets: ex["sets"] as! String))
        }
    }
    
}
