//
//  Workout.swift
//  LosingWait
//
//  Created by Mike Choi on 2/25/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit

struct Workout {
    let id: String
    
    let name: String
    let description: String
    let category: String
    
    let exercies: [Exercise]
    let duration: TimeInterval
}
