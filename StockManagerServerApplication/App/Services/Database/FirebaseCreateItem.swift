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
    class func createItem(_ item: InventoryItem, storeID: String) -> FirebaseWrapperVoidResult {
        #warning("check if store exists")
        let validationResult = DataValidation.validateFields(item: item)
        if let err = validationResult.error {
            print(err)
            return ("Item could not be created", false)
        } else {
            var error: String? = nil
            var result = false
            FirebaseWrapper.itemReference(item.id, storeID: storeID).getDocument { (documentSnapshot, err) in
                if let documentSnapshot = documentSnapshot, !documentSnapshot.exists {
                    let json = item.firebasejson
                    FirebaseWrapper.itemReference(item.id, storeID: storeID).setData(json) { (err) in
                        if let err = err {
                            print(err)
                            error = "Item could not be created due to an error with our database service."
                            //return (error,result)
                        } else {
                            result = true
                            //return (error, result)
                        }
                    }
                } else {
                    error = "Item could not be created because an item with this ID already exists."
                    //return (error, result)
                }
            }
            
            while ( error == nil && !result ) {
                sleep(1)
            }
            
            return (error,result)
            
        }
        
    }
    
    
}
