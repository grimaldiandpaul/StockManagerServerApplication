//
//  FirebaseWrapper.swift
//  StockManagerServerApplication
//
//  Created By Zachary Grimaldi and Joseph Paul on 8/10/20.
//

import Foundation
import Firebase

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
    typealias FirebaseWrapperUserCreationResult = (error: StockManagerError?, successful: Bool?, user: [String:Any]?)
    
    /// a type-alias for the return object of a FirebaseWrapper check number of accounts function
    typealias FirebaseWrapperAccountCheckResult = (error: StockManagerError?, numAccounts: Int?)
    
    typealias FirebaseWrapperItemRetrieval = (error: StockManagerError?, item: [String:Any]?)
    
    typealias FirebaseWrapperItemsRetrieval = (error: StockManagerError?, items: [[String:Any]]?)
    
    typealias FirebaseWrapperItemImageResult = (error: StockManagerError?, image: Data?)
    
    typealias FirebaseWrapperItemImageURLResult = (error: StockManagerError?, url: String?)
    
    typealias FirebaseWrapperTaskOperationResult = (error: StockManagerError?, task: [String:Any])
    
    typealias FirebaseWrapperGetUsersResult = (error: StockManagerError?, users: [[String:Any]])
    
    typealias FirebaseWrapperGetTasksResult = (error: StockManagerError?, tasks: [[String:Any]])
    
    
    /// This function is a re-usable function for the singleton that returns the `DocumentReference` for an `InventoryItem` given a store.
    /// - Parameter storeID: the unique identifier for the store
    /// - Returns: A `CollectionReference` to the list of `InventoryItem`'s.
    ///
    class func itemsReference(storeID: String) -> CollectionReference {
        return FirebaseWrapper.root
            .collection("Stores")
            .document(storeID)
            .collection("ItemList")
    }
    
    /// This function is a re-usable function for the singleton that returns the `DocumentReference` for a task given a store.
    /// - Parameter storeID: the unique identifier for the store
    /// - Parameter taskID: the unique identifier for the task
    /// - Returns: A `DocumentReference` to the task
    ///
    class func taskReference(storeID: String, taskID: String) -> DocumentReference {
        return FirebaseWrapper.root
            .collection("Stores")
            .document(storeID)
            .collection("Tasks")
            .document(taskID)
    }
    
    /// This function is a re-usable function for the singleton that returns the `Query` for tasks given a store and user.
    /// - Parameter storeID: the unique identifier for the store
    /// - Parameter userID: the unique identifier for the user
    /// - Returns: A `Query` of the tasks
    ///
    class func tasksReference(storeID: String, userID: String) -> Query {
        return FirebaseWrapper.root
            .collection("Stores")
            .document(storeID)
            .collection("Tasks")
            .whereField("userID", isEqualTo: userID)
    }
    
    /// This function is a re-usable function for the singleton that returns the `Query` for `User`s given a store.
    /// - Parameter storeID: the unique identifier for the store
    /// - Returns: A `Query` to the list of `User`s
    ///
    class func usersReference(storeID: String) -> Query {
        return FirebaseWrapper.root
            .collection("UserList")
            .whereField("storeID", isEqualTo: storeID)
    }
    
    
    /// This function is a re-usable function for the singleton that returns the `DocumentReference` for an `InventoryItem` given a store.
    /// - Parameter itemUUIDString: the unique identifier for the item
    /// - Parameter storeID: the unique identifier for the store
    /// - Returns: A `DocumentReference` to the `InventoryItem`.
    ///
    class func itemReference(itemUUIDString: String, storeID: String) -> DocumentReference {
        return FirebaseWrapper.root
            .collection("Stores")
            .document(storeID)
            .collection("ItemList")
            .document(itemUUIDString)
    }
    
    /// This function is a re-usable function for the singleton that returns the `Query` for an `InventoryItem` given a store.
    /// - Parameter id: the customer designated id for the `InventoryItem`
    /// - Parameter storeID: the unique identifier for the store
    /// - Returns: A `DocumentReference` to the `InventoryItem`.
    ///
    class func itemReference(userDesignatedID: String, storeID: String) -> Query {
        return FirebaseWrapper.root
            .collection("Stores")
            .document(storeID)
            .collection("ItemList")
            .whereField("userDesignatedID", isEqualTo: userDesignatedID)
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
