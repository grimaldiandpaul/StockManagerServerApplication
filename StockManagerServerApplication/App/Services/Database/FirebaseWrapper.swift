//
//  FirebaseWrapper.swift
//  StockManagerServerApplication
//
//  Created By Zachary Grimaldi and Joseph Paul on 8/10/20.
//

import Foundation
import Firebase
import Telegraph

/// A static class, acting as a singleton without mutable data members
class FirebaseWrapper {
    
    /// the root folder of the database service provided by Google Firebase Cloud Firestore
    static let root = Firestore.firestore()
    
    /// the authentication service provided by Google Firebase Authentication
    static let auth = Auth.auth()
    
    /// a type-alias for the return object of a FirebaseWrapper void function
    typealias FirebaseWrapperVoidResult = (error: StockManagerError?, successful: Bool)
    
    /// a type-alias for the return object of a FirebaseWrapper Authentication function
    typealias FirebaseWrapperAuthenticationResult = (error: StockManagerError?, successful: Bool?, user: [String:Any]?)
    
    /// a type-alias for the return object of a FirebaseWrapper Creation function
    typealias FirebaseWrapperCreationResult = (error: StockManagerError?, successful: Bool?, user: [String:Any]?)
    
    /// a type-alias for the return object of a FirebaseWrapper check number of accounts function
    typealias FirebaseWrapperAccountCheckResult = (error: StockManagerError?, numAccounts: Int?)
    
    /// This function is a re-usable function for the singleton that returns the `DocumentReference` for an `InventoryItem` given a store.
    /// - Parameter itemUUIDString: the unique identifier for the item
    /// - Parameter storeID: the unique identifier for the store
    /// - Returns: A `DocumentReference` to the `InventoryItem`.
    ///
    class func itemReference(_ itemUUIDString: String, storeID: String) -> DocumentReference {
        return FirebaseWrapper.root
            .collection("Stores")
            .document(storeID)
            .collection("ItemList")
            .document(itemUUIDString)
    }
    
    /// a re-usable function for the singleton that returns the database reference for a user given a `userID`
    /// This function is a re-usable function for the singleton that returns the `DocumentReference` for a `User` given the user's unique identifier.
    /// - Parameter userUUIDString: the unique identifier for the user
    /// - Returns: A `DocumentReference` to the `User`.
    ///
    class func userReference(userUUIDString: String) -> DocumentReference {
        return FirebaseWrapper.root
            .collection("UserList")
            .document(userUUIDString)
            
    }
    
    /// a re-usable function for the singleton that returns the query for a user given an email
    /// This function is a re-usable function for the singleton that returns the `Query` for `User`s given the user's email.
    /// - Parameter email: the email for the user
    /// - Returns: A `Query` to the `User` documents.
    ///
    class func userReference(email: String) -> Query {
        print("got here in user reference")
        return FirebaseWrapper.root
        .collection("UserList")
        .whereField("email", isEqualTo: email)
    }
    
    /// a re-usable function for the singleton that returns the query for an Invitation Code
    /// This function is a re-usable function for the singleton that returns the `Query` for an invitation code specified by the end user.
    /// - Parameter invitationCode: the user's invitation code
    /// - Returns: A `Query` to the invitation code documents.
    ///
    class func invitationCodeReference(_ invitationCode: String) -> Query {
        return FirebaseWrapper.root
        .collection("InvitationCodes")
        .whereField("code", isEqualTo: invitationCode)
    }
}
