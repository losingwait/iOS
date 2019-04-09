//
//  TileCollectionViewController.swift
//  LosingWait
//
//  Created by Mike Choi on 4/8/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit

enum ViewType: String {
    case recentlyViewed = "Recently Viewed"
    case myWorkouts = "My Workouts"
    
    func workouts() -> [Workout] {
        switch self {
        case .recentlyViewed:
            return UserDefaults.standard.recentlyViewed
        case .myWorkouts:
            return UserDefaults.standard.favoriteWorkouts
        }
    }
}

class TileCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = dataSource
            collectionView.delegate = self
        }
    }
    
    lazy var dataSource: WorkoutCollectionDataSource = {
        let dataSource = WorkoutCollectionDataSource(with: type.workouts())
        return dataSource
    }()
    
    var type: ViewType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = type.rawValue
    }
}

extension TileCollectionViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let workoutStoryboard = UIStoryboard(name: "Workouts", bundle: nil)
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
