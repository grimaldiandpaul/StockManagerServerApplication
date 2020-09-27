//
//  ContentViewExtensions.swift
//  StockManagerServerApplication
//
//  Created By Zachary Grimaldi and Joseph Paul on 8/11/20.
//

import Foundation
import SwiftUI
import Alamofire
import Firebase

extension ContentView {
    
    /// A unction to test all server endpoints
    func testHelloEndpoint() {
        
        var headers:HTTPHeaders = HTTPHeaders()
        headers["storeID"] = "Test Store 1"
        headers["content-type"] = "application/json"
        headers["accept"] = "application/json"
        let location = Location(aisle: "1", aisleSection: "A")
        let location2 = Location(aisle: "2", aisleSection: "B")
        let location3 = Location(aisle: "8", aisleSection: "D", spot: "21", description: "This is in a spot")
        let testItem = InventoryItem(userDesignatedID: "123457", name: "Test Item", locations: [location, location2, location3], dateLastPurchased: Timestamp(date: Date()).seconds, customerAccessibleQuantity: 0, backstockQuantity: 10)
        var testItemJson = testItem.json
        testItemJson["storeID"] = "Test Store 1"
        let parameters: [String:Any] = ["storeID": "Test Store 1", "type": "customerAccessibleQuantity", "value": 999, "userDesignatedID": "123456"]
        
//        if let url = URL(string: "https://api.stockmanager.tech"){
//            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
//                .responseString { (response) in
//                    LoggingManager.log(response.description, source: .routing, type: .success)
//            }
//        }
        
        if let url = URL(string: "https://api.stockmanager.tech/item/decrement"){
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseString { (response) in
                                    LoggingManager.log(response.description, source: .routing, type: .success)
                            }
        }
        
    }
    
}
