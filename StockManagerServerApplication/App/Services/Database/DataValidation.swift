//
//  DataValidation.swift
//  StockManagerServerApplication
//
//  Created by Joe Paul on 8/10/20.
//

import Foundation

class DataValidation {
    
    static let main = DataValidation()
    typealias DataValidationResult = (String?, Bool) -> ()
    
    class func validateFields(object: [String:Any], completion: @escaping DataValidationResult) {
        
        if let id = object["id"] as? String {
            if id == "" {
                completion("ID field cannot be empty", false)
            } else {
                completion(nil, true)
            }
        } else {
            completion("Could not parse ID field", false)
        }
    }
}
