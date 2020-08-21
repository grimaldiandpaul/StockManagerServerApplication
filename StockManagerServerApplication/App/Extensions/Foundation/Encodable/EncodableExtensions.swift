//
//  EncodableExtensions.swift
//  StockManagerServerApplication
//
//  Created By Zachary Grimaldi and Joseph Paul on 8/10/20.
//

import Foundation

/// An extension for objects that conform to Encodable or Codable
extension Encodable {
    
    /// An extension containing a computed variable for an Encodable object
    /// to handle to conversion of objects with only primitive data members
    /// to a dictionary object (aka how Swift handles a JSON).
    var json : [String:Any]? {
        if let data = try? JSONEncoder().encode(self) {
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                if let formattedJSON = jsonObject as? [String:Any] {
                    return formattedJSON
                } else {
                    LoggingManager.log("Could not typecast JSON to [String:Any]", source: .database, type: .error)
                    return nil
                }
            } else {
                LoggingManager.log("Could not serialize raw data segment to JSON", source: .database, type: .error)
                return nil
            }
        } else {
            LoggingManager.log("Could not convert Encodable data object to raw data", source: .database, type: .error)
            return nil
        }
    }
    
    
}
