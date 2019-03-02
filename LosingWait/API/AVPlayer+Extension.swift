//
//  AVPlayer+Extension.swift
//  LosingWait
//
//  Created by Mike Choi on 3/2/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import AVFoundation

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
