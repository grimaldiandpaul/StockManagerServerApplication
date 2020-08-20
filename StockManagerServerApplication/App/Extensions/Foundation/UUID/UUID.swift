//
//  UUID.swift
//  StockManagerServerApplication
//
//  Created By Zachary Grimaldi and Joseph Paul on 8/11/20.
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
