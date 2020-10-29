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
        
        
        static let missingStoreIDField = StockManagerError(title: "Missing required field",
                                                           message: "Please include either the storeID or storeIDs field.",
                                                           code: 1103)
        
        static let missingUserDesignatedIDField = StockManagerError(title: "Missing required field",
                                                           message: "Please include the userDesignatedID field",
                                                           code: 1104)
        
        static let noUserResultsFound = StockManagerError(title: "No results found",
                                                          message: "No user could be found with this email.",
                                                          code: 1105)
        
        static let noItemResultsFound = StockManagerError(title: "No results found",
                                                          message: "No item could be found with this search.",
                                                          code: 1106)
        
        static let noInvitationCodeResultsFound = StockManagerError(title: "No results found",
                                                          message: "This invitation code could not be found.",
                                                          code: 1107)
        
        static let internalDatabaseSyncError = StockManagerError(title: "Internal Database Error",
                                                          message: "Please try again later.",
                                                          code: 1108)
        
        static let noItemImageResultsFound = StockManagerError(title: "No results found",
                                                          message: "No images could be found with this search.",
                                                          code: 1109)
        
        static let missingItemIDField = StockManagerError(title: "Missing required field",
                                                           message: "Please include either the id field.",
                                                           code: 1110)
        
        static let badItemData = StockManagerError(title: "Bad Data",
                                                           message: "One or more specified fields do not exist within an Item object.",
                                                           code: 1111)
        
        static let missingNameField = StockManagerError(title: "Missing required field",
                                                           message: "Please include the name field",
                                                           code: 1112)
        
        static let noTaskResultsFound = StockManagerError(title: "No results found",
                                                          message: "No task could be found with this ID.",
                                                          code: 1113)
        static let missingUserIDField = StockManagerError(title: "Missing required field",
                                                         message: "Please include the userID field",
                                                         code: 1114)
        
        static let missingCompanyIDField = StockManagerError(title: "Missing required field",
                                                             message: "Please include the companyID field",
                                                             code: 1115)
        
        static let missingInvitationCode = StockManagerError(title: "Missing required field",
                                                             message: "Please include the code field",
                                                             code: 1116)
        
        static let noCodeFound = StockManagerError(title: "No code found",
                                                             message: "This invitation code does not exist in the database",
                                                             code: 1117)
        
        static let all: [StockManagerError] = [nonUniqueIdentifier, missingStoreIDField, missingUserDesignatedIDField, noUserResultsFound, noItemResultsFound, noInvitationCodeResultsFound, internalDatabaseSyncError, noItemImageResultsFound, missingItemIDField, badItemData, missingNameField, noTaskResultsFound, missingUserIDField, missingCompanyIDField, missingInvitationCode]
    }
    
}
