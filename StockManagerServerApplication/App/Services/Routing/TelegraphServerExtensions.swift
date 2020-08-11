//
//  TelegraphServerExtensions.swift
//  StockManagerServerApplication
//
//  Created by Joe Paul on 8/11/20.
//

import Foundation
import Telegraph

extension TelegraphServer: ServerDelegate {
  // Raised when the server gets disconnected.
  public func serverDidStop(_ server: Server, error: Error?) {
    LoggingManager.log("Server stopped:" + (error?.localizedDescription ?? "No details"), source: .routing, type: .error)
  }
}
