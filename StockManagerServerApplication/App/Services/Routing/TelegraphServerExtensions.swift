//
//  TelegraphServerExtensions.swift
//  StockManagerServerApplication
//
//  Created By Zachary Grimaldi and Joseph Paul on 8/11/20.
//

import Foundation
import Telegraph

/// An extension for Telegraph's TelegraphServer object
extension TelegraphServer: ServerDelegate {
  // Raised when the server gets disconnected.
  public func serverDidStop(_ server: Server, error: Error?) {
    LoggingManager.log("Server stopped:" + (error?.localizedDescription ?? "No details"), source: .routing, type: .error)
  }
}
