//
//  File.swift
//  
//
//  Created by Joe Paul on 5/23/20.
//

import Foundation
import Firebase

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
        print(object.debugDescription)
        
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
        
        if let locations = object["locations"] as? [[String:Any]] {
            for location in locations {
                let fromLocation = Location.from(location)
                item.locations.append(fromLocation)
            }
        }
        
        if let dateLastPurchased = object["dateLastPurchased"] as? Timestamp? {
            item.dateLastPurchased = dateLastPurchased
        } else if let dateLastPurchased = object["dateLastPurchased"] as? String, dateLastPurchased.contains("FIRTimestamp") {
            let dateLastPurchasedFromString = Timestamp(dataString: dateLastPurchased)
            if dateLastPurchasedFromString.seconds != 0 {
                item.dateLastPurchased = dateLastPurchasedFromString
            }
        }
        
        if let customerAccessibleQuantity = object["customerAccessibleQuantity"] as? Int {
            item.customerAccessibleQuantity = customerAccessibleQuantity
        } else if let customerAccessibleQuantity = object["customerAccessibleQuantity"] as? String,
            let parsedInteger = Int(customerAccessibleQuantity) {
                item.customerAccessibleQuantity = parsedInteger
        }
        
        if let backstockQuantity = object["backstockQuantity"] as? Int {
            item.backstockQuantity = backstockQuantity
        } else if let backstockQuantity = object["backstockQuantity"] as? String,
            let parsedInteger = Int(backstockQuantity) {
                item.backstockQuantity = parsedInteger
        }
        
        return item
    }
    
    var firebasejson: [String:Any] {
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
    
    var json: [String:Any] {
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
            result["dateLastPurchased"] = "<FIRTimestamp: seconds=\(dateLastPurchased.seconds) nanoseconds=\(dateLastPurchased.nanoseconds)>"
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
