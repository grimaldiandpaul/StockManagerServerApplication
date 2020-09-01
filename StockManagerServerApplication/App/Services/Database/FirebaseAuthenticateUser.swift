//
//  FirebaseAuthenticateUser.swift
//  StockManagerServerApplication
//
//  Created By Zachary Grimaldi and Joseph Paul on 8/18/20.
//

import Foundation
import Firebase

/// An extension for our FirebaseWrapper singleton
extension FirebaseWrapper {
    
    /// A static function that synchronously authenticates a user email and password
    /// - Parameter email: the user's email
    /// - Parameter password: the user's password
    /// - Returns:FirebaseWrapperAuthenticationResult = (error: StockManagerError?, successful: Bool?, user: Data?)
    class func authenticateUser(email: String, password: String) -> FirebaseWrapperAuthenticationResult {
        
        var error: StockManagerError? = nil
        var authenticationResult: Bool? = nil
        var user: Data? = nil
        
        #warning("this will need fixed on mac mini")
        let file = "/Users/joepauljoe/Downloads/keyandiv.txt"
        let path = URL(fileURLWithPath: file)
        if var iv = try? String(contentsOf: path){
            var key = String(iv.prefix(while: {$0 != "\n"}))
            while iv.contains("\n"){
                iv = String(iv.dropFirst())
            }
            print(key)
            print(iv)
            let encrypted = try! password.encrypt(key: key, iv: iv)
            print(encrypted)
            let decrypted = try! encrypted.decrypt(key: key, iv: iv)
            
            print(decrypted)
        }
        
        return (error, authenticationResult, user)
    }
    
    
}
