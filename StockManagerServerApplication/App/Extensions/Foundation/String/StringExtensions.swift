//
//  StringExtensions.swift
//  StockManagerServerApplication
//
//  Created by Zachary Grimaldi and Joseph Paul on 9/1/20.
//

import Foundation
import CryptoSwift

extension String {
    func encrypt(key: String, iv: String) throws -> String {
        let securedBytes = try AES(key: key, iv: iv, padding: .pkcs7).encrypt([UInt8](self.data(using: .utf8)!))
        return Data(securedBytes).base64EncodedString()
    }

    func decrypt(key: String, iv: String) throws -> String {
        if let data = Data(base64Encoded: self){
            let decryptedBytes = try AES(key: key, iv: iv, padding: .pkcs7).decrypt([UInt8](data))
            return String(bytes: decryptedBytes, encoding: .utf8) ?? ""
        } else {
            return ""
        }
    }
}
