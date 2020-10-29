//
//  FirebaseCreateItem.swift
//  StockManagerServerApplication
//
//  Created By Zachary Grimaldi and Joseph Paul on 10/28/20.
//

import Foundation
import Firebase

/// An extension for our FirebaseWrapper class that contains the static function for creating a task
extension FirebaseWrapper {
    
    /// static function for CREATING an task
    /// - Parameter storeID: the unique identifier of the store to add the item to
    /// - Parameter employeeID: the unique identifier of the employee
    /// - Parameter src: a dictionary of the source location
    /// - Parameter dest: a dictionary of the destination location
    /// - Parameter userDesignatedID: the unique identifier of the item to move
    /// - Returns: A FirebaseWrapperVoidResult (type-aliased from the tuple:  (error: String?, successful: Bool) )
    class func createTask(storeID: String, employeeID: String, src: [String:Any], dest: [String:Any], userDesignatedID: String) -> FirebaseWrapperTaskOperationResult {
        #warning("check if store exists")
        let semaphore = DispatchSemaphore(value: 0)
        var returnedTask : [String:Any] = [:]
        
        var error: StockManagerError? = nil
        
        let taskID = UUID.uuidStringTwentyCharsNoDashes
        returnedTask["assignedEmployeeID"] = employeeID
        returnedTask["src"] = src
        returnedTask["dest"] = dest
        returnedTask["userDesignatedID"] = userDesignatedID
        returnedTask["timeAssigned"] = Timestamp(date: Date()).seconds
        returnedTask["id"] = taskID
            
        // retrieve the item document from Firebase Cloud Firestore
        FirebaseWrapper.taskReference(storeID: storeID, taskID: taskID).setData(returnedTask) { (err) in
                
            // if the document doesn't exist, create it below
            if let _ = err {
                error = StockManagerError.DatabaseErrors.connectionError
                returnedTask = [:]
                semaphore.signal()
            }
            semaphore.signal()
        }
            
        // wait for the asynchronous Firebase retrieval and creation
        let _ = semaphore.wait(wallTimeout: .distantFuture)
        
        print("RETURNEDTASSK")
        print(returnedTask)
        
        return (error,returnedTask)
        
    }
        
    
    
}
