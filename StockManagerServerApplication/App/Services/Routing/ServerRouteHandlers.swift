//
//  ServerRouteHandlers.swift
//  StockManagerServerApplication
//
//  Created By Zachary Grimaldi and Joseph Paul on 8/11/20.
//

import Foundation
import Telegraph

extension TelegraphServer {
    
    /// handler function for the "hellodrramirez" slug
    /// - Parameter HTTPRequest: the request that is hitting this handler's endpoint
    /// - Returns: The HTTPResponse for this request
    func serverHandleHelloDrRamirez(request: HTTPRequest) throws -> HTTPResponse {
        return HTTPResponse(content: "Hello, Dr. Ramirez!").addHeaders()
    }
    
    /// default handler for the default endpoint
    /// - Parameter HTTPRequest: the request that is hitting this handler's endpoint
    /// - Returns: The HTTPResponse for this request
    func serverHandleRefPage(request: HTTPRequest) throws -> HTTPResponse {
        return HTTPResponse(content: "Here is the API reference:").addHeaders()
    }
    
    /// handler function for the "authenticate" slug
    /// - Parameter HTTPRequest: the request that is hitting this handler's endpoint
    /// - Returns: The HTTPResponse for this request
    func serverHandleAuthenticate(request: HTTPRequest) throws -> HTTPResponse {
        print(request)

        // if there is data in the body of the request
        if request.body.count > 0 {
            
            // try to serialize the body
            let body = try JSONSerialization.jsonObject(with: request.body, options: .allowFragments)
            
            // if the body can be serialized to a [String:Any] object
            if let body = body as? [String:Any] {
                
                // if the body contains the "email" field
                if let email = body["email"] as? String {
                    
                    // if the body contains the "password" field
                    if let password = body["password"] as? String {
                        let authenticationResult = FirebaseWrapper.authenticateUser(email: email, password: password)
                        
                        // if the authentication process returned an error
                        if let error = authenticationResult.error {
                            return HTTPResponse(content: error.output).addHeaders()
                        } else {
                            
                            // if the user is successfully authenticated
                            if let authenticated = authenticationResult.successful,
                                authenticated, let user = authenticationResult.user {
                                    return HTTPResponse(body: user).addHeaders()
                            } else {
                                return HTTPResponse(content: StockManagerError.AuthenticationErrors.invalidCredentials.output).addHeaders()
                            }
                        }
                    } else {
                        return HTTPResponse(content: StockManagerError.AuthenticationErrors.emptyPassword.output).addHeaders()
                    }
                } else {
                    return HTTPResponse(content: StockManagerError.AuthenticationErrors.emptyEmail.output).addHeaders()
                }
            } else {
                return HTTPResponse(content: StockManagerError.AuthenticationErrors.missingCredentials.output).addHeaders()
            }
        } else {
            return HTTPResponse(content: StockManagerError.AuthenticationErrors.missingCredentials.output).addHeaders()
        }
    }
    
    
    /// handler function for the "create" slug
    /// - Parameter HTTPRequest: the request that is hitting this handler's endpoint
    /// - Returns: The HTTPResponse for this request
    func serverHandleCreateItem(request: HTTPRequest) -> HTTPResponse {
  
            var storeID = ""
            var storeIDs = [String]()
            var newItem: InventoryItem? = nil
        
            // if user is adding item through the URL
            if let parameters = request.uri.queryItems?.parameters, parameters.count > 0 {
                if let storeIdentifier = parameters["storeID"] as? String {
                    storeID = storeIdentifier
                } else if let storeIdentifiers = parameters["storeIDs"] as? [String] {
                    storeIDs = storeIdentifiers
                } else {
                    return HTTPResponse(content: StockManagerError.DatabaseErrors.missingField.output).addHeaders()
                }
                newItem = InventoryItem.from(parameters)
                
            // if user is adding item through body
            } else if request.body.count > 0 {
                
                do {
                    // try to serialize the body into [String:Any] map
                    let body = try JSONSerialization.jsonObject(with: request.body, options: .allowFragments)
                    
                    // if the body was serialized
                    if let body = body as? [String:Any] {
                        newItem = InventoryItem.from(body)
                        
                        // if the user included the storeID field
                        if let storeIdentifier = body["storeID"] as? String {
                            storeID = storeIdentifier
                        }
                            
                        // if the user included the storeIDs field
                        else if let storeIdentifiers = body["storeIDs"] as? [String] {
                            storeIDs = storeIdentifiers
                        }
                        
                        // else return missingField error
                        else {
                            return HTTPResponse(content: StockManagerError.DatabaseErrors.missingField.output).addHeaders()
                        }
                        newItem = InventoryItem.from(body)
                        
                    } else {
                        return HTTPResponse(content: StockManagerError.JSONErrors.serializationError.output).addHeaders()
                    }
                } catch {
                    print(error)
                    LoggingManager.log(error.localizedDescription, source: .routing, type: .error)
                    return HTTPResponse(content: StockManagerError.JSONErrors.serializationError.output).addHeaders()
                }
            }
            
        
        // if the storeID field is included in the request
        if storeID.count > 0 {
            
            // if newItem is not null
            if let newItem = newItem {
                let createOperationResult = FirebaseWrapper.createItem(newItem, storeID: storeID)
                
                // if there was an error creating the object in Firebase Cloud Database
                if let err = createOperationResult.error {
                    LoggingManager.log(err.output, source: .routing, type: .error)
                    return HTTPResponse(content: err.output).addHeaders()
                } else {
                    let json = newItem.json
                    
                    // if data serialization is successful
                    if let data = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed) {
                        return HTTPResponse(body: data).addHeaders()
                    } else {
                        LoggingManager.log(StockManagerError.JSONErrors.serializationError.output, source: .routing, type: .error)
                        return HTTPResponse(content: StockManagerError.JSONErrors.serializationError.output).addHeaders()
                    }
                }
            } else {
                return HTTPResponse(content: StockManagerError.APIErrors.missingData.output).addHeaders()
            }
        }
        
        // if the storeIDs field is included in the request
        else {
            var finalString = ""
            var finishedAddingItems = false
            var unsuccessfulStoreIDs = [String]()
            
            // if newItem is not null
            if let newItem = newItem {
                for store in storeIDs {
                    let createOperationResult = FirebaseWrapper.createItem(newItem, storeID: store)
                    
                    // if there was an error adding to one store, add the storeID to the array. This will be used later
                    if let err = createOperationResult.error {
                        LoggingManager.log(err.output, source: .routing, type: .error)
                        unsuccessfulStoreIDs.append(storeID)
                    }
                }
                
                // if adding to any stores was unsuccessful, append their ID to the finalString so user knows which stores' ItemList does not contain the item
                if unsuccessfulStoreIDs.count > 0 {
                    finalString = "Could not add item to store(s): "
                    for id in unsuccessfulStoreIDs{
                        finalString = finalString + "\(id), "
                    }
                    finalString = String(finalString.dropLast())
                    finalString = String(finalString.dropLast())
                    finishedAddingItems = true
                } else {
                    finalString = "Successfully added item to all stores"
                    finishedAddingItems = true
                }
                   
            } else {
                finalString = StockManagerError.APIErrors.missingData.output
                finishedAddingItems = true
            }
            
            // wait for all Firebase operations to finish
            while (!finishedAddingItems) {
                sleep(1)
            }
            
            return HTTPResponse(content: finalString).addHeaders()
        }
    }
}

/// An extension for the `Array` object
extension Array where Element == URLQueryItem {
    
    // computed variable that serializes URLQueryItems to JSON objects
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
