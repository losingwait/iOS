//
//  Exercise.swift
//  LosingWait
//
//  Created by Mike Choi on 2/25/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import Foundation
import UIKit

struct Exercise: Displayable {
    let id: String
    let name: String
    let description: String
    let imageName: String?
    
    let category: String
    let machine: String

    let reps: Int
    let duration: TimeInterval
    
    static let samples = [
        Exercise(id: "abcd", name: "Bench Press", description: "Go up and down", imageName: "arnold-chest", category: "Chest", machine: "Rack", reps: 10, duration: 100.0),
        Exercise(id: "bcda", name: "Dead Lift", description: "Lift heavy stuff", imageName: "arnold-chest", category: "Lower Body", machine: "Dumbell", reps: 10, duration: 100.0),
    ]
    
    var viewController: ActiveWorkoutViewController {
        let storyboard = UIStoryboard(name: "Workouts", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ActiveWorkoutViewController") as! ActiveWorkoutViewController
        vc.exercise = self
        return vc
    }
}

extension Exercise: Bannerable {
    func configure(banner: BannerCollectionViewCell) {
        if imageName == nil {
            fatalError("This exercise is not bannerable")
        }
        
        banner.categoryLabel.text = "FEATURED EXERCISE"
        banner.bannerLabel.text = name
        banner.descriptionLabel.text = description
        banner.imageView.image = UIImage(named: imageName!)
    }
}
