//
//  MapPopoverViewController.swift
//  LosingWait
//
//  Created by Mike Choi on 4/1/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit

class MapPopoverViewController: UIViewController {
    
    @IBOutlet weak var queueLabel: UILabel!
    @IBOutlet weak var lastCheckinLabel: UILabel!
    @IBOutlet weak var queueButton: UIButton!
    
    enum Status {
        case occupied, free
    }
    
    var machineName: String?
    static let identifier = "MapPopoverViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(for: machineName)
    }
    
    @IBAction func queuePressed(_ sender: UIButton) {
    }
    
    func configure(for machineName: String?) {
        guard let machineName = machineName else {
            fatalError("Please provide me the name of the machine")
        }
    }
}
