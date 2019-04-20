//
//  MapViewController.swift
//  LosingWait
//
//  Created by Mike Choi on 3/20/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit
import BLTNBoard

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var trendButton: UIButton!
    
    lazy var bulletinManager: BLTNItemManager = {
        let introPage = OccupacyPageItem(userCount: 10)
        introPage.appearance.descriptionFontSize = 14
        return BLTNItemManager(rootItem: introPage)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        trendButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        trendButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        trendButton.layer.shadowOpacity = 1.0
        trendButton.layer.shadowRadius = 0.0
        trendButton.layer.masksToBounds = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        WKManager.shared.userIsCheckedIn { ok in
            if !ok {
                BannerNotification.error(msg: "You are not checked in to the gym").show()
            }
        }
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
    
    @IBAction func trendPressed(_ sender: Any) {
        bulletinManager.showBulletin(above: self, animated: true, completion: nil)
    }
}
