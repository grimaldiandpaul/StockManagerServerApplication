//
//  LoggingManager.swift
//  StockManagerWebServer
//
//  Created by Joe Paul on 8/9/20.
//  Copyright © 2020 Zachary Grimaldi. All rights reserved.
//

import Foundation
import FirebaseFirestore

class LoggingManager {
    
    static let main = LoggingManager()
    
    var logs = [Log]()
    
    class func log(_ message: String, source: LogEntrySource = .general, type: LogEntryType = .general){
        let newLog = Log(message: message, time: Timestamp(date: Date()), source: source, type: type)
        
        LoggingManager.main.logs.append(newLog)
        
        if LoggingManager.main.logs.count >= 1000 {
            LoggingSweeper.sweep()
        }
    }
}
