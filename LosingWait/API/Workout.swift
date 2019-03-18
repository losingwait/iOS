//
//  Workout.swift
//  LosingWait
//
//  Created by Mike Choi on 2/25/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit

struct Workout: Displayable {
    let id: String
    let imageName: String?
    
    let name: String
    let description: String
    let category: String
    
    let exercies: [Exercise]
    let duration: TimeInterval
    
    static let samples = [
        Workout(id: "abc", imageName: "arnold-chest", name: "Get cut", description: "Get the body you want", category: "Cut",
                exercies: [
                    Exercise(id: "abcd", name: "Bench Press", description: "Go up and down", imageName: "arnold-chest", category: "Chest", machine: "Rack", reps: 10, duration: 100.0),
                    Exercise(id: "bcda", name: "Dead Lift", description: "Lift heavy stuff", imageName: "arnold-chest", category: "Lower Body", machine: "Dumbell", reps: 10, duration: 100.0),
                ],
                duration: 1000),
        Workout(id: "abc", imageName: "arnold-chest", name: "Get swole", description: "You should go pro, bro", category: "Mass",
                exercies: [
                    Exercise(id: "bcda", name: "Dead Lift", description: "Lift heavy stuff", imageName: "arnold-chest", category: "Lower Body", machine: "Dumbell", reps: 10, duration: 100.0),
                    Exercise(id: "bcda", name: "Dead Lift", description: "Lift heavy stuff", imageName: "arnold-chest", category: "Lower Body", machine: "Dumbell", reps: 10, duration: 100.0)
                    ],
                duration: 1000),
    ]
    
    var viewController: ActiveWorkoutViewController {
        let storyboard = UIStoryboard(name: "CurrentWorkout", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ActiveWorkoutViewController") as! ActiveWorkoutViewController
        vc.workout = self
        return vc
    }
}

extension Workout: Bannerable {
    func configure(banner: BannerCollectionViewCell) {
        if imageName == nil {
            fatalError("This workout is not bannerable")
        }
        banner.categoryLabel.text = "FEATURED WORKOUT"
        banner.bannerLabel.text = name
        banner.descriptionLabel.text = description
        banner.imageView.image = UIImage(named: imageName!)
    }
}
