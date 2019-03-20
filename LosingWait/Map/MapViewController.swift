//
//  MapViewController.swift
//  LosingWait
//
//  Created by Mike Choi on 3/20/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    @IBOutlet weak var mapImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
