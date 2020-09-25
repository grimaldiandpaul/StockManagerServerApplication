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
        
        GCDServer.main.server.addHandler(forMethod: "OPTIONS", path: "/ramirez", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            //let get = request as! GCDWebServerMultiPartFormRequest
            //print(get)
            print(request)
            let response = GCDWebServerDataResponse(jsonObject: ["Hello":"Dr. Ramirez"])
            if let response = response?.addHeaders() {
                return response
            } else {
                print("Error adding headers")
            }
            return response
        }
        
        GCDServer.main.server.addHandler(forMethod: "POST", path: "/ramirez", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            print(request)
            let response = GCDWebServerDataResponse(jsonObject: ["Hello":"Dr. Ramirez"])
            if let response = response?.addHeaders() {
                return response
            } else {
                print("Error adding headers")
            }
            return response
        }
        
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
            
            print(request)
            
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
            
            print(request)
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
            
            print(request)
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
//                                    let json = [id:image]
//                                    return GCDWebServerDataResponse(jsonObject: json)?.addHeaders()
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
                                        return GCDWebServerErrorResponse(text: "Success")?.addHeaders()
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

