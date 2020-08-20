//
//  FirebaseWrapper.swift
//  StockManagerServerApplication
//
//  Created By Zachary Grimaldi and Joseph Paul on 8/10/20.
//

import Foundation
import Firebase
import Telegraph

class FirebaseWrapper {
    
    /// the root folder of the database service provided by Google Firebase Cloud Firestore
    static let root = Firestore.firestore()
    
    /// the authentication service provided by Google Firebase Authentication
    static let auth = Auth.auth()
    
    /// a type-alias for the return object of a FirebaseWrapper void function
    typealias FirebaseWrapperVoidResult = (error: String?, successful: Bool)
    
    /// a type-alias for the return object of a FirebaseWrapper Authentication function
    typealias FirebaseWrapperAuthenticationResult = (error: String?, successful: Bool?, user: Data?)
    
    /// This function a re-usable function for the singleton that returns the `DocumentReference` for an `InventoryItem` given a store.
    /// - Parameter itemUUIDString: the unique identifier for the item
    /// - Parameter storeID: the unique identifier for the store
    /// - Returns: A `DocumentReference` to the `InventoryItem`.
    ///
    class func itemReference(_ itemUUIDString: String, storeID: String) -> DocumentReference {
        return FirebaseWrapper.root
            .collection("Clients")
            .document(storeID)
            .collection("ItemList")
            .document(itemUUIDString)
    }
    
    /// a re-usable function for the singleton that returns the database reference for an item given a store
    /// This function a re-usable function for the singleton that returns the `DocumentReference` for a `User` given the user's unique identifier.
    /// - Parameter userUUIDString: the unique identifier for the user
    /// - Returns: A `DocumentReference` to the `User`.
    ///
    class func userReference(_ userUUIDString: String) -> DocumentReference {
        return FirebaseWrapper.root
            .collection("UserList")
            .document(userUUIDString)
            
    }
}
