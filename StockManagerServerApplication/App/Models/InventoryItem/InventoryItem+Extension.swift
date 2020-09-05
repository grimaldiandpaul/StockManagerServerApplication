//
//  InventoryItem+Extensions.swift
//  
//
//  Created By Zachary Grimaldi and Joseph Paul on 5/23/20.
//

import Firebase

/// An extension for our custom InventoryItem object
extension InventoryItem {
    
    /// a sum of any back-stock and customer-accessible stock, or nil if untracked
    /// this value could very well return 0 if tracked using StockManager.
    var totalInStoreQuantity: Int? {
        
        // if the item contains back-stock and customer-accessible stock
        if let backstockQuantity = self.backstockQuantity,
            let customerAccessibleQuantity = self.customerAccessibleQuantity {
            return backstockQuantity + customerAccessibleQuantity
        }
        
        // else if the item only contains back-stock
        else if let backstockQuantity = self.backstockQuantity {
            return backstockQuantity
        }
        
        // else if the item only contains customer-accessible stock
        else if let customerAccessibleQuantity = self.customerAccessibleQuantity {
            return customerAccessibleQuantity
        }
        
        // there was no tracked inventory quantities for this item
        else {
            return nil
        }
    }
    
    /// A statically available function to define an InventoryItem from a JSON object
    static func from(_ object: [String:Any]) -> InventoryItem {
        
        // uncomment the following line to print the JSON object for debugging
        // print(object.debugDescription)
        
        // declare an empty InventoryItem to fill based on the JSON keys & values
        var item = InventoryItem()
        
        // if the object contains an `id` field, add it to the InventoryItem
        if let id = object["id"] as? String {
            item.id = id
        }
        // otherwise, create a unique identifier
        else {
            item.id = UUID.uuidStringTwentyCharsNoDashes
        }
        
        // if the object contains a `userDesignatedID` field, add it to the InventoryItem
        if let userDesignatedID = object["userDesignatedID"] as? String {
            item.userDesignatedID = userDesignatedID
        }
        
        // if the object contains a `name` field, add it to the InventoryItem
        if let name = object["name"] as? String {
            item.name = name
        }
        
        // if the object contains a `locations` field, add it to the InventoryItem
        if let locations = object["locations"] as? [[String:Any]] {
            for location in locations {
                let fromLocation = Location.from(location)
                item.locations.append(fromLocation)
            }
        }
        
        // if the object contains a `dateLastPurchased` field, add it to the InventoryItem
        // it may be a Timestamp object or a Timestamp dataString depending on the source of the JSON object
        if let dateLastPurchased = object["dateLastPurchased"] as? Int64? {
            item.dateLastPurchased = dateLastPurchased
        } else if let dateLastPurchased = object["dateLastPurchased"] as? String, dateLastPurchased.contains("FIRTimestamp") {
            let dateLastPurchasedFromString = Timestamp(dataString: dateLastPurchased).seconds
            if dateLastPurchasedFromString != 0 {
                item.dateLastPurchased = dateLastPurchasedFromString
            }
        }
        
        // if the object contains a `customerAccessibleQuantity` field, add it to the InventoryItem
        // it may be formatted as an integer or a string depending on the source of the JSON object
        if let customerAccessibleQuantity = object["customerAccessibleQuantity"] as? Int {
            item.customerAccessibleQuantity = customerAccessibleQuantity
        } else if let customerAccessibleQuantity = object["customerAccessibleQuantity"] as? String,
            let parsedInteger = Int(customerAccessibleQuantity) {
                item.customerAccessibleQuantity = parsedInteger
        }
        
        // if the object contains a `backstockQuantity` field, add it to the InventoryItem
        // it may be formatted as an integer or a string depending on the source of the JSON object
        if let backstockQuantity = object["backstockQuantity"] as? Int {
            item.backstockQuantity = backstockQuantity
        } else if let backstockQuantity = object["backstockQuantity"] as? String,
            let parsedInteger = Int(backstockQuantity) {
                item.backstockQuantity = parsedInteger
        }
        
        // return the filled InventoryItem
        return item
    }
    
}
