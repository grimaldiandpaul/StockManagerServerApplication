//
//  File.swift
//  
//
//  Created by Joe Paul on 5/23/20.
//

import Foundation
import FirebaseFirestore

extension InventoryItem {
    var totalInStoreQuantity: Int?{
        if let backstockQuantity = self.backstockQuantity,
            let customerAccessibleQuantity = self.customerAccessibleQuantity {
            return backstockQuantity + customerAccessibleQuantity
        } else {
            return nil
        }
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
    
    var json: [String:Any]? {
        var result = [String:Any]()
        
        if self.id != "" {
            result["id"] = self.id
        }
        
        if self.userDesignatedID != "" {
            result["userDesignatedID"] = self.userDesignatedID
        }
        
        if self.name != "" {
            result["name"] = self.name
        }
        
        if !self.locations.isEmpty {
            result["locations"] = self.locations.map({$0.json})
        }
        
        if let dateLastPurchased = self.dateLastPurchased {
            result["dateLastPurchased"] = dateLastPurchased
        }
        
        if let customerAccessibleQuantity = self.customerAccessibleQuantity {
            result["customerAccessibleQuantity"] = customerAccessibleQuantity
        }
        
        if let backstockQuantity = self.backstockQuantity {
            result["backstockQuantity"] = backstockQuantity
        }
        
        return result
    }
}
