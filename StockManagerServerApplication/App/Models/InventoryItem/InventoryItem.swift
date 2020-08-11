//
//  File.swift
//  
//
//  Created by Zachary Grimaldi on 5/18/20.
//

import Foundation
import FirebaseFirestore

/**
 
## Description

This is the base class for an inventory-managed product in the StockManagerAPI.
 
 
## Dependencies

[`Foundation`](https://developer.apple.com/documentation/foundation)
 
 
## Usage
    
```swift
let item = InventoryItem(
```
 
*/
struct InventoryItem: Identifiable {
    
    /**
     
    Description: The internal identifier, specific to our system.
    Type: [`UUID`](https://developer.apple.com/documentation/foundation/uuid)
    */
    var id : String
    
    /**
     
    Description: Identifier optional if client has their own system identifier
    */
    var userDesignatedID: String
    
    /**
     
    Description: The name of the item
    */
    var name: String
    
    /**
     
    An array Locations
     
    ### Tuple Members: ###
        
    0: [`Location`](https://docs.stockmanager.tech/docs/Location)
     
    1: [`LocationType`](https://docs.stockmanager.tech/docs/LocationType)
     
    2: [`Accessibility`](https://docs.stockmanager.tech/docs/Accessibility)
     
    */
    var locations: [Location]
    
    /**
     
    Description: The quantity of this item available for purchase by customers
    */
    var customerAccessibleQuantity: Int?
    
    /**
     
    Description: The quantity of this item NOT available for purchase by customers. This may be because the item is unprocessed, on hold, etc.
    */
    var backstockQuantity: Int?
    
    /**
     
    Description: The date that this item was last purchased from a register at this location. (Independent of any store returns)
    Type: [`Date`](https://developer.apple.com/documentation/foundation/date)
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
