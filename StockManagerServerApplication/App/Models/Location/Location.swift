//
//  File.swift
//  
//
//  Created by Joe Paul on 5/23/20.
//

import Foundation

open class Location {
    
    open var aisle : String
    open var aisleSection : String
    open var spot : String
    open var description : String
    
    public init(_ description: String){
        self.aisle = ""
        self.aisleSection = ""
        self.spot = ""
        self.description = description
    }
    
    public init(aisle: String, aisleSection: String, spot: String = "", description: String = ""){
        self.aisle = aisle
        self.aisleSection = aisleSection
        self.spot = spot
        self.description = description
    }
    
}
