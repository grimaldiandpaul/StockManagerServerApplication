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
                            if let pass = dict["password"] as? String {
                                let authenticationResult = FirebaseWrapper.authenticateUser(email: email, password: pass)
                                
                                // if the authentication process returned an error
                                if let error = authenticationResult.error {
                                    return GCDWebServerErrorResponse(text: error.output)?.addHeaders()
                                } else {
                                    
                                    // if the user is successfully authenticated
                                    if let authenticated = authenticationResult.successful,
                                        authenticated, let user = authenticationResult.user, let json = user.json {
                                        return GCDWebServerDataResponse(jsonObject: json)?.addHeaders()
                                    } else {
                                        return GCDWebServerErrorResponse(text: StockManagerError.AuthenticationErrors.invalidCredentials.output)?.addHeaders()
                                    }
                                }
                            } else {
                                
                            }
                        } else {
                            
                        }
                    } else {
                        
                    }
                } else {
                    
                }
            } else {
                
            }
            return GCDWebServerErrorResponse(text: "Hopefully we don't see this")?.addHeaders()
        }
        
            
        GCDServer.main.server.start(withPort: 9000, bonjourName: "GCD Web Server")
        
        LoggingManager.log("Visit \(GCDServer.main.server.serverURL) in your web browser")
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

