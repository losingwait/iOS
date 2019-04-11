//
//  UserDefaults+Extensions.swift
//  LosingWait
//
//  Created by Mike Choi on 4/8/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import Foundation

extension UserDefaults {
    static let favorite_workouts = "FAVORITE_WORKOUTS"
    static let favorite_exercises = "FAVORITE_EXERCISES"
    static let recently_viewed_workout = "RECENTLY_VIEWED_WORKOUTS"
    
    var favoriteWorkouts: [Workout] {
        let workoutIDs = array(forKey: UserDefaults.favorite_workouts) as? [String] ?? []
        let workouts = WKManager.shared.workouts?.filter({ workoutIDs.contains($0.id) })
        return workouts ?? []
    }
    
    var favoriteExercises: [Exercise] {
        let exerciseID = array(forKey: UserDefaults.favorite_exercises) as? [String] ?? []
        let exercises = WKManager.shared.exercises?.filter({ exerciseID.contains($0.id) })
        return exercises ?? []
    }
    
    var recentlyViewed: [Workout] {
        let workoutIDs = array(forKey: UserDefaults.recently_viewed_workout) as? [String] ?? []
        let workouts = WKManager.shared.workouts?.filter({ workoutIDs.contains($0.id) })
        return workouts ?? []
    }
    
    func favorite(workout: Workout) {
        let newWorkouts = favoriteWorkouts + [workout]
        let workoutIDs = newWorkouts.map({ $0.id} )
        set(workoutIDs, forKey: UserDefaults.favorite_workouts)
    }
    
    func favorite(exercise: Exercise) {
        let newExercises = favoriteExercises + [exercise]
        let exerciseIDs = newExercises.map({ $0.id} )
        set(exerciseIDs, forKey: UserDefaults.favorite_exercises)
    }
    
    func addToViewed(workout: Workout) {
        let newWorkouts = [workout] + recentlyViewed
        let workoutIDs = newWorkouts.map({ $0.id} )
        set(workoutIDs, forKey: UserDefaults.favorite_workouts)
    }
    
    func unfavorite(workout: Workout) {
        var currWorkouts = favoriteWorkouts
        currWorkouts.removeAll(where: {$0.id == workout.id})
        let workoutIDs = currWorkouts.map({ $0.id} )
        set(workoutIDs, forKey: UserDefaults.favorite_workouts)
    }
    
    func unfavorite(exercise: Exercise) {
        var currExercises = favoriteExercises
        currExercises.removeAll(where: {$0.id == exercise.id})
        let exerciseIDs = currExercises.map({ $0.id} )
        set(exerciseIDs, forKey: UserDefaults.favorite_exercises)
    }
}
