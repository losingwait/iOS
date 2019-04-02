//
//  ExpandableCell.swift
//  LosingWait
//
//  Created by Mike Choi on 4/1/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import Foundation

class ExpandableCell {
    fileprivate (set) var items = [Item]()
    
    class Item {
        var isHidden: Bool
        var value: String
        var isChecked: Bool
        
        init(_ hidden: Bool = true, value: String, checked: Bool = false) {
            self.isHidden = hidden
            self.value = value
            self.isChecked = checked
        }
    }
    
    class HeaderItem: Item {
        init (value: String) {
            super.init(false, value: value, checked: false)
        }
    }
    
    func append(_ item: Item) {
        self.items.append(item)
    }
    
    func removeAll() {
        self.items.removeAll()
    }
    
    func expand(_ headerIndex: Int) {
        self.toogleVisible(headerIndex, isHidden: false)
    }
    
    func collapse(_ headerIndex: Int) {
        self.toogleVisible(headerIndex, isHidden: true)
    }
    
    private func toogleVisible(_ headerIndex: Int, isHidden: Bool) {
        var headerIndex = headerIndex
        headerIndex += 1
        
        while headerIndex < self.items.count && !(self.items[headerIndex] is HeaderItem) {
            self.items[headerIndex].isHidden = isHidden
            
            headerIndex += 1
        }
    }
}
