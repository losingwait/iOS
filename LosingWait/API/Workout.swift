//
//  Workout.swift
//  LosingWait
//
//  Created by Mike Choi on 2/25/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit

struct Workout: Displayable {
    let name: String
    let id: String
    let description: String
    let exercises_dict_array: [[String: Any]]
    var exercises: [Exercise]
    let difficulty: String
    let workout_image_url: String
    let user_id: String?
    
    init(response: [String : Any]) {
        id = response["_id"] as! String
        name = response["name"] as! String
        description = response["description"] as! String
        difficulty = response["difficulty"] as! String
        workout_image_url = response["workout_image"] as? String ?? ""
        exercises = []
        exercises_dict_array = response["array_exercises_dictionary"] as! [[String: Any]]
        for ex in exercises_dict_array {
            exercises.append(Exercise(id: ex["_id"] as! String, name: ex["name"] as! String, reps: ex["reps"] as! String, sets: ex["sets"] as! String))
        }
        user_id = response["user_id"] as? String
    }
    
    var viewController: ActiveWorkoutViewController {
        let storyboard = UIStoryboard(name: "CurrentWorkout", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ActiveWorkoutViewController") as! ActiveWorkoutViewController
        vc.workout = self
        return vc
    }
    
    var image: UIImage {
        if workout_image_url == "" {
            return UIImage()
        }
        let url = URL(string: workout_image_url)
        do {
            let data = try Data(contentsOf: url!)
            return UIImage(data: data)!
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        return UIImage()
    }
}

extension Workout: Equatable {
    
    static func == (lhs: Workout, rhs: Workout) -> Bool {
        return lhs.id == rhs.id
    }
    
    func configure(banner: BannerCollectionViewCell) {
        banner.categoryLabel.text = "FEATURED WORKOUT"
        banner.bannerLabel.text = name
        banner.descriptionLabel.text = description
        
        let url = URL(string: workout_image_url)
        do {
            let data = try Data(contentsOf: url!)
            banner.imageView.image = UIImage(data: data)
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
    }
}
