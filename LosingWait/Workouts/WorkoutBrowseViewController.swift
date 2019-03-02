//
//  WorkoutBrowseViewController.swift
//  LosingWait
//
//  Created by Mike Choi on 2/21/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit
import LNPopupController

class WorkoutBrowseViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoryTableView: UITableView!
    
    let catagories = ["Workout", "Muscle", "Equipment"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Browse"
        
        collectionView.dataSource = self
        collectionView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*
        if segue.identifier == "showDetails" {
            let vc = segue.destination as? WorkoutBrowseListViewController
        }
        */
    }
}

extension WorkoutBrowseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catagories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = catagories[indexPath.row]
        return cell
    }
}

extension WorkoutBrowseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showDetails", sender: self)
    }
}

extension WorkoutBrowseViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Exercise.samples.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.reuseIdentifier, for: indexPath) as? BannerCollectionViewCell else {
            return UICollectionViewCell()
        }

        Exercise.samples[0].configure(banner: cell)
        return cell
    }
}

extension WorkoutBrowseViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let exercise = Exercise.samples[indexPath.item]
        let vc = exercise.viewController
        
        tabBarController?.presentPopupBar(withContentViewController: vc, animated: true, completion: nil)
        tabBarController?.popupBar.tintColor = UIColor(white: 38.0 / 255.0, alpha: 1.0)
        tabBarController?.popupBar.imageView.layer.cornerRadius = 5
        tabBarController?.openPopup(animated: true, completion: nil)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
