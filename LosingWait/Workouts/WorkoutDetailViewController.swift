//
//  WorkoutDetailViewController.swift
//  LosingWait
//
//  Created by Mike Choi on 3/25/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit

class WorkoutDetailViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var addedButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var unfavoriteButton: UIButton!
    
    var workout: Workout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        imageView.image = workout.image
        nameLabel.text = workout.name
        detailLabel.text = workout.description
        
        let isFavorite = UserDefaults.standard.favoriteWorkouts.contains(workout)
        favoriteButton.isHidden = isFavorite
        addedButton.isHidden = !isFavorite
        unfavoriteButton.isHidden = !isFavorite
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @IBAction func favoriteWorkout(_ sender: Any) {
        UserDefaults.standard.favorite(workout: workout)
        favoriteButton.isHidden = true
        addedButton.isHidden = false
        unfavoriteButton.isHidden = false
    }
    
    @IBAction func unfavoriteWorkout(_ sender: Any) {
        UserDefaults.standard.unfavorite(workout: workout)
        favoriteButton.isHidden = false
        addedButton.isHidden = true
        unfavoriteButton.isHidden = true
    }
    
    
    
    @IBAction func startWorkout(_ sender: Any) {
        let vc = workout.viewController
        tabBarController?.popupBar.tintColor = UIColor(white: 38.0 / 255.0, alpha: 1.0)
        tabBarController?.popupBar.imageView.layer.cornerRadius = 5
        tabBarController?.presentPopupBar(withContentViewController: vc, animated: true, completion: nil)
    }
    
    @IBAction func viewBrochure(_ sender: Any) {
        
    }
}

extension WorkoutDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout.exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseTableViewCell.identifier, for: indexPath) as? ExerciseTableViewCell else {
            return UITableViewCell()
        }
        
        guard let exercise = workout?.exercises[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configure(with: exercise, isCurrentWorkout: false, index: indexPath)
        return cell
    }
}

extension WorkoutDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ExerciseTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let name = workout.exercises[indexPath.row].name
        guard let targetExercise = WKManager.shared.exercises?.filter({ $0.name == name }).first else {
            fatalError("Couldn't find exercise with name \(name)")
        }
        
        let vc = targetExercise.viewController
        tabBarController?.popupBar.tintColor = UIColor(white: 38.0 / 255.0, alpha: 1.0)
        tabBarController?.popupBar.imageView.layer.cornerRadius = 5
        tabBarController?.presentPopupBar(withContentViewController: vc, animated: true, completion: nil)
    }
}
