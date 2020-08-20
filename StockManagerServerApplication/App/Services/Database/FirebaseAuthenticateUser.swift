//
//  FirebaseAuthenticateUser.swift
//  StockManagerServerApplication
//
//  Created By Zachary Grimaldi and Joseph Paul on 8/18/20.
//

import Foundation
import Firebase

extension FirebaseWrapper {
    
    
    class func authenticateUser(username: String, password: String) -> FirebaseWrapperAuthenticationResult {
        var error: String? = nil
        var result: Bool? = nil
        var user: Data? = nil
        FirebaseWrapper.auth.signIn(withEmail: username, password: password) { (resultFromFirebaseAuth, err) in
            if let _ = err {
                error = "User authentication could not be processed"
                result = false
            } else {
                if let resultFromFirebaseAuth = resultFromFirebaseAuth {
                    result = !resultFromFirebaseAuth.user.uid.isEmpty
                    if var result = result, result {

                        FirebaseWrapper.userReference(resultFromFirebaseAuth.user.uid).getDocument { (documentSnapshot, err) in
                            if let documentSnapshot = documentSnapshot, !documentSnapshot.exists {
                                if let data = documentSnapshot.data() {
                                    let userFromFirebase = User.from(data)
                                    if let userData = try? JSONSerialization.data(withJSONObject: userFromFirebase, options: .fragmentsAllowed) {
                                        user = userData
                                        result = true
                                    }
                                } else {
                                    error = "User could not be found"
                                    result = false
                                }
                            } else {
                                result = false
                                error = "Item could not be created because an item with this ID already exists."
                            }
                        }
                    }
                } else {
                    result = false
                    error = "User authentication could not be processed"
                }
            }
        }
        
        while (error == nil && result == nil ||
                ((result ?? false) && user == nil)) {
                    sleep(1)
        }
        
        return (error, result, user)
    }
    
    
}
