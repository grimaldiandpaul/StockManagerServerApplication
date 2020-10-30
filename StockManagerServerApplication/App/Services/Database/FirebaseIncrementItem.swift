//
//  FirebaseIncrementItem.swift
//  StockManagerServerApplication
//
//  Created by Zachary Grimaldi and Joseph Paul on 9/25/20.
//

import Foundation
import Firebase

/// An extension for our FirebaseWrapper class that contains the static function for creating an `InventoryItem`
extension FirebaseWrapper {
    
    /// static function for CREATING an `InventoryItem`
    /// - Parameter item: the `InventoryItem` object to create
    /// - Parameter storeID: the unique identifier of the store to add the item to
    /// - Returns: A FirebaseWrapperVoidResult (type-aliased from the tuple:  (error: String?, successful: Bool) )
    class func incrementItem(_ itemID: String, value: Int, type: String, storeID: String) -> FirebaseWrapperVoidResult {
        #warning("check if store exists")
        let semaphore = DispatchSemaphore(value: 0)
       
        var error: StockManagerError? = nil
        var result = false
            
        // retrieve the item document from Firebase Cloud Firestore
        if type == "backstockQuantity" {
            print("backstock upd")
            
            // query based on the userDesignatedID
            FirebaseWrapper.itemReference(userDesignatedID: itemID, storeID: storeID).getDocuments(completion: { (snapshot, err) in
                // get the first (and only) document
                if let doc = snapshot?.documents.first {
                    //obtain the documentID of the item
                    let uuid = doc.documentID
                    // update the document
                    FirebaseWrapper.itemReference(itemUUIDString: uuid, storeID: storeID).updateData(["backstockQuantity" : FieldValue.increment(Double(value))]) { (err) in
                        // if there is an error, set the error
                        if let _ = err {
                            result = false;
                            error = StockManagerError.DatabaseErrors.connectionError
                            semaphore.signal()
                        } else {
                            result = true
                            semaphore.signal()
                        }
                    }
                } else {
                    result = false
                    error = StockManagerError.DatabaseErrors.noItemResultsFound
                    semaphore.signal()
                }
            })
            
            
            
        } else if type == "customerAccessibleQuantity" {
            // query based on the userDesignatedID
            FirebaseWrapper.itemReference(userDesignatedID: itemID, storeID: storeID).getDocuments(completion: { (snapshot, err) in
                // get the first (and only) document
                if let doc = snapshot?.documents.first {
                    //obtain the documentID of the item
                    let uuid = doc.documentID
                    // update the document
                    FirebaseWrapper.itemReference(itemUUIDString: uuid, storeID: storeID).updateData(["customerAccessibleQuantity" : FieldValue.increment(Double(value))]) { (err) in
                        // if there is an error, set the error
                        if let _ = err {
                            result = false;
                            error = StockManagerError.DatabaseErrors.connectionError
                            semaphore.signal()
                        } else {
                            result = true
                            semaphore.signal()
                        }
                    }
                } else {
                    result = false
                    error = StockManagerError.DatabaseErrors.noItemResultsFound
                    semaphore.signal()
                }
            })
        } else {
            result = false
            error = StockManagerError.DatabaseErrors.badItemData
            semaphore.signal()
        }
            
        // wait for the asynchronous Firebase retrieval and creation
        let _ = semaphore.wait(wallTimeout: .distantFuture)
            
        return (error,result)
         
        
    }
    
    
}

