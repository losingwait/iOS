//
//  BrowseDetailViewController.swift
//  LosingWait
//
//  Created by Salman Mithani on 4/5/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit

class MachineGroupDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PopoverDismissable {
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    
    let reuseIdentifier = "MachineCollectionViewCell"
    
    var group: MachineGroup?
    var machinesInGroup: [Machine]?
    var exercisesForMachine: [Exercise]?
    var group_muscle_id: String?
    
    lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.isUserInteractionEnabled = true
        return blurEffectView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = group?.name
        WKManager.shared.getMachines { finished in print("updated machines") }
        machinesInGroup = WKManager.shared.machines?.filter{$0.machine_group_id == group?.id}
        exercisesForMachine = WKManager.shared.exercises?.filter{$0.machine_group_id == group?.id}
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.machinesInGroup?.count ?? 0
//        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MachineCollectionViewCell
        
        let gradient = CAGradientLayer()
        gradient.frame = cell.bounds
        let gradientStart = UIColor(red: 137/255, green: 247/255, blue: 254/255, alpha: 1)
        let gradientEnd = UIColor(red: 102/255, green: 166/255, blue: 255/255, alpha: 1)
        gradient.colors = [gradientStart.cgColor, gradientEnd.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        cell.layer.insertSublayer(gradient, at: 0)
        
        cell.layer.cornerRadius = 8
        
        cell.machineLabel.text = machinesInGroup?[indexPath.item].name
//        cell.machineLabel.text = "whatever"
        
        cell.availableLabel.backgroundColor = machinesInGroup?[indexPath.item].in_use.color
//        cell.availableLabel.backgroundColor = #colorLiteral(red: 0.2980392157, green: 0.8509803922, blue: 0.3921568627, alpha: 1)
//        cell.availableLabel.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
//        cell.availableLabel.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        cell.availableLabel.text = machinesInGroup?[indexPath.item].in_use.rawValue.capitalized
//        cell.availableLabel.text = "Open"
//        cell.availableLabel.text = "Queued"
//        cell.availableLabel.text = "Occupied"
        
        heightConstraint.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
        view.layoutIfNeeded()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: MapPopoverViewController.identifier) as! MapPopoverViewController
        vc.machineName = machinesInGroup?[indexPath.item].name
        vc.preferredContentSize = CGSize(width: 270, height: 180)
        
        let controller = AlwaysPresentAsPopover.configurePresentation(forController: vc)
        controller.sourceView = self.view
        controller.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0,height: 0)
        controller.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        (controller.delegate as? AlwaysPresentAsPopover)?.popoverDelegate = self
        
        self.blurEffectView.alpha = 0.0
        view.addSubview(blurEffectView)
        UIView.animate(withDuration: 0.2) {
            self.blurEffectView.alpha = 1.0
        }
        present(vc, animated: true, completion: nil)
    }
    
    func dismiss() {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.blurEffectView.alpha = 0.0
        }) { ok in
            self.blurEffectView.removeFromSuperview()
        }
    }

}

extension MachineGroupDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exercisesForMachine?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = exercisesForMachine?[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let targetExercise = exercisesForMachine?[indexPath.row] else {
            fatalError("Couldn't find exercise")
        }
        let vc = targetExercise.viewController
        tabBarController?.popupBar.tintColor = UIColor(white: 38.0 / 255.0, alpha: 1.0)
        tabBarController?.popupBar.imageView.layer.cornerRadius = 5
        tabBarController?.presentPopupBar(withContentViewController: vc, animated: true, completion: nil)
    }
    
}
