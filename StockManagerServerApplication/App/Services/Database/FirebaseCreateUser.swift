//
//  FirebaseCreateUser.swift
//  StockManagerServerApplication
//
//  Created by Zachary Grimaldi and Joseph Paul on 9/5/20.
//

import Foundation
import Firebase


extension FirebaseWrapper {
    
    /// A static function that synchronously authenticates a user email and password
    /// - Parameter email: the user's email
    /// - Parameter password: the user's password
    /// - Returns:FirebaseWrapperAuthenticationResult = (error: StockManagerError?, successful: Bool?, user: Data?)
    class func createUser(userInformation: [String:Any], ipAddress: String?) -> FirebaseWrapperUserCreationResult {
        
        var error: StockManagerError? = nil
        var creationResult: Bool? = nil
        var user: [String:Any]? = nil
        let semaphore = DispatchSemaphore(value: 0)
        
        #warning("this will need fixed on mac mini")
        let file = "/Users/joepauljoe/Downloads/keyandiv.txt"
        let path = URL(fileURLWithPath: file)
        
        // Get all necessary fields from the data sent by the user
        if let password = userInformation["password"] as? String, password.count > 0 {
            if let email = userInformation["email"] as? String, email.count > 0 {
                if let firstName = userInformation["firstName"] as? String, firstName.count > 0 {
                    if let lastName = userInformation["lastName"] as? String, lastName.count > 0 {
                        if let invitationCode = userInformation["invitationCode"] as? String, invitationCode.count > 0 {
                            
                            // Retrieve the companyID and storeID based on the invitation code
                            FirebaseWrapper.invitationCodeReference(invitationCode).getDocuments { (snapshot, snapshotError) in
                                if let _ = snapshotError {
                                    error = StockManagerError.DatabaseErrors.connectionError
                                    creationResult = false
                                    semaphore.signal()
                                } else if let docs = snapshot?.documents {
                                    if docs.count == 1, let doc = docs.first {
                                        let data = doc.data()
                                        if let storeID = data["storeID"] as? String, storeID.count > 0 {
                                            if let companyID = data["companyID"] as? String, companyID.count > 0 {
                                                if let expiry = data["timeExpires"] as? Int, expiry > Timestamp(date: Date()).seconds {
                                                
                                                // Check to see if the user already has an account
                                                    FirebaseWrapper.userReference(email: email).getDocuments { (snapshot, snapshotError) in
                                                        if let _ = error {
                                                            error = StockManagerError.DatabaseErrors.connectionError
                                                            creationResult = false
                                                            semaphore.signal()
                                                        } else {
                                                            // The account already exists
                                                            if (snapshot?.documents.count)! > 0 {
                                                                error = StockManagerError.AuthenticationErrors.accountAlreadyExists
                                                                creationResult = false
                                                                semaphore.signal()
                                                            } else {
                                                                
                                                                // Start creating the account
                                                                if var iv = try? String(contentsOf: path) {
                                                                    let key = String(iv.prefix(while: {$0 != "\n"}))
                                                                    while iv.contains("\n"){
                                                                        iv = String(iv.dropFirst())
                                                                    }
                                                                    
                                                                    // Encrypt the user's password for storage in database
                                                                    if let encrypted = try? password.encrypt(key: key, iv: iv) {
                                                                        
                                                                        // If there is an ipAddress, post the user's data to the firestore
                                                                        if let ip = ipAddress {
                                                                            let userID = UUID.uuidStringTwentyCharsNoDashes
                                                                            user = User(userID: userID, firstName: firstName, lastName: lastName, email: email, storeID: storeID, companyID: companyID, lastLoginDate: nil, ipAddresses: [ip], userRole: .user).json
                                                                            var firebaseJSON = User(userID: userID, firstName: firstName, lastName: lastName, email: email, storeID: storeID, companyID: companyID, lastLoginDate: nil, ipAddresses: [ip], userRole: .user).json
                                                                            firebaseJSON["pk"] = encrypted
                                                                            firebaseJSON["lastLoginDate"] = Timestamp(date: Date()).seconds
                                                                            
                                                                            FirebaseWrapper.userReference(userUUIDString: userID).setData(firebaseJSON) { (err) in
                                                                                if let _ = err {
                                                                                    error = StockManagerError.DatabaseErrors.connectionError
                                                                                    creationResult = false
                                                                                    semaphore.signal()
                                                                                } else {
                                                                                    creationResult = true
                                                                                    semaphore.signal()
                                                                                }
                                                                            }
                                                                        }
                                                                        // Still post the user's data to the firestore, but without ipAddress
                                                                        else {
                                                                            let userID = UUID.uuidStringTwentyCharsNoDashes
                                                                            user = User(userID: userID, firstName: firstName, lastName: lastName, email: email,storeID: storeID, companyID: companyID, lastLoginDate: nil, ipAddresses: [], userRole: .user).json
                                                                            var firebaseJSON = User(userID: userID, firstName: firstName, lastName: lastName, email: email, storeID: storeID, companyID: companyID, lastLoginDate: nil, ipAddresses: [], userRole: .user).json
                                                                            firebaseJSON["pk"] = encrypted
                                                                            firebaseJSON["lastLoginDate"] = Timestamp(date: Date()).seconds
                                                                                
                                                                            FirebaseWrapper.userReference(userUUIDString: userID).setData(firebaseJSON) { (err) in
                                                                                if let _ = err {
                                                                                    error = StockManagerError.DatabaseErrors.connectionError
                                                                                    creationResult = false
                                                                                    semaphore.signal()
                                                                                } else {
                                                                                    creationResult = true
                                                                                    semaphore.signal()
                                                                                }
                                                                            }
                                                                        }
                                                                    } else {
                                                                        error = StockManagerError.IOErrors.encryptionError
                                                                        creationResult = false
                                                                        semaphore.signal()
                                                                    }
                                                                } else {
                                                                    error = StockManagerError.IOErrors.retrievalError
                                                                    creationResult = false
                                                                    semaphore.signal()
                                                                }
                                                                
                                                                var updated : [String:Any] = [:]
                                                                updated["uses"] = FieldValue.increment(Int64(1))
                                                                codeReference(code: invitationCode).updateData(updated)
                                                            }
                                                        }
                                                    }
        
                                                } else {
                                                    error = StockManagerError.AuthenticationErrors.expiredCode
                                                    creationResult = false
                                                    semaphore.signal()
                                                }
                                            } else {
                                                error = StockManagerError.AuthenticationErrors.incompleteInvitationCode
                                                creationResult = false
                                                semaphore.signal()
                                            }
                                        } else {
                                            error = StockManagerError.AuthenticationErrors.incompleteInvitationCode
                                            creationResult = false
                                            semaphore.signal()
                                        }
                                    } else if docs.count == 0 {
                                        error = StockManagerError.DatabaseErrors.noInvitationCodeResultsFound
                                        creationResult = false
                                        semaphore.signal()
                                    } else if docs.count != 1 {
                                        error = StockManagerError.DatabaseErrors.internalDatabaseSyncError
                                        creationResult = false
                                        semaphore.signal()
                                    } else {
                                        error = StockManagerError.unreachableError
                                        creationResult = false
                                        semaphore.signal()
                                    }
                                } else {
                                    error = StockManagerError.DatabaseErrors.connectionError
                                    creationResult = false
                                    semaphore.signal()
                                }
                            }
                        } else {
                            error = StockManagerError.APIErrors.missingData
                            creationResult = false
                            semaphore.signal()
                        }
                        
                    } else {
                        error = StockManagerError.APIErrors.missingData
                        creationResult = false
                        semaphore.signal()
                    }
                } else {
                    error = StockManagerError.APIErrors.missingData
                    creationResult = false
                    semaphore.signal()
                }
            } else {
                error = StockManagerError.APIErrors.missingData
                creationResult = false
                semaphore.signal()
            }
        } else {
            error = StockManagerError.APIErrors.missingData
            creationResult = false
            semaphore.signal()
        }
        
        
        
        let _ = semaphore.wait(wallTimeout: .distantFuture)
        return (error, creationResult, user)
    }
}
