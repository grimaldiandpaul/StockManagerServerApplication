//
//  Location.swift
//  
//
//  Created By Zachary Grimaldi and Joseph Paul on 5/23/20.
//

/// A struct describing one location an `InventoryItem` is stored at.
struct Location: Codable {
    
    var aisle : String
    var aisleSection : String
    var spot : String
    var description : String
    var type : LocationType
    var accessibility : Accessibility
    
    public init(aisle: String = "", aisleSection: String = "", spot: String = "", description: String = "",
                type: LocationType = .unknown, accessibility: Accessibility = .unprocessed) {
        self.aisle = aisle
        self.aisleSection = aisleSection
        self.spot = spot
        self.description = description
        self.type = type
        self.accessibility = accessibility
    }
    
}
