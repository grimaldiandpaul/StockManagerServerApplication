//
//  FirebaseWrapper.swift
//  StockManagerServerApplication
//
//  Created by Zachary Grimaldi on 8/10/20.
//

import Foundation
import Firebase
import Telegraph

class FirebaseWrapper {
    
    static let root = Firestore.firestore()
    typealias FirebaseWrapperResult = (error: String?, successful: Bool)
    
    class func reference(_ itemUUIDString: String, store: String) -> DocumentReference {
        return FirebaseWrapper.root
            .collection("Clients")
            .document(store)
            .collection("ItemList")
            .document(itemUUIDString)
    }
    
    class func createItem(_ item: InventoryItem, store: String) -> FirebaseWrapperResult {
        #warning("check if store exists")
        let validationResult = DataValidation.validateFields(item: item)
        if let err = validationResult.error {
            print(err)
            return ("Item could not be created", false)
        } else {
            var error: String? = nil
            var result = false
            FirebaseWrapper.reference(item.id, store: store).getDocument { (documentSnapshot, err) in
                if let documentSnapshot = documentSnapshot, !documentSnapshot.exists {
                    if let json = item.json {
                        FirebaseWrapper.reference(item.id, store: store).setData(json) { (err) in
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
                        error = "Item could not be created because of an error in serialization for database storage."
                        //return (error, result)
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
    
    
//    class func updateItem(_ item: InventoryItem, store: String) -> FirebaseWrapperResult {
//        #warning("check if store exists")
//        DataValidation.validateFields(item: item) { (err, result) in
//            if let err = err {
//                print(err)
//                return ("Item could not be updated", false)
//            } else {
//                FirebaseWrapper.reference(item.id, store: store).getDocument { (documentSnapshot, err) in
//                    if let documentSnapshot = documentSnapshot, documentSnapshot.exists {
//                        if let json = item.json {
//                            FirebaseWrapper.reference(item.id, store: store).updateData(json) { (err) in
//                                if let err = err {
//                                    print(err)
//                                    return ("Item could not be updated due to an error with our database service.", false)
//                                } else {
//                                    return (nil, true)
//                                }
//                            }
//                        } else {
//                            return ("Item could not be updated because of an error in serialization for database storage.", false)
//                        }
//                    } else {
//                        return ("Item could not be updated because an item with this ID does not already exist.", false)
//                    }
//                }
//
//            }
//        }
//    }
//
//
//    class func deleteItem(_ item: InventoryItem, store: String) -> FirebaseWrapperResult {
//        #warning("check if store exists")
//        FirebaseWrapper.reference(item.id, store: store).getDocument { (documentSnapshot, err) in
//            if let documentSnapshot = documentSnapshot, documentSnapshot.exists {
//                FirebaseWrapper.reference(item.id, store: store).delete { (err) in
//                    if let err = err {
//                        print(err)
//                        return ("Item could not be deleted due to an error with our database service.", false)
//                    }
//                }
//            } else {
//                return ("Item could not be delete because an item with this ID does not exist.", false)
//            }
//        }
//
//    }
    
}
