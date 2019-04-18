//
//  WorkoutCollectionDataSource.swift
//  LosingWait
//
//  Created by Mike Choi on 3/25/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit

class WorkoutCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    var workouts: [Workout]
    
    init(with workouts: [Workout]) {
        self.workouts = workouts.filter({$0.user_id == nil})
        super.init()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workouts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TileCollectionViewCell", for: indexPath) as? TileCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(workouts[indexPath.item])
        return cell
    }
}
