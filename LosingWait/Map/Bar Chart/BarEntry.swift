//
//  BarEntry.swift
//  LosingWait
//
//  Created by Mike Choi on 3/20/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//


import Foundation
import UIKit

struct BarEntry {
    
    /// Ranged from 0.0 to 1.0
    let height: Float
    
    /// To be shown on top of the bar
    let textValue: String
    
    /// To be shown at the bottom of the bar
    let title: String
    
    let index: Int
}
