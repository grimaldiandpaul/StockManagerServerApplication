//
//  FirebaseUpdateItem.swift
//  StockManagerServerApplication
//
//  Created by Zachary Grimaldi and Joseph Paul on 10/28/20.
//

import Foundation
import Firebase

/// An extension for our FirebaseWrapper class that contains the static function for getting all `code`s
extension FirebaseWrapper {
    
    class func getAllValidCodes(storeID: String) -> FirebaseWrapperGetCodesResult {
        #warning("check if store exists")
        let semaphore = DispatchSemaphore(value: 0)
        var codes = [[String:Any]]()
        
        var error: StockManagerError? = nil
            
        FirebaseWrapper.codesReference(storeID: storeID).getDocuments(completion: { (snapshot, err) in
            if let _ = err {
                error = StockManagerError.DatabaseErrors.connectionError
                semaphore.signal()
            }
            
            if let snapshot = snapshot {
                let docs = snapshot.documents
                for doc in docs {
                    let data = doc.data()
                    if let expiry = data["timeExpires"] as? Int, expiry > Timestamp(date: Date()).seconds {
                        codes.append(data)
                    }
                }
                semaphore.signal()
            }
        })
            
        let _ = semaphore.wait(wallTimeout: .distantFuture)
            
        return (error, codes)
            
    }
    
    
}
