//
//  WorkoutBrowseViewController.swift
//  LosingWait
//
//  Created by Mike Choi on 2/21/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit

class WorkoutBrowseViewController: UITableViewController {
    
    let sections = ["Muscle", "Equipment"]
    var muscles: [Muscle] = []
    var equipments: [Equipment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WKManager.getMuscles { muscles in
            self.muscles = muscles
            self.tableView.reloadData()
        }
        
        WKManager.getEquipments { equipments in
            self.equipments = equipments
            self.tableView.reloadData()
        }
    }
}

extension WorkoutBrowseViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let sectionLabel = UILabel(frame: CGRect(x: 18, y: 15, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        sectionLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        sectionLabel.textColor = .black
        sectionLabel.text = sections[section]
        sectionLabel.sizeToFit()
        headerView.addSubview(sectionLabel)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? muscles.count : equipments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = muscles[indexPath.row].name
        } else {
            cell.textLabel?.text = equipments[indexPath.row].name
        }
        return cell
    }
}
