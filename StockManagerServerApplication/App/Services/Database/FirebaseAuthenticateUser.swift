//
//  FirebaseAuthenticateUser.swift
//  StockManagerServerApplication
//
//  Created By Zachary Grimaldi and Joseph Paul on 8/18/20.
//

import Foundation
import Firebase

extension FirebaseWrapper {
    
    
    class func authenticateUser(email: String, password: String) -> FirebaseWrapperAuthenticationResult {
        var error: StockManagerError? = nil
        var authenticationResult: Bool? = nil
        var user: Data? = nil
        FirebaseWrapper.auth.signIn(withEmail: email, password: password) { (responseFromFirebaseAuth, err) in
            if let _ = err {
                error = StockManagerError.AuthenticationErrors.connectionError
                authenticationResult = false
            } else {
                if let resultFromFirebaseAuth = responseFromFirebaseAuth {
                    authenticationResult = !resultFromFirebaseAuth.user.uid.isEmpty
                    if var authenticationResult = authenticationResult, authenticationResult {

                        FirebaseWrapper.userReference(resultFromFirebaseAuth.user.uid).getDocument { (documentSnapshot, err) in
                            if let documentSnapshot = documentSnapshot, documentSnapshot.exists {
                                if let data = documentSnapshot.data() {
                                    let userFromFirebase = User.from(data)
                                    if let userData = try? JSONSerialization.data(withJSONObject: userFromFirebase, options: .fragmentsAllowed) {
                                        user = userData
                                        authenticationResult = true
                                    }
                                } else {
                                    error = StockManagerError.AuthenticationErrors.userNotFound
                                    authenticationResult = false
                                }
                            } else {
                                authenticationResult = false
                                error = StockManagerError.AuthenticationErrors.userNotFound
                            }
                        }
                    }
                } else {
                    authenticationResult = false
                    error = StockManagerError.AuthenticationErrors.connectionError
                }
            }
        }
        
        while (error == nil && authenticationResult == nil ||
                ((authenticationResult ?? false) && user == nil)) {
                    sleep(1)
        }
        
        return (error, authenticationResult, user)
    }
    
    
}
