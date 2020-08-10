//
//  InventoryItemDataExtensions.swift
//  StockManagerServerApplication
//
//  Created by Joe Paul on 8/10/20.
//

import Foundation
import StockManagerDotTechModels

extension InventoryItem {
    
    static func from(_ object: [String:Any]) {
        if let data = try? JSONSerialization.data(withJSONObject: object, options: .fragmentsAllowed) {
            if let item = JSONDecoder().decode(InventoryItem.self, from: data) {
                
            }
        }
    }
}
