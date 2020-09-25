//
//  FirebaseCreateItem.swift
//  StockManagerServerApplication
//
//  Created By Zachary Grimaldi and Joseph Paul on 8/18/20.
//

import Foundation
import Firebase

/// An extension for our FirebaseWrapper class that contains the static function for creating an `InventoryItem`
extension FirebaseWrapper {
    
    /// static function for CREATING an `InventoryItem`
    /// - Parameter item: the `InventoryItem` object to create
    /// - Parameter storeID: the unique identifier of the store to add the item to
    /// - Returns: A FirebaseWrapperVoidResult (type-aliased from the tuple:  (error: String?, successful: Bool) )
    class func createItem(_ item: InventoryItem, storeID: String) -> FirebaseWrapperItemRetrieval {
        #warning("check if store exists")
        let validationResult = DataValidation.validateFields(item: item)
        let semaphore = DispatchSemaphore(value: 0)
        var returnedItem : [String:Any] = [:]
        
        // if there is an error, return
        if let err = validationResult.error {
            semaphore.signal()
            return (err, nil)
        } else {
            var error: StockManagerError? = nil
            
            // retrieve the item document from Firebase Cloud Firestore
            FirebaseWrapper.itemReference(itemUUIDString: item.id, storeID: storeID).getDocument { (documentSnapshot, err) in
                
                // if the document doesn't exist, create it below
                if let documentSnapshot = documentSnapshot, !documentSnapshot.exists {
                    let json = item.json
                    
                    // set the data in the Firebase Cloud Firestore document
                    FirebaseWrapper.itemReference(itemUUIDString: item.id, storeID: storeID).setData(json) { (err) in
                        if let err = err {
                            print(err)
                            error = StockManagerError.DatabaseErrors.connectionError
                            semaphore.signal()
                        } else {
                            returnedItem = item.json
                            semaphore.signal()
                        }
                    }
                } else {
                    error = StockManagerError.DatabaseErrors.nonUniqueIdentifier
                    semaphore.signal()
                }
            }
            
            // wait for the asynchronous Firebase retrieval and creation
            let _ = semaphore.wait(wallTimeout: .distantFuture)
            
            return (error,returnedItem)
            
        }
        
    }
    
    
}
