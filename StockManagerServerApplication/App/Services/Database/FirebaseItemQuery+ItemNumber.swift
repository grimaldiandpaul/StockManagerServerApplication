//
//  FirebaseItemQuery+ItemNumber.swift
//  StockManagerServerApplication
//
//  Created by Zachary Grimaldi and Joseph Paul on 9/8/20.
//

import Foundation
import Firebase

/// An extension for our FirebaseWrapper singleton
extension FirebaseWrapper {
    
    /// A static function that synchronously authenticates a user email and password
    /// - Parameter email: the user's email
    /// - Parameter password: the user's password
    /// - Returns:FirebaseWrapperAuthenticationResult = (error: StockManagerError?, successful: Bool?, user: Data?)
    class func retrieveItem(_ userDesignatedID: String, storeID: String) -> FirebaseWrapperItemRetrieval {
       
        var error: StockManagerError? = nil
        var itemRetrievalResult: [String:Any]? = nil
        
        let semaphore = DispatchSemaphore(value: 0)
        
        // Get the user document from Firebase
        FirebaseWrapper.itemReference(userDesignatedID: userDesignatedID, storeID: storeID).getDocuments { (snapshot, snapshotErr) in
            
            // If there was an error, set the variables
            if let _ = snapshotErr {
                itemRetrievalResult = nil
                error = StockManagerError.DatabaseErrors.connectionError
                semaphore.signal()
            }
            // else unwrap the documents from the snapshot
            else if let docs = snapshot?.documents {
                if docs.count == 1, let doc = docs.first {
                    print("Got here 1")
                    let item = InventoryItem.from(doc.data())
                    if let validationError = DataValidation.validateFields(item: item).error {
                        itemRetrievalResult = nil
                        error = validationError
                        semaphore.signal()
                    } else {
                        itemRetrievalResult = item.json
                        error = nil
                        semaphore.signal()
                    }
                } else {
                    itemRetrievalResult = nil
                    error = StockManagerError.DatabaseErrors.noItemResultsFound
                    semaphore.signal()
                }
            } else {
                itemRetrievalResult = nil
                error = StockManagerError.DatabaseErrors.connectionError
                semaphore.signal()
            }
        }
        let _ = semaphore.wait(wallTimeout: .distantFuture)
        return (error, itemRetrievalResult)
    }
    
    
}

