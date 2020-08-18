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
    private static let auth = Auth.auth()
    typealias FirebaseWrapperVoidResult = (error: String?, successful: Bool)
    typealias FirebaseWrapperAuthenticationResult = (error: String?, successful: Bool?, user: Data?)
    
    class func itemReference(_ itemUUIDString: String, store: String) -> DocumentReference {
        return FirebaseWrapper.root
            .collection("Clients")
            .document(store)
            .collection("ItemList")
            .document(itemUUIDString)
    }
    
    class func userReference(_ userUIDString: String) -> DocumentReference {
        return FirebaseWrapper.root
            .collection("UserList")
            .document(userUIDString)
            
    }
    
    class func createItem(_ item: InventoryItem, store: String) -> FirebaseWrapperVoidResult {
        #warning("check if store exists")
        let validationResult = DataValidation.validateFields(item: item)
        if let err = validationResult.error {
            print(err)
            return ("Item could not be created", false)
        } else {
            var error: String? = nil
            var result = false
            FirebaseWrapper.itemReference(item.id, store: store).getDocument { (documentSnapshot, err) in
                if let documentSnapshot = documentSnapshot, !documentSnapshot.exists {
                    let json = item.firebasejson
                    FirebaseWrapper.itemReference(item.id, store: store).setData(json) { (err) in
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
    
    class func authenticateUser(username: String, password: String) -> FirebaseWrapperAuthenticationResult {
        var error: String? = nil
        var result: Bool? = nil
        var user: Data? = nil
        auth.signIn(withEmail: username, password: password) { (resultFromFirebaseAuth, err) in
            if let _ = err {
                error = "User authentication could not be processed"
                result = false
            } else {
                if let resultFromFirebaseAuth = resultFromFirebaseAuth {
                    result = !resultFromFirebaseAuth.user.uid.isEmpty
                    if var result = result, result {

                        FirebaseWrapper.userReference(resultFromFirebaseAuth.user.uid).getDocument { (documentSnapshot, err) in
                            if let documentSnapshot = documentSnapshot, !documentSnapshot.exists {
                                if let data = documentSnapshot.data() {
                                    let userFromFirebase = User.from(data)
                                    if let userData = try? JSONSerialization.data(withJSONObject: userFromFirebase, options: .fragmentsAllowed) {
                                        user = userData
                                        result = true
                                    }
                                } else {
                                    error = "User could not be found"
                                    result = false
                                }
                            } else {
                                result = false
                                error = "Item could not be created because an item with this ID already exists."
                            }
                        }
                    }
                } else {
                    result = false
                    error = "User authentication could not be processed"
                }
            }
        }
        
        while (error == nil && result == nil ||
                ((result ?? false) && user == nil)) {
                    sleep(1)
        }
        
        return (error, result, user)
    }
    
}
