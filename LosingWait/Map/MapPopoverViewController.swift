//
//  MapPopoverViewController.swift
//  LosingWait
//
//  Created by Mike Choi on 4/1/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit

class MapPopoverViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var muscleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var queueLabel: UILabel!
    @IBOutlet weak var lastCheckinLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var queueButton: UIButton!
    
    static let identifier = "MapPopoverViewController"
    
    var machineName: String?
    
    var _occupied: Bool?
    var occupied: Bool {
        set {
            _occupied = newValue
            statusLabel.text = newValue ? "Occupied" : "Open"
            statusLabel.textColor = newValue ? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) : #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        } get {
            return _occupied ?? false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusLabel.isHidden = true
        stackView.isHidden = true
        
        configure(for: machineName)
    }
    
    @IBAction func queuePressed(_ sender: UIButton) {
    }
    
    func configure(for machineName: String?) {
        guard let name = machineName else {
            fatalError("Please provide me the name of the machine")
        }
        
        let newlineStripped = name.components(separatedBy: .whitespacesAndNewlines).filter( {$0.count != 0 }).joined(separator: " ")
        nameLabel.text = newlineStripped
        
        
        WKManager.shared.getMachineGroups { ok in
            guard let targetGroup = WKManager.shared.machine_groups?.filter({ $0.name.contains(newlineStripped) }).first else {
                self.queueLabel.text = "?"
                return
            }
            
            if let queue = targetGroup.queue {
                self.queueLabel.text = "\(queue.count)"
            } else {
                self.queueLabel.text = "0"
            }
        }
        
        WKManager.shared.getMachines { machines in
            guard let targetMachine = machines.filter({ $0.name.contains(newlineStripped) }).first else {
                return
            }
            
            if let muscles = WKManager.shared.muscles,
                let targetMuscle = muscles.filter({ $0.id == targetMachine.muscle_id }).first {
                self.muscleLabel.text = targetMuscle.name
            }
            self.occupied = targetMachine.in_use
            self.statusLabel.isHidden = false
            self.stackView.isHidden = false
        }
    }
}
