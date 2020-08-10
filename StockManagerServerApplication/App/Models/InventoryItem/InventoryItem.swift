//
//  File.swift
//  
//
//  Created by Zachary Grimaldi on 5/18/20.
//

import Foundation

/**
 
## Description

This is the base class for an inventory-managed product in the StockManagerAPI.
 
 
## Dependencies

[`Foundation`](https://developer.apple.com/documentation/foundation)
 
 
## Usage
    
```swift
let item = InventoryItem(name: "An Item", locations: [(Location("Somewhere"), .jHook, .processed)], customerAccessibleQuantity: 0, backstockQuantity: 0)
```
 
*/
open class InventoryItem: Identifiable, Codable {
    
    /**
     
    Description: The internal identifier, specific to our system.
    Type: [`UUID`](https://developer.apple.com/documentation/foundation/uuid)
    */
    open var id : String
    
    /**
     
    Description: Identifier optional if client has their own system identifier
    */
    open var userDesignatedID: String
    
    /**
     
    Description: The name of the item
    */
    open var name: String
    
    /**
     
    An array of tuples describing an inventory item's location and accessibility
     
    ### Tuple Members: ###
        
    0: [`Location`](https://docs.stockmanager.tech/docs/Location)
     
    1: [`LocationType`](https://docs.stockmanager.tech/docs/LocationType)
     
    2: [`Accessibility`](https://docs.stockmanager.tech/docs/Accessibility)
     
    */
    open var locations: [(Location, LocationType, Accessibility)]
    
    /**
     
    Description: The quantity of this item available for purchase by customers
    */
    open var customerAccessibleQuantity: Int
    
    /**
     
    Description: The quantity of this item NOT available for purchase by customers. This may be because the item is unprocessed, on hold, etc.
    */
    open var backstockQuantity: Int
    
    /**
     
    Description: The date that this item was last purchased from a register at this location. (Independent of any store returns)
    Type: [`Date`](https://developer.apple.com/documentation/foundation/date)
    */
    open var dateLastPurchased: Date?
    
    
    
    public init(userDesignatedID: String = "", name: String, locations: [(Location, LocationType, Accessibility)] = [], dateLastPurchased: Date? = nil, customerAccessibleQuantity: Int = 0, backstockQuantity: Int = 0) {
        self.id = UUID().uuidString
        self.userDesignatedID = userDesignatedID
        self.name = name
        self.locations = locations
        self.dateLastPurchased = dateLastPurchased
        self.customerAccessibleQuantity = customerAccessibleQuantity
        self.backstockQuantity = backstockQuantity
    }
}
