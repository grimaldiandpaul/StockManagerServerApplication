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
    var identity: CertificateIdentity?
    var caCertificate: Certificate?
    var tlsPolicy: TLSPolicy?
    
    
    class func startup() {

        loadCertificates()

        
        // create all routes and set their handlers
        TelegraphServer.main.server.delegate = TelegraphServer.main
        TelegraphServer.main.server.route(.GET, "ramirez", serverHandleHelloDrRamirez(TelegraphServer.main))
        TelegraphServer.main.server.route(.GET, "test", serverHandleTest(TelegraphServer.main))
        TelegraphServer.main.server.route(.GET, "/", serverHandleRefPage(TelegraphServer.main))
        TelegraphServer.main.server.route(.POST, "create", serverHandleCreateItem(TelegraphServer.main))
//        server.route(.GET, "secret/*") { .forbidden }
//        server.route(.GET, "status") { (.ok, "Server is running") }
//        server.route(.POST, "data", serverHandleData)
        
        // set the maximum concurrent processes that can be handled by the server
        TelegraphServer.main.server.concurrency = 4

        LoggingManager.log(TelegraphServer.main.server.isSecure ? "is secure" : "isn't secure")
        // if the server is running
        if let _ = try? TelegraphServer.main.server.start(port: 9000, interface: "localhost") {
            LoggingManager.log("Server is running @: \(TelegraphServer.serverURL())", source: .routing, type: .success)
        } else {
            LoggingManager.log("Server is not running due to an error at startup", source: .routing, type: .error)
        }
        LoggingManager.log(TelegraphServer.main.server.isSecure ? "is secure" : "isn't secure")
        LoggingManager.log(TelegraphServer.main.server.isSecure ? "is secure" : "isn't secure")

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
    
    class func loadCertificates() {
        // Load the P12 identity package from the bundle
//        if let identityURL = Bundle.main.url(forResource: "localhost", withExtension: "p12") {
//            TelegraphServer.main.identity = CertificateIdentity(p12URL: identityURL, passphrase: "test")
//        } else {
//            LoggingManager.log("Error 1")
//        }

        // Load the Certificate Authority certificate from the bundle
        if let caCertificateURL = Bundle.main.url(forResource: "ca", withExtension: "der") {
            TelegraphServer.main.caCertificate = Certificate(derURL: caCertificateURL)
        } else {
            LoggingManager.log("Error 2")
        }

        // We want to override the default SSL handshake. We aren't using a trusted root
        // certificate authority and the hostname doesn't match the common name of the certificate.
        if let caCertificate = TelegraphServer.main.caCertificate {
            TelegraphServer.main.tlsPolicy = TLSPolicy(commonName: "localhost", certificates: [caCertificate])
        } else {
            LoggingManager.log("Error 3")
        }
            
        if let identity = TelegraphServer.main.identity, let caCertificate = TelegraphServer.main.caCertificate {
            TelegraphServer.main.server = Server(identity: identity, caCertificates: [caCertificate])
        } else {
            TelegraphServer.main.server = Server()
        }
    }
}
