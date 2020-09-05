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
                        print("Got here 1")
                        authenticationResult = false
                        error = StockManagerError.DatabaseErrors.connectionError
                    } else if let docs = snapshot?.documents {
                        
                        print("Got here 2")
                        if docs.count == 1, let doc = docs.first {
                            print("Got here 3")
                            let data = doc.data()
                            if let pk = data["pk"] as? String {
                                print("Got here 4")
                                if pk == encrypted {
                                    print("Got here 5")
                                    user = User.from(data).json
                                    authenticationResult = true
                                } else {
                                    print("Got here 6")
                                    print(pk)
                                    print(encrypted)
                                    authenticationResult = false
                                    error = StockManagerError.AuthenticationErrors.invalidCredentials
                                }
                            } else {
                                print("Got here 7")
                                authenticationResult = false
                                error = StockManagerError.AuthenticationErrors.missingCredentials
                            }
                            
                        } else if docs.count == 0 {
                            print("Got here 8")
                            authenticationResult = false
                            error = StockManagerError.DatabaseErrors.noUserResultsFound
                        } else if docs.count != 1 {
                            print("Got here 9")
                            authenticationResult = false
                            error = StockManagerError.DatabaseErrors.internalDatabaseSyncError
                        } else {
                            print("Got here 10")
                            authenticationResult = false
                            error = StockManagerError.unreachableError
                        }
                    } else {
                        print("Got here 11")
                        authenticationResult = false
                        error = StockManagerError.DatabaseErrors.connectionError
                    }
                }
            } else {
                print("Got here 12")
                authenticationResult = false
                error = StockManagerError.IOErrors.encryptionError
            }
        
        } else {
            print("Got here 13")
            authenticationResult = false
            error = StockManagerError.IOErrors.retrievalError
        }
        
        while( authenticationResult == nil ){
            sleep(1)
        }
        return (error, authenticationResult, user)
    }
    
    
}
