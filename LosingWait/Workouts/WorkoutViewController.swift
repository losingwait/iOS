//
//  WorkoutViewController.swift
//  LosingWait
//
//  Created by Mike Choi on 2/21/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit

enum WorkoutSegue: Int {
    case Browse
    case Recent
    case Favorites
    
    var description: String {
        switch self {
        case .Browse:
            return "Browse"
        case .Recent:
            return "Recently Viewed"
        case .Favorites:
            return "My Workouts"
        }
    }
}

class WorkoutViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    let workoutStoryboard = UIStoryboard(name: "Workouts", bundle: nil)
    
    lazy var dataSource: WorkoutCollectionDataSource = {
        let dataSource = WorkoutCollectionDataSource(with: Workout.samples)
        return dataSource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        extendedLayoutIncludesOpaqueBars = true
        
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = dataSource
    }
}

extension WorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let segue = WorkoutSegue(rawValue: indexPath.row) else {
            return
        }
        
        switch segue {
        case .Browse:
            let vc = workoutStoryboard.instantiateViewController(withIdentifier: segue.description) as! WorkoutBrowseViewController
            navigationController?.pushViewController(vc, animated: true)
        case .Favorites:
            print("not implemented")
        case .Recent:
            print("not implemented")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)
        
        guard let obj = WorkoutSegue(rawValue: indexPath.row) else {
            fatalError("Uh oh don't know which row this is")
        }
        
        cell.textLabel?.text = obj.description
        return cell
    }
}

extension WorkoutViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = workoutStoryboard.instantiateViewController(withIdentifier: "WorkoutDetailViewController") as? WorkoutDetailViewController else {
            return
        }
        
        let selectedWorkout = dataSource.workouts[indexPath.row]
        vc.workout = selectedWorkout
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
