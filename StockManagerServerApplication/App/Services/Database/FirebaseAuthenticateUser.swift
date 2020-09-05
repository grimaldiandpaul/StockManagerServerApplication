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
    class func authenticateUser(email: String, password: String, ipAddress: String?) -> FirebaseWrapperAuthenticationResult {
        
        var error: StockManagerError? = nil
        var authenticationResult: Bool? = nil
        var user: [String:Any]? = nil
        
        #warning("this will need fixed on mac mini")
        let file = "/Users/joepauljoe/Downloads/keyandiv.txt"
        let path = URL(fileURLWithPath: file)
        
        // Try to read the key and iv from the local file
        if var iv = try? String(contentsOf: path) {
            let key = String(iv.prefix(while: {$0 != "\n"}))
            while iv.contains("\n"){
                iv = String(iv.dropFirst())
            }
            print(key)
            print(iv)
            
            // Try to encrypt the password with the key and iv
            if let encrypted = try? password.encrypt(key: key, iv: iv) {
            
                // Get the user document from Firebase
                FirebaseWrapper.userReference(email: email).getDocuments { (snapshot, snapshotErr) in
                    
                    // If there was an error, set the variables
                    if let _ = snapshotErr {
                        authenticationResult = false
                        error = StockManagerError.DatabaseErrors.connectionError
                    }
                    // else unwrap the documents from the snapshot
                    else if let docs = snapshot?.documents {
                        
                        // There should only be one document with the user's email
                        if docs.count == 1, let doc = docs.first {
                            let data = doc.data()
                            
                            // Get the encrypted password from the document
                            if let pk = data["pk"] as? String {
                                
                                // The user is authenticated
                                if pk == encrypted {
                                    user = User.from(data).json
                                    authenticationResult = true
                                    
                                    // Set the lastLoginDate and add the current IP address to the user document
                                    if let userID = data["userID"] as? String {
                                        DispatchQueue.main.async {
                                            let reference: DocumentReference = FirebaseWrapper.userReference(userUUIDString: userID)
                                            var updates: [String:Any] = ["lastLoginDate" : Timestamp(date: Date()).seconds]
                                            if let ip = ipAddress {
                                                updates["ipAddresses"] = FieldValue.arrayUnion([ip])
                                            }
                                            reference.updateData(updates)
                                        }
                                    }
                                }
                                // The user entered incorrect info
                                else {
                                    print(pk)
                                    print(encrypted)
                                    var decrypted = try! pk.decrypt(key: key, iv: iv)
                                    print(decrypted)
                                    decrypted = try! encrypted.decrypt(key: key, iv: iv)
                                    print(decrypted)
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
        
        while( authenticationResult == nil ){
            usleep(1000)
        }
        return (error, authenticationResult, user)
    }
    
    
}
