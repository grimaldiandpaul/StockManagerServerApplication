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
    
    func testHelloEndpoint() {
        
        var headers:HTTPHeaders = HTTPHeaders()
        headers["storeID"] = "Test Store 1"
        headers["content-type"] = "application/json"
        headers["accept"] = "application/json"
        let location = Location(aisle: "1", aisleSection: "A")
        let location2 = Location(aisle: "2", aisleSection: "B")
        let location3 = Location(aisle: "8", aisleSection: "C", spot: "21", description: "This is in a spot")
        let testItem = InventoryItem(userDesignatedID: "123456", name: "Test Item", locations: [location, location2, location3], dateLastPurchased: Timestamp(date: Date()), customerAccessibleQuantity: 0, backstockQuantity: 0)
        let parameters = testItem.json
        LoggingManager.log(parameters.debugDescription, source: .routing, type: .error)
//        if let url = URL(string: "https://rq30gjrh.burrow.io/create"){
//            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
//                .responseString { (response) in
//                    LoggingManager.log(response.description, source: .routing, type: .success)
//            }
//        }
        
        if let url = URL(string: "https://rq30gjrh.burrow.io/create"){
            AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: headers)
                .responseString { (response) in
                    LoggingManager.log(response.description, source: .routing, type: .success)
            }
        }
        
    }
}
