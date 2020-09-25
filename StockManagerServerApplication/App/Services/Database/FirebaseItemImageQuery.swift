//
//  FirebaseItemImageQuery.swift
//  StockManagerServerApplication
//
//  Created by Zachary Grimaldi and Joseph Paul on 9/8/20.
//

import Foundation
import Firebase

extension FirebaseWrapper {
    
    class func retrieveImage(itemUUID: String) -> FirebaseWrapperItemImageResult {
        var error: StockManagerError? = nil
        var image: Data? = nil
        let semaphore = DispatchSemaphore(value: 0)
        let imageRef = Storage.storage().reference(withPath: "images/\(itemUUID).png")
        let _ = imageRef.getData(maxSize: 3000 * 1000, completion: { (data, err) in
            if let err = err {
                LoggingManager.log(err.localizedDescription, source: .database, type: .error)
                error = StockManagerError.DatabaseErrors.noItemImageResultsFound
                image = nil
                semaphore.signal()
            } else if let data = data {
                error = nil
                image = data
                semaphore.signal()
            }
        })
        let _ = semaphore.wait(wallTimeout: .distantFuture)
        return (error, image)
        
    }
    
}
