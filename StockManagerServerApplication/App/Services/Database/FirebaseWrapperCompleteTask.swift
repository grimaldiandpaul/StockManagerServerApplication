//
//  FirebaseUpdateItem.swift
//  StockManagerServerApplication
//
//  Created by Zachary Grimaldi and Joseph Paul on 10/28/20.
//

import Foundation
import Firebase

/// An extension for our FirebaseWrapper class that contains the static function for creating an `InventoryItem`
extension FirebaseWrapper {
    
    /// static function for CREATING an `InventoryItem`
    /// - Parameter item: the `InventoryItem` object to create
    /// - Parameter storeID: the unique identifier of the store to add the item to
    /// - Returns: A FirebaseWrapperVoidResult (type-aliased from the tuple:  (error: String?, successful: Bool) )
    class func completeTask(storeID: String, taskID: String) -> FirebaseWrapperTaskOperationResult {
        #warning("check if store exists")
        let semaphore = DispatchSemaphore(value: 0)
        var taskJSON : [String:Any] = [:]
        
        var error: StockManagerError? = nil
            
        // check to see if the document exists
        FirebaseWrapper.taskReference(storeID: storeID, taskID: taskID).getDocument { (doc, err) in
            if (!(doc?.exists ?? false)) {
                error = StockManagerError.DatabaseErrors.noTaskResultsFound
                semaphore.signal()
            } else {
                // update the item document from Firebase Cloud Firestore
                if let doc = doc {
                    if let json = doc.data() {
                        taskJSON = json
                    }
                }
                taskJSON["timeCompleted"] = Timestamp(date: Date()).seconds
                FirebaseWrapper.taskReference(storeID: storeID, taskID: taskID).updateData(taskJSON)
                semaphore.signal()
            }
        }
            
        let _ = semaphore.wait(wallTimeout: .distantFuture)
            
        return (error,taskJSON)
            
    }
    
    
}

