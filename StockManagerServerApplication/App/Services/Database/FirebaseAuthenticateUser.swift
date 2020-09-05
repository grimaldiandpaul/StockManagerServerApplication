//
//  FirebaseAuthenticateUser.swift
//  StockManagerServerApplication
//
//  Created By Zachary Grimaldi and Joseph Paul on 8/18/20.
//

import Foundation
import Firebase

/// An extension for our FirebaseWrapper singleton
extension FirebaseWrapper {
    
    /// A static function that synchronously authenticates a user email and password
    /// - Parameter email: the user's email
    /// - Parameter password: the user's password
    /// - Returns:FirebaseWrapperAuthenticationResult = (error: StockManagerError?, successful: Bool?, user: Data?)
    class func authenticateUser(email: String, password: String) -> FirebaseWrapperAuthenticationResult {
        
        var error: StockManagerError? = nil
        var authenticationResult: Bool? = nil
        var user: [String:Any]? = nil
        
        #warning("this will need fixed on mac mini")
        let file = "/Users/joepauljoe/Downloads/keyandiv.txt"
        let path = URL(fileURLWithPath: file)
        if var iv = try? String(contentsOf: path){
            let key = String(iv.prefix(while: {$0 != "\n"}))
            while iv.contains("\n"){
                iv = String(iv.dropFirst())
            }
            print(key)
            print(iv)
            if let encrypted = try? password.encrypt(key: key, iv: iv){
            
                FirebaseWrapper.authenticateUserReference(email).getDocuments { (snapshot, snapshotErr) in
                    if let _ = snapshotErr {
                        authenticationResult = false
                        error = StockManagerError.DatabaseErrors.connectionError
                    } else if let docs = snapshot?.documents {
                        
                        if docs.count == 1, let doc = docs.first {
                            let data = doc.data()
                            if let pk = data["pk"] as? String {
                                if pk == encrypted {
                                    user = User.from(data).json
                                    authenticationResult = true
                                } else {
                                    authenticationResult = false
                                    error = StockManagerError.AuthenticationErrors.invalidCredentials
                                }
                            } else {
                                authenticationResult = false
                                error = StockManagerError.AuthenticationErrors.missingCredentials
                            }
                            
                        } else if docs.count == 0 {
                            authenticationResult = false
                            error = StockManagerError.DatabaseErrors.noUserResultsFound
                        } else if docs.count != 1 {
                            authenticationResult = false
                            error = StockManagerError.DatabaseErrors.internalDatabaseSyncError
                        } else {
                            authenticationResult = false
                            error = StockManagerError.unreachableError
                        }
                    } else {
                        authenticationResult = false
                        error = StockManagerError.DatabaseErrors.connectionError
                    }
                }
            } else {
                authenticationResult = false
                error = StockManagerError.IOErrors.encryptionError
            }
        
        } else {
            authenticationResult = false
            error = StockManagerError.IOErrors.retrievalError
        }
        
        return (error, authenticationResult, user)
    }
    
    
}
