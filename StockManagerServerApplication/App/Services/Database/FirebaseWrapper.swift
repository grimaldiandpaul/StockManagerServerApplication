//
//  FirebaseWrapper.swift
//  StockManagerServerApplication
//
//  Created by Zachary Grimaldi on 8/10/20.
//

import Foundation
import FirebaseFirestore
import StockManagerDotTechModels

class FirebaseWrapper {
    
    static let root = Firestore.firestore()
    typealias FirebaseWrapperResult = (String?, Bool) -> ()
    
    class func reference(_ itemUUIDString: String, store: String) -> DocumentReference {
        return FirebaseWrapper.root
            .collection("Clients")
            .document(store)
            .collection("ItemList")
            .document(itemUUIDString)
    }
    
    class func createItem(_ object: [String:Any], store: String, completion: @escaping FirebaseWrapperResult) {
        
        DataValidation.validateFields(object: object) { (err, result) in
            if let err = err {
                print(err)
                completion("Item could not be created", false)
            } else {
                FirebaseWrapper.
            }
        }
    }
    
}
