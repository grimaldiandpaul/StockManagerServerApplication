//
//  FirebaseUpdateItem.swift
//  StockManagerServerApplication
//
//  Created by Zachary Grimaldi and Joseph Paul on 10/28/20.
//

import Foundation
import Firebase

/// An extension for our FirebaseWrapper class that contains the static function for getting all `user`s
extension FirebaseWrapper {
    
    /// static function for retrieving all users from the store
    /// - Parameter storeID: the unique identifier of the store to retrieve users
    /// - Returns: A FirebaseWrapperTaskOperationResult (type-aliased from the tuple:  (error: String?, task: [String:Any]) )
    class func getAllUsers(storeID: String) -> FirebaseWrapperGetUsersResult {
        #warning("check if store exists")
        let semaphore = DispatchSemaphore(value: 0)
        var users = [[String:Any]]()
        
        var error: StockManagerError? = nil
            
        // get the users documents
        FirebaseWrapper.usersReference(storeID: storeID).getDocuments(completion: { (snapshot, err) in
            if let _ = err {
                error = StockManagerError.DatabaseErrors.connectionError
                semaphore.signal()
            }
            
            if let snapshot = snapshot {
                let docs = snapshot.documents
                for doc in docs {
                    let data = doc.data()
                    if let fname = data["firstName"] as? String {
                        if let lname = data["lastName"] as? String {
                            if let id = data["userID"] as? String {
                                var userJSON : [String:Any] = [:]
                                userJSON["name"] = fname + " " + lname + " " + id.suffix(4).uppercased()
                                userJSON["id"] = id
                                users.append(userJSON)
                            }
                        }
                    }
                }
                semaphore.signal()
            }
        })
            
        let _ = semaphore.wait(wallTimeout: .distantFuture)
            
        return (error,users)
            
    }
    
    
}
