//
//  GCDWebServer.swift
//  StockManagerServerApplication
//
//  Created by Zachary Grimaldi and Joseph Paul on 8/24/20.
//

import Foundation
import GCDWebServer
import Firebase

class GCDServer {
    
    static let main = GCDServer()
    var server = GCDWebServer()
    
    class func startup() {
        GCDServer.main.server.addDefaultHandler(forMethod: "GET", request: GCDWebServerRequest.self, processBlock: {request in
            let response = GCDWebServerDataResponse(html:"<html><body><p>Hello World</p></body></html>")
            if let response = response?.addHeaders() {
                return response
            }
            return response
                
            })
        
        GCDServer.main.server.addHandler(forMethod: "OPTIONS", path: "/user/authenticate", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            let response = GCDWebServerDataResponse(jsonObject: [:])
            if let response = response?.addHeaders() {
                return response
            } else {
                print("Error adding headers")
            }
            return response

        }
        
        GCDServer.main.server.addHandler(forMethod: "POST", path: "/user/authenticate", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            
            var ipAddress: String? = nil
            if let ip = request.headers["X-Real-IP"] {
                ipAddress = ip
            } else if let ip = request.headers["X-Forwarded-For"] {
                ipAddress = ip
            }
            
            if let requestData = request as? GCDWebServerDataRequest {
                let data = requestData.data
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                    if let dict = json as? [String:Any] {
                        if let email = dict["email"] as? String {
                            if let pass = dict["password"] as? String, pass.count > 0 {
                                let userAuthenticationResult = FirebaseWrapper.authenticateUser(email: email, password: pass, ipAddress: ipAddress)
                                
                                // if the authentication process returned an error
                                if let error = userAuthenticationResult.error {
                                    return GCDWebServerErrorResponse(text: error.output)?.addHeaders()
                                } else {
                                    
                                    // if the user is successfully authenticated
                                    if let authenticated = userAuthenticationResult.successful,
                                        authenticated, let user = userAuthenticationResult.user {
                                        return GCDWebServerDataResponse(jsonObject: user)?.addHeaders()
                                    } else {
                                        return GCDWebServerErrorResponse(text: StockManagerError.AuthenticationErrors.invalidCredentials.output)?.addHeaders()
                                    }
                                }
                            } else {
                                return GCDWebServerErrorResponse(text: StockManagerError.AuthenticationErrors.missingCredentials.output)?.addHeaders()
                            }
                        } else {
                            return GCDWebServerErrorResponse(text: StockManagerError.AuthenticationErrors.missingCredentials.output)?.addHeaders()
                        }
                    } else {
                        return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.castingError.output)?.addHeaders()
                    }
                } else {
                    return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.serializationError.output)?.addHeaders()
                }
            } else {
                return GCDWebServerErrorResponse(text: StockManagerError.APIErrors.castingError.output)?.addHeaders()
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        GCDServer.main.server.addHandler(forMethod: "OPTIONS", path: "/user/create", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            let response = GCDWebServerDataResponse(jsonObject: [:])
            if let response = response?.addHeaders() {
                return response
            } else {
                print("Error adding headers")
            }
            return response

        }
        
        GCDServer.main.server.addHandler(forMethod: "POST", path: "/user/create", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            
            var ipAddress: String? = nil
            if let ip = request.headers["X-Real-IP"] {
                ipAddress = ip
            } else if let ip = request.headers["X-Forwarded-For"] {
                ipAddress = ip
            }
            
            if let temp = request as? GCDWebServerDataRequest {
                let data = temp.data
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                    if let dict = json as? [String:Any] {
                        let userCreationResult = FirebaseWrapper.createUser(userInformation: dict, ipAddress: ipAddress)
                        if let error = userCreationResult.error {
                            return GCDWebServerErrorResponse(text: error.output)?.addHeaders()
                        } else {
                            // if the user is successfully created
                            if let created = userCreationResult.successful,
                                created, let user = userCreationResult.user {
                                return GCDWebServerDataResponse(jsonObject: user)?.addHeaders()
                            } else {
                                return GCDWebServerErrorResponse(text: StockManagerError.unreachableError.output)?.addHeaders()
                            }
                        }
                    } else {
                        return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.castingError.output)?.addHeaders()
                    }
                } else {
                    return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.serializationError.output)?.addHeaders()
                }
            } else {
                return GCDWebServerErrorResponse(text: StockManagerError.APIErrors.castingError.output)?.addHeaders()
            }
        }
        
        
        GCDServer.main.server.addHandler(forMethod: "OPTIONS", path: "/item/query/udid", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            let response = GCDWebServerDataResponse(jsonObject: [:])
            if let response = response?.addHeaders() {
                return response
            } else {
                print("Error adding headers")
            }
            return response

        }
                                
                                
        GCDServer.main.server.addHandler(forMethod: "POST", path: "/item/query/udid", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerResponse? in
            
            if let requestData = request as? GCDWebServerDataRequest {
                let data = requestData.data
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                    if let dict = json as? [String:Any] {
                        if let storeID = dict["storeID"] as? String {
                            if let id = dict["userDesignatedID"] as? String {
                                let fetchResult = FirebaseWrapper.retrieveItem(id, storeID: storeID)
                                if let error = fetchResult.error {
                                    return GCDWebServerErrorResponse(text: error.output)?.addHeaders()
                                } else {
                                    if let item = fetchResult.item {
                                        return GCDWebServerDataResponse(jsonObject: item)?.addHeaders()
                                    } else {
                                        return GCDWebServerErrorResponse(text: StockManagerError.unreachableError.output)?.addHeaders()
                                    }
                                }
                            } else {
                                return GCDWebServerErrorResponse(text: StockManagerError.DatabaseErrors.missingUserDesignatedIDField.output)?.addHeaders()
                            }
                        } else {
                            return GCDWebServerErrorResponse(text: StockManagerError.DatabaseErrors.missingStoreIDField.output)?.addHeaders()
                        }
                    } else {
                        return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.castingError.output)?.addHeaders()
                    }
                } else {
                    return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.serializationError.output)?.addHeaders()
                }
            } else {
                return GCDWebServerErrorResponse(text: StockManagerError.APIErrors.castingError.output)?.addHeaders()
            }
            
        }
        
        GCDServer.main.server.addHandler(forMethod: "OPTIONS", path: "/item/query/name", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            let response = GCDWebServerDataResponse(jsonObject: [:])
            if let response = response?.addHeaders() {
                return response
            } else {
                print("Error adding headers")
            }
            return response

        }
                                
                                
        GCDServer.main.server.addHandler(forMethod: "POST", path: "/item/query/name", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerResponse? in
            
            if let requestData = request as? GCDWebServerDataRequest {
                let data = requestData.data
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                    if let dict = json as? [String:Any] {
                        if let storeID = dict["storeID"] as? String {
                            if let name = dict["name"] as? String {
                                let fetchResult = FirebaseWrapper.retrieveItems(name, storeID: storeID)
                                if let error = fetchResult.error {
                                    return GCDWebServerErrorResponse(text: error.output)?.addHeaders()
                                } else {
                                    if let items = fetchResult.items {
                                        return GCDWebServerDataResponse(jsonObject: items)?.addHeaders()
                                    } else {
                                        return GCDWebServerErrorResponse(text: StockManagerError.unreachableError.output)?.addHeaders()
                                    }
                                }
                            } else {
                                return GCDWebServerErrorResponse(text: StockManagerError.DatabaseErrors.missingNameField.output)?.addHeaders()
                            }
                        } else {
                            return GCDWebServerErrorResponse(text: StockManagerError.DatabaseErrors.missingStoreIDField.output)?.addHeaders()
                        }
                    } else {
                        return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.castingError.output)?.addHeaders()
                    }
                } else {
                    return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.serializationError.output)?.addHeaders()
                }
            } else {
                return GCDWebServerErrorResponse(text: StockManagerError.APIErrors.castingError.output)?.addHeaders()
            }
            
        }
        
        
        GCDServer.main.server.addHandler(forMethod: "OPTIONS", path: "/item/image", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            let response = GCDWebServerDataResponse(jsonObject: [:])
            if let response = response?.addHeaders() {
                return response
            } else {
                print("Error adding headers")
            }
            return response

        }
        
        
        GCDServer.main.server.addHandler(forMethod: "POST", path: "/item/image", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerResponse? in
            
            if let requestData = request as? GCDWebServerDataRequest {
                let data = requestData.data
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                    if let dict = json as? [String:Any] {
                        if let id = dict["id"] as? String {
                            let fetchResult = FirebaseWrapper.retrieveImage(itemUUID: id)
                            if let error = fetchResult.error {
                                return GCDWebServerErrorResponse(text: error.output)?.addHeaders()
                            } else {
                                if let image = fetchResult.image {
                                    return GCDWebServerDataResponse(data: image, contentType: "utf-8").addHeaders()
                                } else {
                                    return GCDWebServerErrorResponse(text: StockManagerError.unreachableError.output)?.addHeaders()
                                }
                            }
                        } else {
                            return GCDWebServerErrorResponse(text: StockManagerError.DatabaseErrors.missingItemIDField.output)?.addHeaders()
                        }
                    } else {
                        return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.castingError.output)?.addHeaders()
                    }
                } else {
                    return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.serializationError.output)?.addHeaders()
                }
            } else {
                return GCDWebServerErrorResponse(text: StockManagerError.APIErrors.castingError.output)?.addHeaders()
            }
            
        }
        
        GCDServer.main.server.addHandler(forMethod: "OPTIONS", path: "/item/imageurl", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            let response = GCDWebServerDataResponse(jsonObject: [:])
            if let response = response?.addHeaders() {
                return response
            } else {
                print("Error adding headers")
            }
            return response

        }
        
        
        GCDServer.main.server.addHandler(forMethod: "POST", path: "/item/imageurl", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerResponse? in
            
            if let requestData = request as? GCDWebServerDataRequest {
                let data = requestData.data
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                    if let dict = json as? [String:Any] {
                        if let id = dict["id"] as? String {
                            let fetchResult = FirebaseWrapper.retrieveImageURL(itemUUID: id)
                            if let error = fetchResult.error {
                                return GCDWebServerErrorResponse(text: error.output)?.addHeaders()
                            } else {
                                if let url = fetchResult.url {
                                    var responseJSON: [String:Any] = [:]
                                    responseJSON["imageURL"] = url
                                    return GCDWebServerDataResponse(jsonObject: responseJSON)?.addHeaders()
                                } else {
                                    return GCDWebServerErrorResponse(text: StockManagerError.unreachableError.output)?.addHeaders()
                                }
                            }
                        } else {
                            return GCDWebServerErrorResponse(text: StockManagerError.DatabaseErrors.missingItemIDField.output)?.addHeaders()
                        }
                    } else {
                        return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.castingError.output)?.addHeaders()
                    }
                } else {
                    return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.serializationError.output)?.addHeaders()
                }
            } else {
                return GCDWebServerErrorResponse(text: StockManagerError.APIErrors.castingError.output)?.addHeaders()
            }
            
        }
        
        GCDServer.main.server.addHandler(forMethod: "OPTIONS", path: "/item/increment", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            let response = GCDWebServerDataResponse(jsonObject: [:])
            if let response = response?.addHeaders() {
                return response
            } else {
                print("Error adding headers")
            }
            return response

        }
        
        GCDServer.main.server.addHandler(forMethod: "POST", path: "/item/increment", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            
            
            if let temp = request as? GCDWebServerDataRequest {
                let data = temp.data
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                    if let dict = json as? [String:Any] {
                        if let incrementValue = dict["value"] as? Int, let type = dict["type"] as? String {
                            if let itemID = dict["userDesignatedID"] as? String {
                                if let storeID = dict["storeID"] as? String {
                                    let result = FirebaseWrapper.incrementItem(itemID, value: incrementValue, type: type, storeID: storeID)
                                    if let error = result.error {
                                        return GCDWebServerErrorResponse(text: error.output)?.addHeaders()
                                    } else {
                                        var responseJSON: [String:Any] = [:]
                                        responseJSON["result"] = "Success"
                                        return GCDWebServerDataResponse(jsonObject: responseJSON)?.addHeaders()
                                    }
                                } else {
                                    return GCDWebServerErrorResponse(text: StockManagerError.DatabaseErrors.missingStoreIDField.output)?.addHeaders()
                                }
                            } else {
                                return GCDWebServerErrorResponse(text: StockManagerError.DatabaseErrors.missingUserDesignatedIDField.output)?.addHeaders()
                            }
                        } else {
                            return GCDWebServerErrorResponse(text: StockManagerError.APIErrors.missingData.output)?.addHeaders()
                        }
                    } else {
                        return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.castingError.output)?.addHeaders()
                    }
                } else {
                    return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.serializationError.output)?.addHeaders()
                }
            } else {
                return GCDWebServerErrorResponse(text: StockManagerError.APIErrors.castingError.output)?.addHeaders()
            }
        }
                                
                                
        GCDServer.main.server.addHandler(forMethod: "OPTIONS", path: "/item/create", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            let response = GCDWebServerDataResponse(jsonObject: [:])
            if let response = response?.addHeaders() {
                return response
            } else {
                print("Error adding headers")
            }
            return response

        }
        
        GCDServer.main.server.addHandler(forMethod: "POST", path: "/item/create", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            
            if let temp = request as? GCDWebServerDataRequest {
                let data = temp.data
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                    if let dict = json as? [String:Any] {
                        if let storeID = dict["storeID"] as? String {
                            let item = InventoryItem.from(dict)
                            let result = FirebaseWrapper.createItem(item, storeID: storeID)
                            if let error = result.error {
                                return GCDWebServerErrorResponse(text: error.output)?.addHeaders()
                            } else {
                                return GCDWebServerDataResponse(jsonObject: result.item)?.addHeaders()
                            }
                        } else {
                            return GCDWebServerErrorResponse(text: StockManagerError.DatabaseErrors.missingStoreIDField.output)?.addHeaders()
                        }
                    } else {
                        return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.castingError.output)?.addHeaders()
                    }
                } else {
                    return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.serializationError.output)?.addHeaders()
                }
            } else {
                return GCDWebServerErrorResponse(text: StockManagerError.APIErrors.castingError.output)?.addHeaders()
            }
        }
        
        GCDServer.main.server.addHandler(forMethod: "OPTIONS", path: "/item/update", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            let response = GCDWebServerDataResponse(jsonObject: [:])
            if let response = response?.addHeaders() {
                return response
            } else {
                print("Error adding headers")
            }
            return response

        }
        
        GCDServer.main.server.addHandler(forMethod: "POST", path: "/item/update", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            
            if let temp = request as? GCDWebServerDataRequest {
                let data = temp.data
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                    if let dict = json as? [String:Any] {
                        if let storeID = dict["storeID"] as? String {
                            let item = InventoryItem.from(dict)
                            let result = FirebaseWrapper.updateItem(item, storeID: storeID)
                            if let error = result.error {
                                return GCDWebServerErrorResponse(text: error.output)?.addHeaders()
                            } else {
                                return GCDWebServerDataResponse(jsonObject: result.item)?.addHeaders()
                            }
                        } else {
                            return GCDWebServerErrorResponse(text: StockManagerError.DatabaseErrors.missingStoreIDField.output)?.addHeaders()
                        }
                    } else {
                        return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.castingError.output)?.addHeaders()
                    }
                } else {
                    return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.serializationError.output)?.addHeaders()
                }
            } else {
                return GCDWebServerErrorResponse(text: StockManagerError.APIErrors.castingError.output)?.addHeaders()
            }
        }
                                
        GCDServer.main.server.addHandler(forMethod: "OPTIONS", path: "/item/decrement", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            let response = GCDWebServerDataResponse(jsonObject: [:])
            if let response = response?.addHeaders() {
                return response
            } else {
                print("Error adding headers")
            }
            return response

        }
        
        GCDServer.main.server.addHandler(forMethod: "POST", path: "/item/decrement", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            
            
            if let temp = request as? GCDWebServerDataRequest {
                let data = temp.data
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                    if let dict = json as? [String:Any] {
                        if let decrementValue = dict["value"] as? Int, let type = dict["type"] as? String {
                            if let itemID = dict["userDesignatedID"] as? String {
                                if let storeID = dict["storeID"] as? String {
                                    let result = FirebaseWrapper.decrementItem(itemID, value: decrementValue, type: type, storeID: storeID)
                                    if let error = result.error {
                                        return GCDWebServerErrorResponse(text: error.output)?.addHeaders()
                                    } else {
                                        var responseJSON: [String:Any] = [:]
                                        responseJSON["result"] = "Success"
                                        return GCDWebServerDataResponse(jsonObject: responseJSON)?.addHeaders()
                                    }
                                } else {
                                    return GCDWebServerErrorResponse(text: StockManagerError.DatabaseErrors.missingStoreIDField.output)?.addHeaders()
                                }
                            } else {
                                return GCDWebServerErrorResponse(text: StockManagerError.DatabaseErrors.missingUserDesignatedIDField.output)?.addHeaders()
                            }
                        } else {
                            return GCDWebServerErrorResponse(text: StockManagerError.APIErrors.missingData.output)?.addHeaders()
                        }
                    } else {
                        return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.castingError.output)?.addHeaders()
                    }
                } else {
                    return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.serializationError.output)?.addHeaders()
                }
            } else {
                return GCDWebServerErrorResponse(text: StockManagerError.APIErrors.castingError.output)?.addHeaders()
            }
        }
              
        
        GCDServer.main.server.addHandler(forMethod: "OPTIONS", path: "/task/create", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            let response = GCDWebServerDataResponse(jsonObject: [:])
            if let response = response?.addHeaders() {
                return response
            } else {
                print("Error adding headers")
            }
            return response

        }
        
        GCDServer.main.server.addHandler(forMethod: "POST", path: "/task/create", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            
            if let temp = request as? GCDWebServerDataRequest {
                let data = temp.data
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                    if let dict = json as? [String:Any] {
                        if let storeID = dict["storeID"] as? String {
                            if let employeeID = dict["assignedEmployeeID"] as? String {
                                if let src = dict["src"] as? [String:Any] {
                                    if let dest = dict["dest"] as? [String:Any] {
                                        if let userDesignatedID = dict["userDesignatedID"] as? String {
                                            
                                            let result = FirebaseWrapper.createTask(storeID: storeID, employeeID: employeeID, src: src, dest: dest, userDesignatedID: userDesignatedID)
                                            if let error = result.error {
                                                return GCDWebServerErrorResponse(text: error.output)?.addHeaders()
                                            } else {
                                                return GCDWebServerDataResponse(jsonObject: result.task)?.addHeaders()
                                            }
                                            
                                        } else {
                                            return GCDWebServerErrorResponse(text: StockManagerError.DatabaseErrors.missingUserDesignatedIDField.output)?.addHeaders()
                                        }
                                    } else {
                                        return GCDWebServerErrorResponse(text: StockManagerError.APIErrors.missingData.output)?.addHeaders()
                                    }
                                } else {
                                    return GCDWebServerErrorResponse(text: StockManagerError.APIErrors.missingData.output)?.addHeaders()
                                }
                            } else {
                                return GCDWebServerErrorResponse(text: StockManagerError.APIErrors.missingData.output)?.addHeaders()
                            }
                        } else {
                            return GCDWebServerErrorResponse(text: StockManagerError.APIErrors.missingStoreID.output)?.addHeaders()
                        }
                    } else {
                        return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.castingError.output)?.addHeaders()
                    }
                } else {
                    return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.serializationError.output)?.addHeaders()
                }
            } else {
                return GCDWebServerErrorResponse(text: StockManagerError.APIErrors.castingError.output)?.addHeaders()
            }
        }
        
        GCDServer.main.server.addHandler(forMethod: "OPTIONS", path: "/task/complete", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            let response = GCDWebServerDataResponse(jsonObject: [:])
            if let response = response?.addHeaders() {
                return response
            } else {
                print("Error adding headers")
            }
            return response

        }
        
        GCDServer.main.server.addHandler(forMethod: "POST", path: "/task/complete", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in


            if let temp = request as? GCDWebServerDataRequest {
                let data = temp.data
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                    if let dict = json as? [String:Any] {
                            if let taskID = dict["taskID"] as? String {
                                if let storeID = dict["storeID"] as? String {

                                    let result = FirebaseWrapper.completeTask(storeID: storeID, taskID: taskID)
                                    if let error = result.error {
                                        return GCDWebServerErrorResponse(text: error.output)?.addHeaders()
                                    } else {
                                        return GCDWebServerDataResponse(jsonObject: result.task)?.addHeaders()
                                    }

                                } else {
                                    return GCDWebServerErrorResponse(text: StockManagerError.DatabaseErrors.missingStoreIDField.output)?.addHeaders()
                                }
                            } else {
                                return GCDWebServerErrorResponse(text: StockManagerError.APIErrors.missingTaskID.output)?.addHeaders()
                            }
                    } else {
                        return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.castingError.output)?.addHeaders()
                    }
                } else {
                    return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.serializationError.output)?.addHeaders()
                }
            } else {
                return GCDWebServerErrorResponse(text: StockManagerError.APIErrors.castingError.output)?.addHeaders()
            }
        }
        
        GCDServer.main.server.addHandler(forMethod: "OPTIONS", path: "/task/approve", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            let response = GCDWebServerDataResponse(jsonObject: [:])
            if let response = response?.addHeaders() {
                return response
            } else {
                print("Error adding headers")
            }
            return response

        }
        
        GCDServer.main.server.addHandler(forMethod: "POST", path: "/task/approve", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in


            if let temp = request as? GCDWebServerDataRequest {
                let data = temp.data
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                    if let dict = json as? [String:Any] {
                        if let taskID = dict["taskID"] as? String {
                                if let storeID = dict["storeID"] as? String {
                                    let result = FirebaseWrapper.approveTask(storeID: storeID, taskID: taskID)
                                    if let error = result.error {
                                        return GCDWebServerErrorResponse(text: error.output)?.addHeaders()
                                    } else {
                                        return GCDWebServerDataResponse(jsonObject: result.task)?.addHeaders()
                                    }
                                } else {
                                    return GCDWebServerErrorResponse(text: StockManagerError.DatabaseErrors.missingStoreIDField.output)?.addHeaders()
                                }
                        } else {
                            return GCDWebServerErrorResponse(text: StockManagerError.APIErrors.missingTaskID.output)?.addHeaders()
                        }
                    } else {
                        return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.castingError.output)?.addHeaders()
                    }
                } else {
                    return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.serializationError.output)?.addHeaders()
                }
            } else {
                return GCDWebServerErrorResponse(text: StockManagerError.APIErrors.castingError.output)?.addHeaders()
            }
        }
        
        
        GCDServer.main.server.addHandler(forMethod: "OPTIONS", path: "/users/get-all", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            let response = GCDWebServerDataResponse(jsonObject: [:])
            if let response = response?.addHeaders() {
                return response
            } else {
                print("Error adding headers")
            }
            return response

        }
        
        GCDServer.main.server.addHandler(forMethod: "POST", path: "/users/get-all", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in


            if let temp = request as? GCDWebServerDataRequest {
                let data = temp.data
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                    if let dict = json as? [String:Any] {
                            if let storeID = dict["storeID"] as? String {

                                let result = FirebaseWrapper.getAllUsers(storeID: storeID)
                                if let error = result.error {
                                    return GCDWebServerErrorResponse(text: error.output)?.addHeaders()
                                } else {
                                    return GCDWebServerDataResponse(jsonObject: result.users)?.addHeaders()
                                }

                            } else {
                                return GCDWebServerErrorResponse(text: StockManagerError.DatabaseErrors.missingStoreIDField.output)?.addHeaders()
                            }
                    } else {
                        return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.castingError.output)?.addHeaders()
                    }
                } else {
                    return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.serializationError.output)?.addHeaders()
                }
            } else {
                return GCDWebServerErrorResponse(text: StockManagerError.APIErrors.castingError.output)?.addHeaders()
            }
        }
             
        GCDServer.main.server.addHandler(forMethod: "OPTIONS", path: "/user/tasks/get/outstanding", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            let response = GCDWebServerDataResponse(jsonObject: [:])
            if let response = response?.addHeaders() {
                return response
            } else {
                print("Error adding headers")
            }
            return response

        }
        
        GCDServer.main.server.addHandler(forMethod: "POST", path: "/user/tasks/get/outstanding", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in

            if let temp = request as? GCDWebServerDataRequest {
                let data = temp.data
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                    if let dict = json as? [String:Any] {
                            if let storeID = dict["storeID"] as? String {
                                if let userID = dict["userID"] as? String {

                                    let result = FirebaseWrapper.getUserTasks(storeID: storeID, userID: userID)
                                    if let error = result.error {
                                        return GCDWebServerErrorResponse(text: error.output)?.addHeaders()
                                    } else {
                                        return GCDWebServerDataResponse(jsonObject: result.tasks)?.addHeaders()
                                    }

                                } else {
                                    return GCDWebServerErrorResponse(text: StockManagerError.DatabaseErrors.missingUserIDField.output)?.addHeaders()
                                }
                            } else {
                                return GCDWebServerErrorResponse(text: StockManagerError.DatabaseErrors.missingStoreIDField.output)?.addHeaders()
                            }
                    } else {
                        return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.castingError.output)?.addHeaders()
                    }
                } else {
                    return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.serializationError.output)?.addHeaders()
                }
            } else {
                return GCDWebServerErrorResponse(text: StockManagerError.APIErrors.castingError.output)?.addHeaders()
            }
        }
        
        GCDServer.main.server.addHandler(forMethod: "OPTIONS", path: "/user/tasks/get/completed", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            let response = GCDWebServerDataResponse(jsonObject: [:])
            if let response = response?.addHeaders() {
                return response
            } else {
                print("Error adding headers")
            }
            return response

        }
        
        GCDServer.main.server.addHandler(forMethod: "POST", path: "/user/tasks/get/completed", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in

            if let temp = request as? GCDWebServerDataRequest {
                let data = temp.data
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                    if let dict = json as? [String:Any] {
                            if let storeID = dict["storeID"] as? String {
                                if let userID = dict["userID"] as? String {

                                    let result = FirebaseWrapper.getUserTasksCompleted(storeID: storeID, userID: userID)
                                    if let error = result.error {
                                        return GCDWebServerErrorResponse(text: error.output)?.addHeaders()
                                    } else {
                                        return GCDWebServerDataResponse(jsonObject: result.tasks)?.addHeaders()
                                    }

                                } else {
                                    return GCDWebServerErrorResponse(text: StockManagerError.DatabaseErrors.missingUserIDField.output)?.addHeaders()
                                }
                            } else {
                                return GCDWebServerErrorResponse(text: StockManagerError.DatabaseErrors.missingStoreIDField.output)?.addHeaders()
                            }
                    } else {
                        return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.castingError.output)?.addHeaders()
                    }
                } else {
                    return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.serializationError.output)?.addHeaders()
                }
            } else {
                return GCDWebServerErrorResponse(text: StockManagerError.APIErrors.castingError.output)?.addHeaders()
            }
        }
        
        GCDServer.main.server.addHandler(forMethod: "OPTIONS", path: "/user/tasks/get/approved", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            let response = GCDWebServerDataResponse(jsonObject: [:])
            if let response = response?.addHeaders() {
                return response
            } else {
                print("Error adding headers")
            }
            return response

        }
        
        GCDServer.main.server.addHandler(forMethod: "POST", path: "/user/tasks/get/approved", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in

            if let temp = request as? GCDWebServerDataRequest {
                let data = temp.data
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                    if let dict = json as? [String:Any] {
                            if let storeID = dict["storeID"] as? String {
                                if let userID = dict["userID"] as? String {

                                    let result = FirebaseWrapper.getUserTasksApproved(storeID: storeID, userID: userID)
                                    if let error = result.error {
                                        return GCDWebServerErrorResponse(text: error.output)?.addHeaders()
                                    } else {
                                        return GCDWebServerDataResponse(jsonObject: result.tasks)?.addHeaders()
                                    }

                                } else {
                                    return GCDWebServerErrorResponse(text: StockManagerError.DatabaseErrors.missingUserIDField.output)?.addHeaders()
                                }
                            } else {
                                return GCDWebServerErrorResponse(text: StockManagerError.DatabaseErrors.missingStoreIDField.output)?.addHeaders()
                            }
                    } else {
                        return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.castingError.output)?.addHeaders()
                    }
                } else {
                    return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.serializationError.output)?.addHeaders()
                }
            } else {
                return GCDWebServerErrorResponse(text: StockManagerError.APIErrors.castingError.output)?.addHeaders()
            }
        }
        
        GCDServer.main.server.addHandler(forMethod: "OPTIONS", path: "/invitation-code/generate", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            let response = GCDWebServerDataResponse(jsonObject: [:])
            if let response = response?.addHeaders() {
                return response
            } else {
                print("Error adding headers")
            }
            return response

        }
        
        GCDServer.main.server.addHandler(forMethod: "POST", path: "/invitation-code/generate", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in

            if let temp = request as? GCDWebServerDataRequest {
                let data = temp.data
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                    if let dict = json as? [String:Any] {
                            if let storeID = dict["storeID"] as? String {
                                if let companyID = dict["companyID"] as? String {

                                    let result = FirebaseWrapper.createInvitationCode(storeID: storeID, companyID: companyID)
                                    if let error = result.error {
                                        return GCDWebServerErrorResponse(text: error.output)?.addHeaders()
                                    } else {
                                        return GCDWebServerDataResponse(jsonObject: result.codeObject)?.addHeaders()
                                    }

                                } else {
                                    return GCDWebServerErrorResponse(text: StockManagerError.DatabaseErrors.missingCompanyIDField.output)?.addHeaders()
                                }
                            } else {
                                return GCDWebServerErrorResponse(text: StockManagerError.DatabaseErrors.missingStoreIDField.output)?.addHeaders()
                            }
                    } else {
                        return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.castingError.output)?.addHeaders()
                    }
                } else {
                    return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.serializationError.output)?.addHeaders()
                }
            } else {
                return GCDWebServerErrorResponse(text: StockManagerError.APIErrors.castingError.output)?.addHeaders()
            }
        }
        
        GCDServer.main.server.addHandler(forMethod: "OPTIONS", path: "/invitation-code/revoke", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            let response = GCDWebServerDataResponse(jsonObject: [:])
            if let response = response?.addHeaders() {
                return response
            } else {
                print("Error adding headers")
            }
            return response

        }
        
        GCDServer.main.server.addHandler(forMethod: "POST", path: "/invitation-code/revoke", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            
            print(request)

            if let temp = request as? GCDWebServerDataRequest {
                let data = temp.data
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                    if let dict = json as? [String:Any] {
                            if let storeID = dict["storeID"] as? String {
                                if let companyID = dict["companyID"] as? String {
                                    if let code = dict["code"] as? String {

                                        let result = FirebaseWrapper.revokeInvitationCode(storeID: storeID, companyID: companyID, code: code)
                                        if let error = result.error {
                                            return GCDWebServerErrorResponse(text: error.output)?.addHeaders()
                                        } else {
                                            return GCDWebServerDataResponse(jsonObject: result.codeObject)?.addHeaders()
                                        }
                                            
                                        } else {
                                           return GCDWebServerErrorResponse(text: StockManagerError.DatabaseErrors.missingInvitationCode.output)?.addHeaders()
                                        }
                                } else {
                                    return GCDWebServerErrorResponse(text: StockManagerError.DatabaseErrors.missingCompanyIDField.output)?.addHeaders()
                                }
                            } else {
                                return GCDWebServerErrorResponse(text: StockManagerError.DatabaseErrors.missingStoreIDField.output)?.addHeaders()
                            }
                    } else {
                        return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.castingError.output)?.addHeaders()
                    }
                } else {
                    return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.serializationError.output)?.addHeaders()
                }
            } else {
                return GCDWebServerErrorResponse(text: StockManagerError.APIErrors.castingError.output)?.addHeaders()
            }
        }
        
        GCDServer.main.server.addHandler(forMethod: "OPTIONS", path: "/codes/get-all-valid", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            let response = GCDWebServerDataResponse(jsonObject: [:])
            if let response = response?.addHeaders() {
                return response
            } else {
                print("Error adding headers")
            }
            return response

        }
        
        GCDServer.main.server.addHandler(forMethod: "POST", path: "/codes/get-all-valid", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in


            if let temp = request as? GCDWebServerDataRequest {
                let data = temp.data
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                    if let dict = json as? [String:Any] {
                            if let storeID = dict["storeID"] as? String {

                                let result = FirebaseWrapper.getAllValidCodes(storeID: storeID)
                                if let error = result.error {
                                    return GCDWebServerErrorResponse(text: error.output)?.addHeaders()
                                } else {
                                    return GCDWebServerDataResponse(jsonObject: result.codes)?.addHeaders()
                                }

                            } else {
                                return GCDWebServerErrorResponse(text: StockManagerError.DatabaseErrors.missingStoreIDField.output)?.addHeaders()
                            }
                    } else {
                        return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.castingError.output)?.addHeaders()
                    }
                } else {
                    return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.serializationError.output)?.addHeaders()
                }
            } else {
                return GCDWebServerErrorResponse(text: StockManagerError.APIErrors.castingError.output)?.addHeaders()
            }
        }
        
        
        
        
        
        
        
        
        
            
        GCDServer.main.server.start(withPort: 9000, bonjourName: "GCD Web Server")
        
        if let serverURL = GCDServer.main.server.serverURL {
            LoggingManager.log("Visit \(serverURL) in your web browser")
        }
    }
}

extension GCDWebServerDataResponse {
    func addHeaders() -> GCDWebServerDataResponse {
        let response = self
        response.setValue("*", forAdditionalHeader: "Access-Control-Allow-Origin")
        response.setValue("GET, POST, PUT, HEAD, OPTIONS", forAdditionalHeader: "Access-Control-Allow-Methods")
        response.setValue("Content-Type", forAdditionalHeader: "Access-Control-Allow-Headers")
        response.setValue("true", forAdditionalHeader: "Access-Control-Allow-Credentials")
        print("📣 \(response)")
        return response
    }
}

