//
//  UserExtensions.swift
//  StockManagerServerApplication
//
//  Created by Joe Paul on 8/17/20.
//

import Foundation
import Firebase

extension User {
    
    static func from(_ object: [String:Any]) -> User {
        print(object.debugDescription)
        
        var user = User()
        
        if let userID = object["userID"] as? String {
            user.userID = userID
        } else {
            user.userID = UUID.uuidStringTwentyCharsNoDashes
        }
        
        if let userFirstName = object["firstName"] as? String {
            user.firstName = userFirstName
        }
        
        if let userLastName = object["lastName"] as? String {
            user.lastName = userLastName
        }
        
        if let email = object["email"] as? String {
            user.email = email
        }
        
        if let ipAddresses = object["ipAddresses"] as? [String] {
            user.ipAddresses = ipAddresses
        }
        
        if let storeID = object["storeID"] as? String {
            user.storeID = storeID
        }
        
        if let companyID = object["companyID"] as? String {
            user.companyID = companyID
        }
        
        if let lastLoginDate = object["lastLoginDate"] as? Timestamp? {
            user.lastLoginDate = lastLoginDate
        } else if let lastLoginDate = object["lastLoginDate"] as? String, lastLoginDate.contains("FIRTimestamp") {
            let lastLoginDateFromString = Timestamp(dataString: lastLoginDate)
            if lastLoginDateFromString.seconds != 0 {
                user.lastLoginDate = lastLoginDateFromString
            }
        }
        
        return user
    }
    
    var firebasejson: [String:Any] {
        var result = [String:Any]()
        
        if self.userID != "" {
            result["userID"] = self.userID
        }
        
        if self.firstName != "" {
            result["firstName"] = self.firstName
        }
        
        if self.lastName != "" {
            result["lastName"] = self.lastName
        }
        
        if self.storeID != "" {
            result["storeID"] = self.storeID
        }
        
        if self.companyID != "" {
            result["companyID"] = self.companyID
        }
        
        if !self.ipAddresses.isEmpty {
            result["ipAddresses"] = self.ipAddresses
        }
        
        if let lastLoginDate = self.lastLoginDate {
            result["lastLoginDate"] = lastLoginDate
        }
        
        return result
    }
    
    var json: [String:Any] {
        var result = [String:Any]()
        
        if self.userID != "" {
            result["userID"] = self.userID
        }
        
        if self.firstName != "" {
            result["firstName"] = self.firstName
        }
        
        if self.lastName != "" {
            result["lastName"] = self.lastName
        }
        
        if self.storeID != "" {
            result["storeID"] = self.storeID
        }
        
        if self.companyID != "" {
            result["companyID"] = self.companyID
        }
        
        if !self.ipAddresses.isEmpty {
            result["ipAddresses"] = self.ipAddresses
        }
        
        if let lastLoginDate = self.lastLoginDate {
            result["lastLoginDate"] = "<FIRTimestamp: seconds=\(lastLoginDate.seconds) nanoseconds=\(lastLoginDate.nanoseconds)>"
        }
        
        
        
        return result
    }
}

