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
    /// - Returns:FirebaseWrapperAuthenticationResult = (error: StockManagerError?, successful: Bool?, user: Data?)
    class func authenticateUser(email: String, password: String) -> FirebaseWrapperAuthenticationResult {
        
        var error: StockManagerError? = nil
        var authenticationResult: Bool? = nil
        var user: Data? = nil
        
        // utilize Firebase Authentication to ensure this is a correct email & password combination
        FirebaseWrapper.auth.signIn(withEmail: email, password: password) { (responseFromFirebaseAuth, err) in
            // if there was an error reaching the Firebase Auth endpoint
            if let _ = err {
                error = StockManagerError.AuthenticationErrors.connectionError
                authenticationResult = false
            } else {
                // if we can confirm we retrieve a response from Firebase Auth
                if let resultFromFirebaseAuth = responseFromFirebaseAuth {
                    
                    // find out if we retrieved the user document from Firebase Auth
                    authenticationResult = !resultFromFirebaseAuth.user.uid.isEmpty
                    if var authenticationResult = authenticationResult, authenticationResult {

                        // retrieve the user document from Firebase Cloud Firestore
                        FirebaseWrapper.userReference(resultFromFirebaseAuth.user.uid).getDocument { (documentSnapshot, err) in
                            
                            // if the document exists in our cloud database
                            if let documentSnapshot = documentSnapshot, documentSnapshot.exists {
                                
                                // if we can retrieve the JSON object from the document snapshot
                                if let data = documentSnapshot.data() {
                                    
                                    // decode the JSON data into a User object
                                    let userFromFirebase = User.from(data)
                                    
                                    // try to serialize the data to JSON
                                    if let userData = try? JSONSerialization.data(withJSONObject: userFromFirebase, options: .fragmentsAllowed) {
                                        user = userData
                                        authenticationResult = true
                                    } else {
                                        error = StockManagerError.JSONErrors.serializationError
                                        authenticationResult = false
                                    }
                                } else {
                                    error = StockManagerError.AuthenticationErrors.userNotFound
                                    authenticationResult = false
                                }
                            } else {
                                error = StockManagerError.AuthenticationErrors.userNotFound
                                authenticationResult = false
                            }
                        }
                        
                    } else {
                        error = StockManagerError.AuthenticationErrors.invalidCredentials
                        authenticationResult = false
                    }
                } else {
                    error = StockManagerError.AuthenticationErrors.connectionError
                    authenticationResult = false
                }
            }
        }
        
        /// thread sleeps while we wait for the asynchronous operations to return
        while (error == nil && authenticationResult == nil ||
                ((authenticationResult ?? false) && user == nil)) {
                    sleep(1)
        }
        
        /// return the result, available as soon as an error is thrown or the User object is ready to return
        return (error, authenticationResult, user)
    }
    
    
}
