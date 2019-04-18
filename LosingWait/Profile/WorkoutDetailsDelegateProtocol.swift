//
//  WorkoutDetailsDelegate.swift
//  LosingWait
//
//  Created by Karsen Keith on 4/15/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit

import Foundation

protocol WorkoutDetailsDelegate: AnyObject {
    func formFilledOut(_ data: [String: Any?]?)
}
