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
    
    func serverHandleAuthenticate(request: HTTPRequest) throws -> HTTPResponse {

        if request.body.count > 0 {
            let body = try JSONSerialization.jsonObject(with: request.body, options: .allowFragments)
            if let body = body as? [String:Any] {
                if let username = body["username"] as? String {
                    if let password = body["password"] as? String {
                        let authenticationResult = FirebaseWrapper.authenticateUser(username: username, password: password)
                        if let error = authenticationResult.error {
                            return HTTPResponse(content: error)
                        } else {
                            if let authenticated = authenticationResult.successful {
                                if authenticated {
                                    if let user = authenticationResult.user {
                                        return HTTPResponse(body: user)
                                    } else {
                                        return HTTPResponse(content: "User data could not be parsed")
                                    }
                                }
                            } else {
                                return HTTPResponse(content: "Error authenticating user")
                            }
                        }
                    } else {
                        return HTTPResponse(content: "Password not provided")
                    }
                } else {
                    return HTTPResponse(content: "Username not provided")
                }
            }
        } else {
            return HTTPResponse(content: "Credentials must be posted in the body of the request")
        }
        return HTTPResponse(content: "THIS NEEDS TO BE DELETED")
    }
    
    func serverHandleCreateItem(request: HTTPRequest) -> HTTPResponse {
        
        print(request.headers)
        
        if let storeID = request.headers["storeID"] {
            
            print("Params: \(request.params)")
            print(request.body.base64EncodedData())
            var newItem: InventoryItem? = nil
            if let parameters = request.uri.queryItems?.parameters, parameters.count > 0 {
                newItem = InventoryItem.from(parameters)
                
            } else if request.body.count > 0 {
                
                do {
                    let body = try JSONSerialization.jsonObject(with: request.body, options: .allowFragments)
                    if let body = body as? [String:Any] {
                        newItem = InventoryItem.from(body)
                        
                    } else {
                        return HTTPResponse(content: "Json object could not be serialized")
                    }
                } catch {
                    print(error)
                    LoggingManager.log(error.localizedDescription, source: .routing, type: .error)
                    return HTTPResponse(content: "Json object could not be serialized")
                }
            }
            
            if let newItem = newItem {
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
                return HTTPResponse(content: "Please include item details inside of parameters or body")
            }
            
        } else {
            LoggingManager.log("Store ID was not included in headers", source: .routing, type: .error)
            return HTTPResponse(content: "Store ID needs to be included in headers")
        }
    }
}

extension Array where Element == URLQueryItem {
    var parameters: [String:Any] {
        var result = [String:Any]()
        for item in self {
            if item.name.contains("[][") {
                let key = String(item.name.prefix(while: {$0 != "["}))
                var innerKey = item.name
                while innerKey.contains("["){
                    innerKey = String(innerKey.dropFirst())
                }
                innerKey = String(innerKey.dropLast())
                
                if result.keys.contains(key) {
                    if var arrayOfDictionaries = result[key] as? [[String:Any]]{
                        var found = false
                        for i in 0..<arrayOfDictionaries.count {
                            let dictionary = arrayOfDictionaries[i]
                            if !dictionary.keys.contains(innerKey) {
                                found = true
                                arrayOfDictionaries[i][innerKey] = item.value
                                result[key] = arrayOfDictionaries
                            }
                        }
                        if !found {
                            if let value = item.value {
                                let newDictionary: [String:Any] = [innerKey: value]
                                arrayOfDictionaries.append(newDictionary)
                                result[key] = arrayOfDictionaries
                            }
                        }
                    }
                } else {
                    if let value = item.value {
                        let newDictionary: [String:Any] = [innerKey: value]
                        result[key] = [newDictionary]
                    }
                }
                
            } else if item.name.contains("[") && item.name.contains("]"){
                
            } else {
                result[item.name] = item.value
            }
        }
        return result
    }
}
