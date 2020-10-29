//
//  APIErrors.swift
//  StockManagerServerApplication
//
//  Created By Zachary Grimaldi and Joseph Paul on 8/20/20.
//

import Foundation


/// An extension for our custom StockManagerError object
extension StockManagerError {
    
    /// API Error codes exist in the range **1300-1399**
    
    /// An inner-class of StockManagerError for statically available
    /// errors relating to API/Handler/HTTP operations within the application.
    class APIErrors {
        
        static let missingData = StockManagerError(title: "Missing Data",
                                                   message: "Please include all details inside of parameters or body.",
                                                   code: 1301)
        
        static let missingStoreID = StockManagerError(title: "Missing Store ID",
                                                      message: "Please include storeID field in body.",
                                                      code: 1302)
        
        static let castingError = StockManagerError(title: "Internal Error",
                                                    message: "Error casting your HTTPRequest to a readable format.",
                                                    code: 1303)
        
        static let missingTaskID = StockManagerError(title: "Missing Task ID",
                                                      message: "Please include taskID field in body.",
                                                      code: 1304)
        
        static let all: [StockManagerError] = [missingData, missingStoreID, castingError, missingTaskID]
    }
    
    
}
