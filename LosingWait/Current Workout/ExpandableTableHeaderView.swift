//
//  ExpandableTableHeaderView.swift
//  LosingWait
//
//  Created by Mike Choi on 4/4/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: class {
    func toggleSection(header: ExpandableTableHeaderView, section: Int)
}

class ExpandableTableHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var repLabel: UILabel!
    @IBOutlet weak var availabilityLabel: UILabel!
    weak var delegate: HeaderViewDelegate?
    
    static let height: CGFloat = 55
    var section: Int = 0
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func configure(with exercise: Exercise, index: Int) {
        nameLabel.text = exercise.name
        setLabel.text = exercise.setDescription
        repLabel.text = exercise.repDescription
        
        if let machineID = exercise.machine_group_id,
            let machineGroup = WKManager.shared.machine_groups?.filter({ $0.id == machineID }).first {
            availabilityLabel.text = "-"
            availabilityLabel.backgroundColor = .lightGray
            
            let machines = WKManager.shared.machines!.filter( {$0.machine_group_id == machineGroup.id })
            let occupied = machines.filter({ $0.in_use == .occupied }).count != 0
            if occupied {
                availabilityLabel.text = "Occupied"
                availabilityLabel.backgroundColor = #colorLiteral(red: 1, green: 0.1764705882, blue: 0.3333333333, alpha: 1)
            } else {
                availabilityLabel.text = "Available"
                availabilityLabel.backgroundColor = #colorLiteral(red: 0.2980392157, green: 0.8509803922, blue: 0.3921568627, alpha: 1)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
    }
    
    @objc private func didTapHeader() {
        delegate?.toggleSection(header: self, section: section)
    }
}
