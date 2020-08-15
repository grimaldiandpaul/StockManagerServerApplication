//
//  FirebaseExtensions.swift
//  StockManagerServerApplication
//
//  Created by Joe Paul on 8/15/20.
//

import Foundation
import Firebase

extension Timestamp {
    convenience init(dataString: String){
        var dataString = dataString
        while dataString.first ?? "=" != "=" {
            dataString = String(dataString.dropFirst())
        }
        dataString = String(dataString.dropFirst())
        let secondsString = String(dataString.prefix(while: {$0 != " "}))
        
        while dataString.first ?? "=" != "=" {
            dataString = String(dataString.dropFirst())
        }
        dataString = String(dataString.dropFirst())
        let nanoSecondsString = String(dataString.prefix(while: {$0 != ">"}))
        
        if let seconds = Int64(secondsString), let nanoSeconds = Int32(nanoSecondsString){
            self.init(seconds: seconds, nanoseconds: nanoSeconds)
        } else {
            self.init(seconds: 0, nanoseconds: 0)
        }
    }
}
