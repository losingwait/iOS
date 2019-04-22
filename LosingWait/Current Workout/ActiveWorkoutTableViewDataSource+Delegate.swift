//
//  ActiveWorkoutTableViewDataSource+Delegate.swift
//  LosingWait
//
//  Created by Mike Choi on 4/10/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit

protocol PopupUpdater {
    func updatePopupItem(currentIndex: Int)
    func updateTableViewHeight(numRows: Int, refreshSection: IndexSet)
}

class ActiveWorkoutTableManager: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var workout: Workout?
    var exercise: Exercise?
    var popupDelegate: PopupUpdater!
    
    var expandedSections: [Int] = []
    
    var currentExerciseIdx: Int {
        didSet {
            popupDelegate.updatePopupItem(currentIndex: currentExerciseIdx)
        }
    }
    
    init(workout: Workout?, exercise: Exercise?) {
        self.workout = workout
        self.exercise = exercise
        currentExerciseIdx = 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ExerciseTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ExpandableTableHeaderView.identifier) as? ExpandableTableHeaderView {
            guard let exercise = workout?.exercises[currentExerciseIdx + section + 1],
                let targetExercise = WKManager.shared.exercises?.filter( {$0.name == exercise.name }).first else {
                    return UIView()
            }
            headerView.configure(with: targetExercise, index: section)
            headerView.repLabel.text = exercise.repDescription
            headerView.setLabel.text = exercise.setDescription
            headerView.section = section
            headerView.delegate = self
            return headerView
        }
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let originalExercise = workout?.exercises[currentExerciseIdx + indexPath.section + 1],
            let targetExercise = WKManager.shared.exercises?.filter( {$0.name == originalExercise.name }).first else {
                return
        }
        
        let alternateSelectedExercise = targetExercise.similar[indexPath.row]
        workout?.exercises[currentExerciseIdx + indexPath.section + 1] = alternateSelectedExercise
        
        let targetIndexSet: IndexSet = [indexPath.section]
        expandedSections.remove(at: expandedSections.index(of: indexPath.section)!)
        tableView.reloadSections(targetIndexSet, with: UITableView.RowAnimation.fade)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let sectionCnt = (workout?.exercises.count ?? 0) - currentExerciseIdx - 1
        return max(0, sectionCnt)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if expandedSections.contains(section) {
            guard let exercise = workout?.exercises[currentExerciseIdx + section + 1],
                let targetExercise = WKManager.shared.exercises?.filter( {$0.name == exercise.name }).first else {
                    return 0
            }
            return targetExercise.similar.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseTableViewCell.identifier, for: indexPath) as? ExerciseTableViewCell else {
            return UITableViewCell()
        }
        
        guard let originalExercise = workout?.exercises[currentExerciseIdx + indexPath.section + 1],
            let targetExercise = WKManager.shared.exercises?.filter( {$0.name == originalExercise.name }).first else {
                return UITableViewCell()
        }
        
        let exercise = targetExercise.similar[indexPath.row]
        cell.configure(with: exercise, isCurrentWorkout: true, index: indexPath)
        cell.repLabel.isHidden = true
        cell.setLabel.isHidden = true
        return cell
    }
}

extension ActiveWorkoutTableManager: HeaderViewDelegate {
    
    func toggleSection(header: ExpandableTableHeaderView, section: Int) {
        var numRows = workout?.exercises.count ?? 0 + 2
        
        if expandedSections.contains(section) {
            expandedSections.remove(at: expandedSections.index(of: section)!)
        } else {
            expandedSections.append(section)
            
            if let exercise = workout?.exercises[currentExerciseIdx + section + 1],
                let targetExercise = WKManager.shared.exercises?.filter({ $0.name == exercise.name }).first {
                numRows += targetExercise.similar.count
            }
        }
        
        popupDelegate.updateTableViewHeight(numRows: numRows, refreshSection: [section])
    }
}

