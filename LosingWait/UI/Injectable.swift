//
//  Injectable.swift
//  LosingWait
//
//  Created by Mike Choi on 2/21/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

protocol Injectable {
    associatedtype T
    func inject(_: T)
    func assertDependencies()
}
