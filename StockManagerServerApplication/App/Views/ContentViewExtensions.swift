//
//  ContentViewExtensions.swift
//  StockManagerServerApplication
//
//  Created by Joe Paul on 8/11/20.
//

import Foundation
import SwiftUI
import Alamofire

extension ContentView {
    
    func testHelloEndpoint() {
        let parameters:Parameters = [String : Any]()
        let headers:HTTPHeaders = HTTPHeaders()
        if let url = URL(string: "http://localhost:9000/helloDrRamirez"){
            AF.request(url, method: .get, parameters: parameters , encoding: JSONEncoding.default, headers: headers)
                .responseString(completionHandler: { (response) in
                    LoggingManager.log(response.description, source: .routing, type: .success)
                })
        }
    }
}
