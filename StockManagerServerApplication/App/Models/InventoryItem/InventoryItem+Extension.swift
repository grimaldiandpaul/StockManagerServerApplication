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
    
    static func from(_ object: [String:Any]) -> InventoryItem? {
        if let data = try? JSONSerialization.data(withJSONObject: object, options: .fragmentsAllowed),
        let item = try? JSONDecoder().decode(InventoryItem.self, from: data) {
            return item
        } else {
            LoggingManager.log("Item could not be decoded from dictionary", source: .itemDecoding, type: .error)
            return nil
        }
    }
}
