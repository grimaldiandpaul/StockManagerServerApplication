//
//  GCDWebServer.swift
//  StockManagerServerApplication
//
//  Created by Zachary Grimaldi and Joseph Paul on 8/24/20.
//

import Foundation
import GCDWebServer

class GCDServer {
    
    static let main = GCDServer()
    var server = GCDWebServer()
    
    class func startup() {
        GCDServer.main.server.addDefaultHandler(forMethod: "GET", request: GCDWebServerRequest.self, processBlock: {request in
                return GCDWebServerDataResponse(html:"<html><body><p>Hello World</p></body></html>")
                
            })
        
        GCDServer.main.server.addHandler(forMethod: "GET", path: "/ramirez", request: GCDWebServerRequest.self) { (request) -> GCDWebServerResponse? in
            return GCDWebServerDataResponse(jsonObject: ["Hello":"Dr. Ramirez"])
        }
        
        GCDServer.main.server.addHandler(forMethod: "GET", path: "/ramirez2", request: GCDWebServerRequest.self) { (request) -> GCDWebServerResponse? in
            return GCDWebServerDataResponse(statusCode: 200).addHeaders()
        }
            
        GCDServer.main.server.start(withPort: 9000, bonjourName: "GCD Web Server")
        
        LoggingManager.log("Visit \(GCDServer.main.server.serverURL) in your web browser")
    }
}

extension GCDWebServerDataResponse {
    func addHeaders() -> GCDWebServerDataResponse {
        let response = self
        response.setValue("*", forAdditionalHeader: "Access-Control-Allow-Origin")
        return response
    }
}

