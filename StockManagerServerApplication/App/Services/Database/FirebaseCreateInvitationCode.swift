//
//  FirebaseCreateItem.swift
//  StockManagerServerApplication
//
//  Created By Zachary Grimaldi and Joseph Paul on 10/29/20.
//

import Foundation
import Firebase

/// An extension for our FirebaseWrapper class that contains the static function for creating an invitation code
extension FirebaseWrapper {
    
    /// static function for CREATING an invitation code
    /// - Parameter storeID: the unique identifier of the store to add the item to
    /// - Parameter companyID: the unique identifier of the company
    /// - Returns: A FirebaseWrapperVoidResult (type-aliased from the tuple:  (error: String?, successful: Bool) )
    class func createInvitationCode(storeID: String, companyID: String) -> FirebaseWrapperCodeOperationResult {
        #warning("check if store exists")
        let semaphore = DispatchSemaphore(value: 0)
        var codeObject = [String:Any]()
        let code = UUID.uuidStringTwentyCharsNoDashes.suffix(8).uppercased()
        
        var components = DateComponents()
        components.day = 30
        
        var error: StockManagerError? = nil
        
        codeObject["storeID"] = storeID
        codeObject["companyID"] = companyID
        codeObject["code"] = code
        codeObject["uses"] = 0
        codeObject["timeCreated"] = Timestamp(date: Date()).seconds
        codeObject["timeExpires"] = Timestamp(date: Calendar.current.date(byAdding: components, to: Date())!).seconds
            
        // set the data of the item document from Firebase Cloud Firestore
        FirebaseWrapper.codeReference(code: code).setData(codeObject) { (err) in
                
            if let _ = err {
                error = StockManagerError.DatabaseErrors.connectionError
                codeObject = [:]
                semaphore.signal()
            }
            semaphore.signal()
        }
            
        // wait for the asynchronous Firebase retrieval and creation
        let _ = semaphore.wait(wallTimeout: .distantFuture)
        
        return (error, codeObject)
        
    }
        
    
    
}


