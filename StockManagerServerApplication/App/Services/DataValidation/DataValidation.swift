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
    
    class func validateFields(item: InventoryItem, completion: @escaping DataValidationResult) {
        
        if item.id == "" {
            completion("ID field cannot be empty", false)
        } else {
            completion(nil, true)
        }
    }
}
