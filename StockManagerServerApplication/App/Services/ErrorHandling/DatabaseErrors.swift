//
//  DatabaseErrors.swift
//  StockManagerServerApplication
//
//  Created By Zachary Grimaldi and Joseph Paul on 8/20/20.
//

import Foundation


/// An extension for our custom StockManagerError object
extension StockManagerError {
    
    /// Database Error codes exist in the range **1100-1199**
    
    /// An inner-class of StockManagerError for statically available
    /// errors relating to Database operations within the application.
    class DatabaseErrors {
        
        static let connectionError = StockManagerError(title: "Unable to process",
        message: "An internal error occurred connecting to cloud database service. Please try again later",
        code: 1101)
        
        static let nonUniqueIdentifier = StockManagerError(title: "ID In Use",
        message: "An item already exists with this ID. Please use a unique ID.",
        code: 1102)
        
        
    }
    
    
}
