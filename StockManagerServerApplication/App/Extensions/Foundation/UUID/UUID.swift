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
                        .trimmingCharacters(in: .symbols)
                        .prefix(20)
        )
    }
    
}
