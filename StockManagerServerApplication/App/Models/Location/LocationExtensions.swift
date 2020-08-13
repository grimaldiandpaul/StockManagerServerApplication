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
}
