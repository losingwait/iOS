//
//  OccupacyLabelItem.swift
//  LosingWait
//
//  Created by Mike Choi on 4/15/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import EFCountingLabel
import BLTNBoard

class OccupacyPageItem: BLTNPageItem {
    
    lazy var countLabel = EFCountingLabel(frame: CGRect(x: 0, y: 0, width: 200, height: 150))
    lazy var barChart: BasicBarChart = {
        let barChart = BasicBarChart()
        let hour = Calendar.current.component(.hour, from: Date())
        barChart.currentIndex = hour - 7
        barChart.dataEntries = generateDataEntries()
        return barChart
    }()
    
    init(userCount: Int) {
        super.init(title: "Gym Status")
        descriptionText = ""
        
        isDismissable = true
        shouldStartWithActivityIndicator = true
    
        presentationHandler = { item in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                item.manager?.hideActivityIndicator()
                self.countLabel.countFromZeroTo(CGFloat(userCount), withDuration: 2.0)
            }
        }
        
        actionHandler = { item in
            item.manager?.dismissBulletin(animated: true)
        }
        
    }
    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        countLabel.format = "%d people at the gym"
        countLabel.method = EFLabelCountingMethod.easeOut
        countLabel.textColor = .black
        countLabel.font = UIFont.systemFont(ofSize: 20)
        countLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            barChart.heightAnchor.constraint(equalToConstant: 150.0)
            ])
        return [barChart]
    }
}

extension OccupacyPageItem {
    func generateDataEntries() -> [BarEntry] {
        var result: [BarEntry] = []
        let values = [0.1, 0.15, 0.2, 0.3, 0.32, 0.5, 0.45, 0.4, 0.54, 0.55, 0.58, 0.61, 0.75, 0.84, 0.59, 0.41, 0.38, 0.31, 0.3]
        for i in 7..<25 {
            let height = Float(values[i - 7])
            let entry = BarEntry(height: height, textValue: "\(height)", title: String(i), index: i - 6)
            result.append(entry)
        }
        
        return result
    }
}
