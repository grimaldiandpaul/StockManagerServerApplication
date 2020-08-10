//
//  LoggingSweeper.swift
//  StockManagerWebServer
//
//  Created by Joe Paul on 8/9/20.
//  Copyright © 2020 Zachary Grimaldi. All rights reserved.
//

import Foundation

class LoggingSweeper {
    
    static let main = LoggingSweeper()
    
    class func sweep() {
        let fileName = Date().sweeperOutputString + ".txt"
        let title = "The Logging Sweeper created this backup on: \(Date().viewOutputString)"
        let beingSwept = LoggingManager.main.logs
        LoggingManager.main.logs.removeAll()
        var resultingFileContents = title
        for log in beingSwept {
            resultingFileContents += "\n\n\n"
            resultingFileContents += log.output
        }
        if let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let url = URL(fileURLWithPath: path).appendingPathComponent(fileName)
            if let _ = try? resultingFileContents.data(using: .utf8)?.write(to: url) {
                LoggingManager.log("LoggingSweeper created a backup on: \(Date().viewOutputString)", source: .logging, type: .success)
            } else {
                LoggingManager.log("LoggingSweeper could not write backup.", source: .logging, type: .warning)
            }
        } else {
            LoggingManager.log("LoggingSweeper could not create backup path.", source: .logging, type: .error)
            for log in beingSwept {
                LoggingManager.main.logs.append(log)
            }
        }
    }
}
