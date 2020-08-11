//
//  File.swift
//  
//
//  Created by Joe Paul on 5/23/20.
//

import Foundation

struct Location: Codable {
    
    var aisle : String
    var aisleSection : String
    var spot : String
    var description : String
    var type : LocationType
    var accessibility : Accessibility
    
    public init(_ description: String){
        self.aisle = ""
        self.aisleSection = ""
        self.spot = ""
        self.description = description
        self.type = .unknown
        self.accessibility = .unprocessed
    }
    
    public init(aisle: String, aisleSection: String, spot: String = "", description: String = ""){
        self.aisle = aisle
        self.aisleSection = aisleSection
        self.spot = spot
        self.description = description
        self.type = .unknown
        self.accessibility = .unprocessed
    }
    
}
