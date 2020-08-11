//
//  TelegraphServer.swift
//  StockManagerServerApplication
//
//  Created by Joe Paul on 8/11/20.
//

import Foundation
import Telegraph

class TelegraphServer {
    static let main = TelegraphServer()
    var server: Server = Server()
    
    class func startup() {

        TelegraphServer.main.server.delegate = TelegraphServer.main
        
        TelegraphServer.main.server.route(.GET, "helloDrRamirez", serverHandleHelloDrRamirez(TelegraphServer.main))
//        server.route(.GET, "hello(/)", serverHandleHello)
//        server.route(.GET, "redirect", serverHandleRedirect)
//        server.route(.GET, "secret/*") { .forbidden }
//        server.route(.GET, "status") { (.ok, "Server is running") }
//        server.route(.POST, "data", serverHandleData)

        TelegraphServer.main.server.serveBundle(.main, "/")
        
        TelegraphServer.main.server.concurrency = 4

        if let _ = try? TelegraphServer.main.server.start(port: 9000, interface: "localhost") {
            LoggingManager.log("Server is running @: \(TelegraphServer.serverURL())", source: .routing, type: .success)
        } else {
            LoggingManager.log("Server is not running due to an error at startup", source: .routing, type: .error)
        }

    }
    
    private class func serverURL(path: String = "") -> URL {
      var components = URLComponents()
      components.scheme = TelegraphServer.main.server.isSecure ? "https" : "http"
      components.host = "localhost"
      components.port = Int(TelegraphServer.main.server.port)
      components.path = path
      return components.url!
    }
}
