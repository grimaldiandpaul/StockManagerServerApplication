//
//  FirebaseItemQuery+ItemNumber.swift
//  StockManagerServerApplication
//
//  Created by Zachary Grimaldi on 9/8/20.
//

import Foundation
import Firebase

/// An extension for our FirebaseWrapper singleton
extension FirebaseWrapper {
    
    /// A static function that synchronously authenticates a user email and password
    /// - Parameter email: the user's email
    /// - Parameter password: the user's password
    /// - Returns:FirebaseWrapperAuthenticationResult = (error: StockManagerError?, successful: Bool?, user: Data?)
    class func retrieveItem(_ itemUUIDString: String, storeID: String) -> FirebaseWrapperItemRetrieval {
        
        var error: StockManagerError? = nil
        var itemRetrievalResult: InventoryItem? = nil
        
        // Get the user document from Firebase
        FirebaseWrapper.itemReference(itemUUIDString, storeID: storeID).getDocument { (snapshot, snapshotErr) in
            
            // If there was an error, set the variables
            if let _ = snapshotErr {
                itemRetrievalResult = nil
                error = StockManagerError.DatabaseErrors.connectionError
            }
            // else unwrap the documents from the snapshot
            else if let data = snapshot?.data() {
                let item = InventoryItem.from(data)
                if let validationError = DataValidation.validateFields(item: item).error {
                    itemRetrievalResult = nil
                    error = validationError
                } else {
                    itemRetrievalResult = item
                    error = nil
                }
            } else {
                itemRetrievalResult = nil
                error = StockManagerError.DatabaseErrors.connectionError
            }
        }
        while( error == nil && itemRetrievalResult == nil ){
            usleep(1000)
        }
        return (error, itemRetrievalResult)
    }
    
    
}

