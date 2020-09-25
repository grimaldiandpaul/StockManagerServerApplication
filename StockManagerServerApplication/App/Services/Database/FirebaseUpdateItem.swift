//
//  FirebaseUpdateItem.swift
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
    class func updateItem(_ item: InventoryItem, storeID: String) -> FirebaseWrapperItemRetrieval {
        #warning("check if store exists")
        let validationResult = DataValidation.validateFields(item: item)
        let semaphore = DispatchSemaphore(value: 0)
        let itemJSON = item.json
        
        // if there is an error, return
        if let err = validationResult.error {
            semaphore.signal()
            return (err, nil)
        } else {
            var error: StockManagerError? = nil
            
            // check to see if the document exists
            FirebaseWrapper.itemReference(itemUUIDString: item.id, storeID: storeID).getDocument { (snapshot, err) in
                if (!(snapshot?.exists ?? false)) {
                    error = StockManagerError.DatabaseErrors.noItemResultsFound
                    semaphore.signal()
                } else {
                    // update the item document from Firebase Cloud Firestore
                    FirebaseWrapper.itemReference(itemUUIDString: item.id, storeID: storeID).updateData(itemJSON)
                    semaphore.signal()
                }
            }
            
            let _ = semaphore.wait(wallTimeout: .distantFuture)
            
            return (error,itemJSON)
            
        }
        
    }
    
    
}
