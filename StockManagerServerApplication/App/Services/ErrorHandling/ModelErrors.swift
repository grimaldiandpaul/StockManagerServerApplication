//
//  ModelErrors.swift
//  StockManagerServerApplication
//
//  Created By Zachary Grimaldi and Joseph Paul on 8/20/20.
//

import Foundation

/// Model Errors exist in the range **1000-1099**

extension StockManagerError {
    
    static let itemReferenceURL = ""
    static let itemReference = " Visit \(StockManagerError.itemReferenceURL) for more information."
    
    
    class ModelErrors {
        
        static let illegalLocationType = StockManagerError(title: "Illegal LocationType value in InventoryItem",
                                                        message: "Please retry with the defined format.\(StockManagerError.itemReference)",
                                                        code: 1001)
        
        static let illegalPackaging = StockManagerError(title: "Illegal Packaging value in InventoryItem",
                                                     message: "Please retry with the defined format.\(StockManagerError.itemReference)",
                                                     code: 1002)
    }
    
    
}
