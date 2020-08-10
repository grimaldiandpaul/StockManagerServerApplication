//
//  LogEntryType.swift
//  StockManagerWebServer
//
//  Created by Joe Paul on 8/9/20.
//  Copyright © 2020 Zachary Grimaldi. All rights reserved.
//

import Foundation

enum LogEntryType: String, Codable {
    case general = "General"
    case warning = "Warning"
    case error = "Error"
    case success = "Success"
    case failure = "Failure"
    
    static var all: [LogEntryType] {
        return [.general, .warning, .error, .success, .failure]
    }
}
