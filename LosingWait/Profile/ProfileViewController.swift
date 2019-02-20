//
//  ProfileViewController.swift
//  LosingWait
//
//  Created by Mike Choi on 2/18/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit
import MessageUI

class ProfileViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func sendFeedback(title: String) {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients(["mkchoi212@tamu.edu"])
            composeVC.setSubject("Losing Wait Application Feedback")
            self.present(composeVC, animated: true, completion: nil)
        } else {
            BannerNotification.error(msg: "Please set up your email account").show()
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            if result == .sent {
                BannerNotification.success(msg: "Thank you for your feedback 🎉").show()
            } else if result == .failed {
                BannerNotification.error(msg: "Something went wrong ☹️").show()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Report Section
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                sendFeedback(title: "Losing Wait iOS Application Bug Report")
            } else if indexPath.row == 1 {
                sendFeedback(title: "Losing Wait iOS Application General Feedback")
            } else {
                return
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}

extension ProfileViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
    }
}
