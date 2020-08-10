//
//  FirebaseWrapper.swift
//  StockManagerServerApplication
//
//  Created by Zachary Gimaldi on 8/10/20.
//

import Foundation
import FirebaseFirestore

class FirebaseWrapper {
    
    static let root = Firestore.firestore()
    
    class func reference(_ itemUUIDString: String, store: String) -> DocumentReference {
        return FirebaseWrapper.root
            .collection("Clients")
            .document(store)
            .collection("ItemList")
            .document(itemUUIDString)
    }
    
}
