//
//  TimeInterval+Extension.swift
//  LosingWait
//
//  Created by Mike Choi on 3/18/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import Foundation

extension TimeInterval {
    private var milliseconds: Int {
        return Int((truncatingRemainder(dividingBy: 1)) * 1000)
    }
    
    private var seconds: Int {
        return Int(self) % 60
    }
    
    private var minutes: Int {
        return (Int(self) / 60 ) % 60
    }
    
    private var hours: Int {
        return Int(self) / 3600
    }
    
    var stringTime: String {
        if hours != 0 {
            return "\(hours):\(minutes):\(seconds):"
        } else if minutes != 0 {
            return "\(minutes):\(seconds)"
        } else {
            return "\(seconds)s"
        }
    }

    var humanized: String {
        if hours != 0 {
            return "\(hours) hours"
        } else if minutes != 0 {
            return "\(minutes) mins"
        } else {
            return "\(seconds) seconds"
        }
    }
}
