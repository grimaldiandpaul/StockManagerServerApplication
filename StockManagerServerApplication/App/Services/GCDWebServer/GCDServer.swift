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
            print("GOT HERE")
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
            print("GOT HERE")
            print(request)
            let response = GCDWebServerDataResponse(jsonObject: ["Hello":"Dr. Ramirez"])
            if let response = response?.addHeaders() {
                return response
            } else {
                print("Error adding headers")
            }
            return response
        }
        
        GCDServer.main.server.addHandler(forMethod: "OPTIONS", path: "/test-authenticate", request: GCDWebServerDataRequest.self) { request -> GCDWebServerDataResponse? in
            let response = GCDWebServerDataResponse(jsonObject: [:])
            if let response = response?.addHeaders() {
                return response
            } else {
                print("Error adding headers")
            }
            return response
            
        }
        
        GCDServer.main.server.addHandler(forMethod: "POST", path: "/test-authenticate", request: GCDWebServerDataRequest.self) { request -> GCDWebServerDataResponse? in
            let user = User(userID: "26aIVUDhylb1Ht01vXWC", firstName: "Joseph", lastName: "Paul", email: "josephpaul3820@gmail.com", storeID: "Test Store 1", companyID: "TestCom3", lastLoginDate: Timestamp(date: Date()).seconds, ipAddresses: ["192.168.0.253"], userRole: .admin)
            let json = user.json
            let response = GCDWebServerDataResponse(jsonObject: json)
            if let response = response?.addHeaders() {
                return response
            } else {
                print("Error adding headers")
            }
            return response
            
        }
        
        GCDServer.main.server.addHandler(forMethod: "OPTIONS", path: "/authenticate", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            let response = GCDWebServerDataResponse(jsonObject: [:])
            if let response = response?.addHeaders() {
                return response
            } else {
                print("Error adding headers")
            }
            return response

        }
        
        GCDServer.main.server.addHandler(forMethod: "POST", path: "/authenticate", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            
            if let temp = request as? GCDWebServerDataRequest {
                let data = temp.data
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                    if let dict = json as? [String:Any] {
                        if let email = dict["email"] as? String {
                            if let pass = dict["password"] as? String, pass.count > 0 {
                                let authenticationResult = FirebaseWrapper.authenticateUser(email: email, password: pass)
                                
                                // if the authentication process returned an error
                                if let error = authenticationResult.error {
                                    return GCDWebServerErrorResponse(text: error.output)?.addHeaders()
                                } else {
                                    
                                    // if the user is successfully authenticated
                                    if let authenticated = authenticationResult.successful,
                                        authenticated, let user = authenticationResult.user {
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
        
        
        
        
        
        
        
        
        
        
        
        GCDServer.main.server.addHandler(forMethod: "OPTIONS", path: "/create", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            let response = GCDWebServerDataResponse(jsonObject: [:])
            if let response = response?.addHeaders() {
                return response
            } else {
                print("Error adding headers")
            }
            return response

        }
        
        GCDServer.main.server.addHandler(forMethod: "POST", path: "/create", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            
            if let temp = request as? GCDWebServerDataRequest {
                let data = temp.data
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                    if let dict = json as? [String:Any] {
                        if let email = dict["email"] as? String {
                            if let pass = dict["password"] as? String, pass.count > 0 {
                                if let fname = dict["firstName"] as? String {
                                    if let lname = dict["LastName"] as? String {
                                        if let invitationCode = dict["invitationCode"] as? String {
                                        
                                    
                                    
                                    
                                    
                                        }
                                    }
                                }
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                let authenticationResult = FirebaseWrapper.authenticateUser(email: email, password: pass)
                                
                                // if the authentication process returned an error
                                if let error = authenticationResult.error {
                                    return GCDWebServerErrorResponse(text: error.output)?.addHeaders()
                                } else {
                                    
                                    // if the user is successfully authenticated
                                    if let authenticated = authenticationResult.successful,
                                        authenticated, let user = authenticationResult.user {
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
        return response
    }
}

