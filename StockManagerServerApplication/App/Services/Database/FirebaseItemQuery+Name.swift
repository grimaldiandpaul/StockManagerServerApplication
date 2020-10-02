//
//  FirebaseItemQuery+Name.swift
//  StockManagerServerApplication
//
//  Created by Zachary Grimaldi on 10/1/20.
//

import Foundation
import Firebase

/// An extension for our FirebaseWrapper singleton
extension FirebaseWrapper {
    
    /// A static function that synchronously authenticates a user email and password
    /// - Parameter email: the user's email
    /// - Parameter password: the user's password
    /// - Returns:FirebaseWrapperAuthenticationResult = (error: StockManagerError?, successful: Bool?, user: Data?)
    class func retrieveItems(_ name: String, storeID: String) -> FirebaseWrapperItemsRetrieval {
       
        var error: StockManagerError? = nil
        var itemRetrievalResult: [[String:Any]]? = nil
        
        let semaphore = DispatchSemaphore(value: 0)
        
        // Get the user document from Firebase
        FirebaseWrapper.itemsReference(storeID: storeID).whereField("name", isEqualTo: name).getDocuments { (snapshot, snapshotErr) in
            
            // If there was an error, set the variables
            if let _ = snapshotErr {
                itemRetrievalResult = nil
                error = StockManagerError.DatabaseErrors.connectionError
                semaphore.signal()
            }
            // else unwrap the documents from the snapshot
            else if let docs = snapshot?.documents {
                itemRetrievalResult = docs.map({InventoryItem.from($0.data()).json})
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
