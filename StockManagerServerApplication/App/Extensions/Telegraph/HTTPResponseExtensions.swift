//
//  HTTPResponseExtensions.swift
//  StockManagerServerApplication
//
//  Created by Joe Paul on 8/22/20.
//

import Foundation
import Telegraph

extension HTTPResponse {
    
    func addHeaders() -> HTTPResponse {
        let response = self
        response.headers.accessControlAllowOrigin = "*"
           // = ["Access-Control-Allow-Origin" : "*", "Access-Control-Allow-Methods" : "GET, POST, PUT, DELETE", "Access-Control-Allow-Headers" : "Content-Type", "Access-Control-Allow-Credentials": "true"]
        return response
    }
}
