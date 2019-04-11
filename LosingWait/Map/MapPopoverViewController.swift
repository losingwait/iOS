//
//  MapPopoverViewController.swift
//  LosingWait
//
//  Created by Mike Choi on 4/1/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit
import Alamofire

class MapPopoverViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var muscleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var queueLabel: UILabel!
    @IBOutlet weak var lastCheckinLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var queueButton: UIButton!
    
    @IBOutlet weak var oneDumbbellStackView: UIStackView!
    @IBOutlet weak var twoDumbellStackView: UIStackView!
    
    static let identifier = "MapPopoverViewController"
    
    var machineName: String?
    var thisMachineGroup: MachineGroup?
    var status: MachineStatus? {
        didSet {
            guard let status = status else {
                return
            }
            statusLabel.text = status.rawValue.capitalized
            statusLabel.textColor = status.color
        }
    }
    
    // setter and getter for toggling the get in queue button
    var _inQueue: Bool?
    var inQueue: Bool {
        set {
            _inQueue = newValue
            queueButton.setTitle(newValue ? "Leave queue" : "Get in queue", for: UIButton.State.normal)
            queueButton.setTitleColor(newValue ? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) : #colorLiteral(red: 0.2980392157, green: 0.8509803922, blue: 0.3921568627, alpha: 1), for: UIButton.State.normal)
        } get {
            return _inQueue ?? false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusLabel.isHidden = true
        stackView.isHidden = true
        
        configure(for: machineName)
    }
    
    @IBAction func queuePressed(_ sender: UIButton) {
        // send update request
        updateUserToQueue(alreadyInQueue: self.inQueue, completion: { ok in
            // toggle queue button
            self.inQueue = !self.inQueue
            
            // reconfigure so that you can see accurate queue status
            self.configure(for: self.machineName)
        })
        
    }
    
    func updateUserToQueue(alreadyInQueue: Bool, completion: @escaping (Bool) -> ()) -> () {
        let endpoint = URL(string: "https://losing-wait.herokuapp.com/queue")!
        
        guard let id: String = UserDefaults.standard.string(forKey: "id"),
            let group_id: String = thisMachineGroup?.id else {
            fatalError("User not logged in. Need User ID")
        }
        
        let action: String = alreadyInQueue ? "remove" : "add"
        
        let parameters: Parameters = ["_id": group_id, "user_id": id, "action": action]

        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]

        Alamofire.request(endpoint, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                print("Successfully added/removed user from queue")
            case .failure(let error):
                BannerNotification.fatalError(msg: "Could not access server").show()
                print(error)
            }
            completion(true)

            let code = response.response?.statusCode
            if(code == 401) {
                print("User not added/removed from queue")
            }
        }
    }
    
    func configure(for machineName: String?) {
        guard let name = machineName else {
            fatalError("Please provide me the name of the machine")
        }
        
        let newlineStripped = name.components(separatedBy: .whitespacesAndNewlines).filter( {$0.count != 0 }).joined(separator: " ")
        nameLabel.text = newlineStripped
        
        
        if newlineStripped == "Dumbbell Rack" {
            _ = stackView.arrangedSubviews.map({ if !$0.isHidden { $0.isHidden = true } })
            muscleLabel.isHidden = true
            queueButton.isHidden = true
            oneDumbbellStackView.isHidden = false
            twoDumbellStackView.isHidden = false
            stackView.isHidden = false
            updateDumbellStatus()
        } else {
            updateStatus(for: newlineStripped)
        }
    }
}

extension MapPopoverViewController {
    
    func updateDumbellStatus() {
        
    }
    
    func updateStatus(for machineName: String) {
        WKManager.shared.getMachineGroups { ok in
            guard let targetGroup = WKManager.shared.machine_groups?.filter({ $0.name.contains(machineName) || machineName.contains($0.name) }).first else {
                self.queueLabel.text = "?"
                return
            }
            self.thisMachineGroup = targetGroup
            
            if let queue = targetGroup.queue {
                self.queueLabel.text = "\(queue.count)"
                guard let id: String = UserDefaults.standard.string(forKey: "id") else {
                    fatalError("User not logged in. Need User ID")
                }
                self.inQueue = queue.contains(id) ? true : false
            } else {
                self.queueLabel.text = "0"
                self.inQueue = false
            }
        }
        
        WKManager.shared.getMachines { machines in
            guard let targetMachine = machines.filter({ $0.name.contains(machineName) }).first else {
                return
            }
            
            if let muscles = WKManager.shared.muscles,
                let targetMuscle = muscles.filter({ $0.id == targetMachine.muscle_id }).first {
                self.muscleLabel.text = targetMuscle.name
            }
            
            self.status = targetMachine.in_use
            self.lastCheckinLabel.text = targetMachine.sinceLastCheckIn
            self.statusLabel.isHidden = false
            self.stackView.isHidden = false
        }
    }
}
