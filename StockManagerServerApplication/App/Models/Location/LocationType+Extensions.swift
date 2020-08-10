//
//  File.swift
//  
//
//  Created by Joe Paul on 5/23/20.
//

import Foundation

extension LocationType{
    
    var value: String {
        switch self {
        case .jHook:
            return "JHook"
        case .sideStack:
            return "Side Stack"
        case .shelfSpace:
            return "Shelf Space"
        case .pod:
            return "Pod"
        case .floorModel:
            return "Floor Model"
        case .topStock:
            return "Top Stock"
        case .backroomStock:
            return "Backroom Stock"
        case .incoming:
             return "Incoming"
        case .outgoing:
            return "Outgoing"
        case .unprocessed:
            return "Unprocessed"
        case .bottomStock:
            return "Bottom Stock"
        case .unknown:
            return "Unknown"
            
        //Cases are exhaustive, no default needed
        }
    }
    
    var plural: String {
        switch self {
        case .jHook:
            return "JHooks"
        case .sideStack:
            return "Side Stacks"
        case .shelfSpace:
            return "Shelf Spaces"
        case .pod:
            return "Pods"
        case .floorModel:
            return "Floor Models"
        case .topStock:
            return "Top Stock"
        case .backroomStock:
            return "Backroom Stock"
        case .incoming:
             return "Incoming"
        case .outgoing:
            return "Outgoing"
        case .unprocessed:
            return "Unprocessed"
        case .bottomStock:
            return "Bottom Stock"
        case .unknown:
            return "Unknown"
            
        //Cases are exhaustive, no default needed
        }
    }
    
    static func from(_ string: String) throws -> LocationType {
        switch string {
        case "JHook", "JHooks":
            return .jHook
        case "Side Stack", "Side Stacks":
            return .sideStack
        case "Shelf Space", "Shelf Spaces":
            return .shelfSpace
        case "Pod", "Pods":
            return .pod
        case "Floor Model", "Floor Models":
            return .floorModel
        case "Top Stock", "Top Stock Items":
            return .topStock
        case "Backroom Stock", "Backroom Stock Items":
            return .backroomStock
        case "Incoming", "Incoming Items":
            return .incoming
        case "Outgoing", "Outgoing Items":
            return .outgoing
        case "Unprocessed", "Unprocessed Items":
            return .unprocessed
        case "Bottom Stock", "Bottom Stock Items":
            return .bottomStock
        case "Unknown", "Unknown Location":
            return .unknown
        default:
            throw ModelErrors.illegalLocationType
            
        }
    }
    
    static func all() -> [LocationType] {
        return [.jHook, .sideStack, .shelfSpace, .pod, .floorModel, .topStock, .backroomStock, .incoming, .outgoing, .unprocessed, .bottomStock, .unknown]
    }
}
