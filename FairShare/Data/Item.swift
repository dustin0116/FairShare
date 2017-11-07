//
//  Item.swift
//  FairShare
//
//  Created by Dustin Hsiang on 7/11/17.
//  Copyright © 2017 Dustin Hsiang. All rights reserved.
//

import Foundation

class Item {
    
    var isChecked: Bool
    var itemLabel = "Item"
    var itemNumber: Int
    var itemPrice: Double = 0.0
    
    init(itemNumber: Int, isChecked: Bool, itemPrice: Double = 0.0) {
        self.isChecked = isChecked
        self.itemNumber = itemNumber
        self.itemPrice = itemPrice
    }
}
