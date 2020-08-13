//
//  UUID.swift
//  StockManagerServerApplication
//
//  Created by Zachary Grimaldi on 8/11/20.
//

import Foundation

extension UUID {
    
    static var uuidStringTwentyCharsNoDashes: String {
        return String( (UUID().uuidString + UUID().uuidString)
                        .filter({$0 != "-"})
                        .prefix(20)
        )
    }
    
}
