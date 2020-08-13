//
//  LocationExtensions.swift
//  StockManagerServerApplication
//
//  Created by Joe Paul on 8/11/20.
//

import Foundation

extension Location {

    var json : [String:Any] {
        
        var result = [String:Any]()
        
        result["accessibility"] = self.accessibility.rawValue
        result["aisle"] = self.aisle
        result["spot"] = self.spot
        result["aisleSection"] = self.aisleSection
        result["description"] = self.description
        result["type"] = self.type.rawValue
        
        return result
    }
    
    static func from(_ object: [String:Any]) -> Location {
        var result = Location()
        
        if let accessibility = object["accessibility"] as? String {
            if let accessibility = Accessibility(rawValue: accessibility) {
                result.accessibility = accessibility
            } else {
                result.accessibility = .unprocessed
            }
        } else {
            result.accessibility = .unprocessed
        }
        
        if let aisle = object["aisle"] as? String {
            result.aisle = aisle
        } else {
            result.aisle = ""
        }
        
        if let type = object["type"] as? String {
            if let type = LocationType(rawValue: type) {
                result.type = type
            } else {
                result.type = .unknown
            }
        } else {
            result.type = .unknown
        }
        
        if let description = object["description"] as? String {
            result.description = description
        } else {
            result.description = ""
        }
        
        if let spot = object["spot"] as? String {
            result.spot = spot
        } else {
            result.spot = ""
        }
        
        if let aisleSection = object["aisleSection"] as? String {
            result.aisleSection = aisleSection
        } else {
            result.aisleSection = ""
        }

        return result
    }
}
