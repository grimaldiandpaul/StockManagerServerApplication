//
//  ServerRouteHandlers.swift
//  StockManagerServerApplication
//
//  Created by Joe Paul on 8/11/20.
//

import Foundation
import Telegraph

extension TelegraphServer {
    
    func serverHandleHelloDrRamirez(request: HTTPRequest) throws -> HTTPResponse {
        return HTTPResponse(content: "Hello, Dr. Ramirez!")
    }
    
    private func serverHandleCreateItem(request: HTTPRequest) -> HTTPResponse {
        
        if let storeID = request.headers["storeID"] {
            let body = request.params
            let newItem = InventoryItem.from(body)
            FirebaseWrapper.createItem(newItem, store: storeID) { (error, result) in
                if let err = error {
                    LoggingManager.log("Item could not be created: \(err)", source: .routing, type: .error)
                    return HTTPResponse(.notAcceptable, headers: HTTPHeaders(), content: err)
                } else {
                    if let json = newItem.json {
                        if let data = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed) {
                            return HTTPResponse(body: data)
                        } else {
                            LoggingManager.log("Json object could not be serialized", source: .routing, type: .error)
                            return HTTPResponse(content: "Json object could not be serialized")
                        }
                    } else {
                        LoggingManager.log("Json object could not be encoded", source: .routing, type: .error)
                        return HTTPResponse(content: "Json object could not be encoded")
                    }
                }
            }
        } else {
            LoggingManager.log("Store ID was not included in headers", source: .routing, type: .error)
            return HTTPResponse(content: "Store ID was not included in headers")
        }
        return HTTPResponse(content: "Unable to complete request")
    }
}
