//
//  InventoryItem.swift
//  
//
//  Created By Zachary Grimaldi and Joseph Paul on 5/18/20.
//

import Firebase

/**
 
## Description

This is the base class for an inventory-managed product in the StockManagerAPI.
 
 
## Dependencies

[`Foundation`](https://developer.apple.com/documentation/foundation)
[`Firebase`](https://github.com/firebase/firebase-ios-sdk)
 
*/
struct InventoryItem: Identifiable {
    
    /**
     
    Description: The internal identifier, specific to our system.
    Type: String
    */
    var id : String
    
    /**
     
    Description: Identifier optional if client has their own system identifier
    Type: String
    */
    var userDesignatedID: String
    
    /**
     
    Description: The name of the item
    Type: String
    */
    var name: String
    
    /**
     
    Description: An array of `Location` objects
    Type: [Location]
    */
    var locations: [Location]
    
    /**
     
    Description: The quantity of this item available for purchase by customers
    Type: Int? (Int Optional)
    */
    var customerAccessibleQuantity: Int?
    
    /**
     
    Description: The quantity of this item NOT available for purchase by customers. This may be because the item is unprocessed, on hold, etc.
    Type: Int? (Int Optional)
    */
    var backstockQuantity: Int?
    
    /**
     
    Description: The date that this item was last purchased from a register at this location. (Independent of any store returns)
    Type: [`Timestamp`](https://developers.google.com/protocol-buffers/docs/reference/java/com/google/protobuf/Timestamp.html?is-external=true)
    */
    var dateLastPurchased: Timestamp?
    
    
    
    init(userDesignatedID: String = "", name: String = "", locations: [Location] = [], dateLastPurchased: Timestamp? = nil, customerAccessibleQuantity: Int? = nil, backstockQuantity: Int? = nil) {
        self.id = UUID.uuidStringTwentyCharsNoDashes
        self.userDesignatedID = userDesignatedID
        self.name = name
        self.locations = locations
        self.dateLastPurchased = dateLastPurchased
        if let customerAccessibleQuantity = customerAccessibleQuantity {
            self.customerAccessibleQuantity = customerAccessibleQuantity
        }
        if let backstockQuantity = backstockQuantity {
            self.backstockQuantity = backstockQuantity
        }
    }
}
