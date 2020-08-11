//
//  LocationExtensions.swift
//  StockManagerServerApplication
//
//  Created by Joe Paul on 8/11/20.
//

import Foundation

extension Location {

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
