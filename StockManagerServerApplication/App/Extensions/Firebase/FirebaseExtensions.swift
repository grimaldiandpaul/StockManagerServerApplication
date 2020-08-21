//
//  FirebaseExtensions.swift
//  StockManagerServerApplication
//
//  Created By Zachary Grimaldi and Joseph Paul on 8/15/20.
//

import Foundation
import Firebase

/// An extension for Firebase's `Timestamp` object
extension Timestamp {
    
    /// A custom initializer to create a Timestamp from a Base 64 Encoded String
    convenience init(dataString: String){
        
        // copy the data string by value
        var dataString = dataString
        
        
        // chop off known unnecessary characters to get the number of
        // FULL seconds since the UNIX EPOCH
        while dataString.first ?? "=" != "=" {
            dataString = String(dataString.dropFirst())
        }
        dataString = String(dataString.dropFirst())
        let secondsString = String(dataString.prefix(while: {$0 != " "}))
        
        
        // chop off known unnecessary characters to get the number of
        // nanoseconds (PARTIAL second) leftover
        while dataString.first ?? "=" != "=" {
            dataString = String(dataString.dropFirst())
        }
        dataString = String(dataString.dropFirst())
        let nanoSecondsString = String(dataString.prefix(while: {$0 != ">"}))
        
        
        // initialize the Timestamp if all worked out decoding the data string
        if let seconds = Int64(secondsString), let nanoSeconds = Int32(nanoSecondsString){
            self.init(seconds: seconds, nanoseconds: nanoSeconds)
        } else {
            self.init(seconds: 0, nanoseconds: 0)
        }
        
    }
    
}
