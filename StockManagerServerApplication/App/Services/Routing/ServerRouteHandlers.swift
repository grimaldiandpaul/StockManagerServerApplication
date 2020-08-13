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
    
    func serverHandleRefPage(request: HTTPRequest) throws -> HTTPResponse {
        return HTTPResponse(content: "Here is the API reference:")
    }
    
    func serverHandleCreateItem(request: HTTPRequest) -> HTTPResponse {
        
        if let storeID = request.headers["storeID"] {
            do {
                let body = try JSONSerialization.jsonObject(with: request.body, options: .allowFragments)
                if let body = body as? [String:Any] {
                    let newItem = InventoryItem.from(body)
                    let createOperationResult = FirebaseWrapper.createItem(newItem, store: storeID)
                    if let err = createOperationResult.error {
                        LoggingManager.log("Item could not be created: \(err)", source: .routing, type: .error)
                        return HTTPResponse(.notAcceptable, headers: HTTPHeaders(), content: err)
                    } else {
                        let json = newItem.json
                        if let data = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed) {
                            return HTTPResponse(body: data)
                        } else {
                            LoggingManager.log("Json object could not be serialized", source: .routing, type: .error)
                            return HTTPResponse(content: "Json object could not be serialized")
                        }
                    }
                } else {
                    return HTTPResponse(content: "Json object could not be serialized2")
                }
            } catch {
                print(error)
                LoggingManager.log(error.localizedDescription, source: .routing, type: .error)
                return HTTPResponse(content: "Json object could not be serialized3")
            }
            
        } else {
            LoggingManager.log("Store ID was not included in headers", source: .routing, type: .error)
            return HTTPResponse(content: "Store ID was not included in headers")
        }
        //return HTTPResponse(content: "Unable to complete request")
    }
}
