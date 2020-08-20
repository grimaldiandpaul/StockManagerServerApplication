//
//  DateExtensions.swift
//  StockManagerWebServer
//
//  Created By Zachary Grimaldi and Joseph Paul on 8/10/20.
//  Copyright © 2020 Zachary Grimaldi. All rights reserved.
//

import Foundation


extension Date {
    var sweeperOutputString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss-a"
        return dateFormatter.string(from: self)
    }
    
    var viewOutputString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:Z"
        return dateFormatter.string(from: self)
    }
}
