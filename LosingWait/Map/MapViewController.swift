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
    
    @IBAction func iconTapped(_ sender: UITapGestureRecognizer) {
        guard let stackView = sender.view as? UIStackView,
            let label = sender.view?.subviews.last as? UILabel else {
            return
        }
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: MapPopoverViewController.identifier) as! MapPopoverViewController
        vc.machineName = label.text
        vc.preferredContentSize = CGSize(width: 270, height: 180)
        let controller = AlwaysPresentAsPopover.configurePresentation(forController: vc)
        controller.sourceView = stackView
        controller.sourceRect = stackView.bounds
        self.present(vc, animated: true)
    }
}
