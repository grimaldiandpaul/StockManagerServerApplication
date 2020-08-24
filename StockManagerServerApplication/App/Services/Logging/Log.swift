//
//  Log.swift
//  StockManagerWebServer
//
//  Created By Zachary Grimaldi and Joseph Paul on 8/9/20.
//  Copyright © 2020 Zachary Grimaldi. All rights reserved.
//

import Firebase

/// Custom Log struct for use in LoggingManager
struct Log: Hashable {
    var message: String
    var time: Timestamp
    var source: LogEntrySource
    var type: LogEntryType
    
    var output: String {
        var result = "🚩"
        result += self.time.dateValue().viewOutputString
        result += "     "
        result += self.source.rawValue
        result += "     "
        result += self.type.rawValue
        result += "     "
        result += self.message
        return result
    }
}
