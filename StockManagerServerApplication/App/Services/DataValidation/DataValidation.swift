//
//  DataValidation.swift
//  StockManagerServerApplication
//
//  Created by Joe Paul on 8/10/20.
//

import Foundation

class DataValidation {
    
    static let main = DataValidation()
    typealias DataValidationResult = (error: String?, valid: Bool)
    
    class func validateFields(item: InventoryItem) -> DataValidationResult {
        
        if item.id == "" {
            return ("ID field cannot be empty", false)
        } else {
            return (nil, true)
        }
    }
}
