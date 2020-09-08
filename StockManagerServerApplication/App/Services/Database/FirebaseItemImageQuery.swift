//
//  FirebaseItemImageQuery.swift
//  StockManagerServerApplication
//
//  Created by Zachary Grimaldi on 9/8/20.
//

import Foundation
import Firebase

extension FirebaseWrapper {
    
    class func retrieveImage(itemUUID: String) -> FirebaseWrapperItemImageResult {
        var error: StockManagerError? = nil
        var image: Data? = nil
        let imageRef = Storage.storage().reference(withPath: "images/\(itemUUID).png")
        let _ = imageRef.getData(maxSize: 3000, completion: { (data, err) in
            if let err = err {
                LoggingManager.log(err.localizedDescription, source: .database, type: .error)
                error = StockManagerError.DatabaseErrors.noItemImageResultsFound
                image = nil
            } else if let data = data {
                error = nil
                image = data
            }
        })
        while( error == nil && image == nil ){
            usleep(1000)
        }
        return (error, image)
        
    }
    
}
