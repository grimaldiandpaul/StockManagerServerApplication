//
//  TelegraphServer.swift
//  StockManagerServerApplication
//
//  Created By Zachary Grimaldi and Joseph Paul on 8/11/20.
//

import Foundation
import Telegraph

class TelegraphServer {
    static let main = TelegraphServer()
    var server: Server = Server()
    
    class func startup() {

        
        // create all routes and set their handlers
        TelegraphServer.main.server.delegate = TelegraphServer.main
        TelegraphServer.main.server.route(.GET, "ramirez", serverHandleHelloDrRamirez(TelegraphServer.main))
        TelegraphServer.main.server.route(.GET, "/", serverHandleRefPage(TelegraphServer.main))
        TelegraphServer.main.server.route(.POST, "create", serverHandleCreateItem(TelegraphServer.main))
        TelegraphServer.main.server.route(.POST, "authenticate", serverHandleAuthenticate(TelegraphServer.main))
//        server.route(.GET, "secret/*") { .forbidden }
//        server.route(.GET, "status") { (.ok, "Server is running") }
//        server.route(.POST, "data", serverHandleData)
        
        // set the maximum concurrent processes that can be handled by the server
        TelegraphServer.main.server.concurrency = 4

        // if the server is running
        if let _ = try? TelegraphServer.main.server.start(port: 9000, interface: "localhost") {
            LoggingManager.log("Server is running @: \(TelegraphServer.serverURL())", source: .routing, type: .success)
        } else {
            LoggingManager.log("Server is not running due to an error at startup", source: .routing, type: .error)
        }

    }
    
    /// function for creating the server URL
    /// - Parameter path: the path string for the url
    /// - Parameter storeID: the unique identifier of the store to add the item to
    /// - Returns: A URL object for the server
    private class func serverURL(path: String = "") -> URL {
      var components = URLComponents()
      components.scheme = TelegraphServer.main.server.isSecure ? "https" : "http"
      components.host = "localhost"
      components.port = Int(TelegraphServer.main.server.port)
      components.path = path
      return components.url!
    }
}
