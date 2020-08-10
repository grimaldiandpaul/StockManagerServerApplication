//
//  File.swift
//  
//
//  Created by Joe Paul on 5/23/20.
//

import Foundation

extension InventoryItem {
    var totalInStoreQuantity: Int{
        return self.backstockQuantity + self.customerAccessibleQuantity
    }
}
