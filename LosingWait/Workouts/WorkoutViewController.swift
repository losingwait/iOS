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
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    let workoutStoryboard = UIStoryboard(name: "Workouts", bundle: nil)
    
    lazy var dataSource: WorkoutCollectionDataSource = {
        let dataSource = WorkoutCollectionDataSource(with: WKManager.shared.workouts!)
        return dataSource
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = dataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        if scrollView.contentOffset.y < -88 {
            scrollView.setContentOffset(CGPoint(x: 0, y: -88), animated: false)
        }
    }
}

extension WorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let segue = WorkoutSegue(rawValue: indexPath.row) else {
            return
        }
        
        var vc: UIViewController!
        
        switch segue {
        case .Browse:
            vc = workoutStoryboard.instantiateViewController(withIdentifier: segue.description) as! WorkoutBrowseViewController
        case .Favorites:
            vc = workoutStoryboard.instantiateViewController(withIdentifier: "TileVC") as! TileCollectionViewController
            (vc as! TileCollectionViewController).type = .myWorkouts
        case .Recent:
            vc = workoutStoryboard.instantiateViewController(withIdentifier: "TileVC") as! TileCollectionViewController
            (vc as! TileCollectionViewController).type = .recentlyViewed
        }
        
        navigationController?.pushViewController(vc, animated: true)
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

extension WorkoutViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = workoutStoryboard.instantiateViewController(withIdentifier: "WorkoutDetailViewController") as? WorkoutDetailViewController else {
            return
        }
        
        let selectedWorkout = dataSource.workouts[indexPath.row]
        vc.workout = selectedWorkout
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (view.frame.width - (18 * 3)) / 2
        return CGSize(width: cellWidth, height: cellWidth + 40)
    }
}
