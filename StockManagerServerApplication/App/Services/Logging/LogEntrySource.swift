//
//  LogEntrySource.swift
//  StockManagerWebServer
//
//  Created By Zachary Grimaldi and Joseph Paul on 8/9/20.
//  Copyright © 2020 Zachary Grimaldi. All rights reserved.
//

import Foundation

enum LogEntrySource: String, Codable {
    case general = "General"
    case webApp = "Web App"
    case dataValidation = "Data Validation"
    case authentication = "Authentication"
    case stripeBilling = "Stripe Billing"
    case textMessaging = "Text Messaging"
    case logging = "Logging"
    case routing = "Routing"
    case database = "Database"
    case limitations = "Limitations"
    case itemDecoding = "Item Decoding"
    
    static var all: [LogEntrySource] {
        return [.webApp, .dataValidation, .authentication, .stripeBilling, .textMessaging, .logging, .routing, .database, .limitations, .itemDecoding]
    }
}
