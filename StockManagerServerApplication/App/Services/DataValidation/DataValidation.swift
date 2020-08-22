//
//  DataValidation.swift
//  StockManagerServerApplication
//
//  Created By Zachary Grimaldi and Joseph Paul on 8/10/20.
//

import Foundation

/// Custom class for purposes of validating data
class DataValidation {
    
    static let main = DataValidation()
    typealias DataValidationResult = (error: StockManagerError?, valid: Bool)
    
    
    /// A function that validates all fields of an `InventoryItem`
    /// - Parameter item: an InventoryItem object
    /// - Returns:DataValidationResult = (error: StockManagerError?, valid: Bool?)
    class func validateFields(item: InventoryItem) -> DataValidationResult {
        
        if item.id == "" {
            return (StockManagerError.ModelErrors.missingIdentifier, false)
        } else {
            return (nil, true)
        }
    }
}
