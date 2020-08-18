//
//  User.swift
//  StockManagerServerApplication
//
//  Created by Joe Paul on 8/16/20.
//

import Foundation
import Firebase

struct User {
    var userID: String
    var firstName: String
    var lastName: String
    var email: String
    var storeID: String
    var companyID: String
    var lastLoginDate: Timestamp?
    var ipAddresses: [String]
    
    init(userID: String = "", firstName: String = "", lastName: String = "", email: String = "", storeID: String = "", companyID: String = "", lastLoginDate: Timestamp? = nil, ipAddresses: [String] = []){
        self.userID = userID
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.storeID = storeID
        self.companyID = companyID
        self.lastLoginDate = lastLoginDate
        self.ipAddresses = ipAddresses
    }
}
