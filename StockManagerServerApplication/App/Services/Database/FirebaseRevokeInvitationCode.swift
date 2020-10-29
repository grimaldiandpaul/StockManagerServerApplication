//
//  FirebaseCreateItem.swift
//  StockManagerServerApplication
//
//  Created By Zachary Grimaldi and Joseph Paul on 10/29/20.
//

import Foundation
import Firebase

/// An extension for our FirebaseWrapper class that contains the static function for revoking an invitation code
extension FirebaseWrapper {
    
    /// static function for REVOKING an invitation code
    /// - Parameter storeID: the unique identifier of the store to add the item to
    /// - Parameter companyID: the unique identifier of the company
    /// - Parameter code: the id of the code to revoke
    /// - Returns: A FirebaseWrapperCodeOperationResult (type-aliased from the tuple:  (error: String?, codeObject: [String:Any]) )
    class func revokeInvitationCode(storeID: String, companyID: String, code: String) -> FirebaseWrapperCodeOperationResult {
        #warning("check if store exists")
        let semaphore = DispatchSemaphore(value: 0)
        var codeObject = [String:Any]()
        
        var components = DateComponents()
        components.day = 30
        
        var error: StockManagerError? = nil
            
        // retrieve the item document from Firebase Cloud Firestore
        FirebaseWrapper.codeReference(code: code).getDocument(completion: { (doc, err) in
            if let _ = err {
                error = StockManagerError.DatabaseErrors.connectionError
                codeObject = [:]
                semaphore.signal()
            }
            if let doc = doc {
                if let data = doc.data() {
                    codeObject = data
                    codeObject["timeExpires"] = Timestamp(date: Date()).seconds
                    codeReference(code: code).updateData(codeObject)
                    semaphore.signal()
                } else {
                    print(doc.documentID)
                    print("no code found 1")
                    error = StockManagerError.DatabaseErrors.noCodeFound
                    semaphore.signal()
                }
            } else {
                error = StockManagerError.DatabaseErrors.noCodeFound
                print("no code found 2")
                semaphore.signal()
            }
        })
            
        // wait for the asynchronous Firebase retrieval and creation
        let _ = semaphore.wait(wallTimeout: .distantFuture)
        
        return (error, codeObject)
        
    }
        
    
    
}


