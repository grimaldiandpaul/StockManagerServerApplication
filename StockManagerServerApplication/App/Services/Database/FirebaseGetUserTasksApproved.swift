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
    class func getUserTasksApproved(storeID: String, userID: String) -> FirebaseWrapperGetTasksResult {
        #warning("check if store exists")
        let semaphore = DispatchSemaphore(value: 0)
        var tasks : [[String:Any]] = [[:]]
        
        var error: StockManagerError? = nil
            
        // check to see if the document exists
        FirebaseWrapper.tasksReference(storeID: storeID, userID: userID).getDocuments(completion: { (snapshot, err) in
            if let _ = err {
                error = StockManagerError.DatabaseErrors.connectionError
                semaphore.signal()
            }
            
            if let snapshot = snapshot {
                let docs = snapshot.documents
                for doc in docs {
                    let data = doc.data()
                    if let _ = data["timeApproved"] as? Int {
                        tasks.append(data)
                    }
                }
                semaphore.signal()
            }
        })
            
        let _ = semaphore.wait(wallTimeout: .distantFuture)
            
        return (error,tasks)
            
    }
    
    
}
