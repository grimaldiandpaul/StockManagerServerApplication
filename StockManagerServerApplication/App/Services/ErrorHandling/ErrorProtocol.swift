//
//  ErrorProtocol.swift
//  StockManagerServerApplication
//
//  Created By Zachary Grimaldi and Joseph Paul on 8/20/20.
//

import Foundation

protocol ErrorProtocol: LocalizedError {
    var title: String? { get }
    var message: String? { get }
    var code: Int { get }
}

struct StockManagerError: ErrorProtocol {
    
    var title: String?
    var message: String?
    var code: Int
    
    var output: String {
        
        var result = ""
        result += "Error \(code)"
        if let title = self.title, let message = self.message {
            result += ": \(title.uppercased()) - \(message)"
        }
        else if let title = self.title {
            result += ": \(title)"
        }
        else if let message = self.message {
            result += ": \(message)"
        }
        return result
    }
}
