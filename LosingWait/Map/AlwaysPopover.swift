//
//  AlwaysPopover.swift
//  LosingWait
//
//  Created by Mike Choi on 4/1/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit

protocol PopoverDismissable {
    func dismiss()
}

class AlwaysPresentAsPopover: NSObject, UIPopoverPresentationControllerDelegate {

    private static let sharedInstance = AlwaysPresentAsPopover()
    var popoverDelegate: PopoverDismissable?
    
    private override init() {
        super.init()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    static func configurePresentation(forController controller : UIViewController) -> UIPopoverPresentationController {
        controller.modalPresentationStyle = .popover
        let presentationController = controller.presentationController as! UIPopoverPresentationController
        presentationController.delegate = AlwaysPresentAsPopover.sharedInstance
        return presentationController
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        popoverDelegate?.dismiss()
        return true
    }
}
