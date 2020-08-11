//
//  File.swift
//  
//
//  Created by Joe Paul on 5/23/20.
//

import Foundation
import FirebaseFirestore

extension InventoryItem {
    var totalInStoreQuantity: Int{
        return self.backstockQuantity + self.customerAccessibleQuantity
    }
    
    static func from(_ object: [String:Any]) -> InventoryItem {
        
        var item = InventoryItem()
        
        if let id = object["id"] as? String {
            item.id = id
        } else {
            item.id = UUID.uuidStringTwentyCharsNoDashes
        }
        
        if let userDesignatedID = object["userDesignatedID"] as? String {
            item.userDesignatedID = userDesignatedID
        }
        
        if let name = object["name"] as? String {
            item.name = name
        }
        
        if let locations = object["locations"] as? [Location] {
            item.locations = locations
        }
        
        if let dateLastPurchased = object["dateLastPurchased"] as? Timestamp? {
            item.dateLastPurchased = dateLastPurchased
        }
        
        if let customerAccessibleQuantity = object["customerAccessibleQuantity"] as? Int {
            item.customerAccessibleQuantity = customerAccessibleQuantity
        }
        
        if let backstockQuantity = object["backstockQuantity"] as? Int {
            item.backstockQuantity = backstockQuantity
        }
        
        return item
    }
}
