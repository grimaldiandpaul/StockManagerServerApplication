//
//  AuthenticationErrors.swift
//  StockManagerServerApplication
//
//  Created By Zachary Grimaldi and Joseph Paul on 8/20/20.
//

import Foundation


/// An extension for our custom StockManagerError object
extension StockManagerError {
    
    /// Authentication Error codes exist in the range **1200-1299**
    
    /// An inner-class of StockManagerError for statically available
    /// errors relating to Authentication operations within the application.
    class AuthenticationErrors {
        
        
        static let connectionError = StockManagerError(title: "Unable to process",
                                                    message: "An internal error occurred connecting to authentication service. Please try again later.",
                                                    code: 1201)
        
        static let userNotFound = StockManagerError(title: "User could not be found.",
                                                 code: 1202)
        
        static let invalidCredentials = StockManagerError(title: "Invalid Credentials",
                                                       message: "Email and password do not match our records.",
                                                       code: 1203)
        
        static let emptyEmail = StockManagerError(title: "No email provided.",
                                               code: 1204)
        
        static let emptyPassword = StockManagerError(title: "No password provided.",
                                                  code: 1205)
        
        static let missingCredentials = StockManagerError(title: "Missing Credentials",
                                                       message: "Please include credentials in the body of the request.",
                                                       code: 1206)
        
        static let incompleteInvitationCode = StockManagerError(title: "Incomplete Invitation Code",
                                                                message: "Please contact a company administrator.",
                                                                code: 1207)
        
        static let accountAlreadyExists = StockManagerError(title: "Account already exists",
                                                                message: "Please try logging in.",
                                                                code: 1208)
        
        static let expiredCode = StockManagerError(title: "Code Expired",
                                                                message: "This code has either expired of been revoked. Please contact administation.",
                                                                code: 1209)

        static let all: [StockManagerError] = [connectionError, userNotFound, invalidCredentials, emptyEmail, emptyPassword, missingCredentials, incompleteInvitationCode, accountAlreadyExists, expiredCode]
    }
}
