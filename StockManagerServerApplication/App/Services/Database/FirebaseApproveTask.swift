//
//  FirebaseUpdateItem.swift
//  StockManagerServerApplication
//
//  Created by Zachary Grimaldi and Joseph Paul on 10/28/20.
//

import Foundation
import Firebase

/// An extension for our FirebaseWrapper class that contains the static function for approving a task
extension FirebaseWrapper {
    
    /// static function for APPROVING a task
    /// - Parameter storeID: the unique identifier of the store to add the item to
    /// - Parameter taskID: the unique identifier of the task
    /// - Returns: A FirebaseWrapperTaskOperationResult (type-aliased from the tuple:  (error: String?, task: [String:Any]) )
    class func approveTask(storeID: String, taskID: String) -> FirebaseWrapperTaskOperationResult {
        #warning("check if store exists")
        let semaphore = DispatchSemaphore(value: 0)
        var taskJSON = [String:Any]()
        
        var error: StockManagerError? = nil
            
        // get the task document
        FirebaseWrapper.taskReference(storeID: storeID, taskID: taskID).getDocument { (doc, err) in
            if (!(doc?.exists ?? false)) {
                error = StockManagerError.DatabaseErrors.noTaskResultsFound
                semaphore.signal()
            } else {
                // update the item document from Firebase Cloud Firestore
                if let doc = doc {
                    if let json = doc.data() {
                        taskJSON = json
                    }
                }
                taskJSON["timeApproved"] = Timestamp(date: Date()).seconds
                FirebaseWrapper.taskReference(storeID: storeID, taskID: taskID).updateData(taskJSON)
                
                // update the location of the inventory item
                if let userDesignatedID = taskJSON["userDesignatedID"] as? String {
                    // check to see if the document exists
                    FirebaseWrapper.itemReference(itemUUIDString: userDesignatedID, storeID: storeID).getDocument { (snapshot, err) in
                        if (!(snapshot?.exists ?? false)) {
                            error = StockManagerError.DatabaseErrors.noItemResultsFound
                            semaphore.signal()
                        } else {
                            // update the item document from Firebase Cloud Firestore
                            if let snapshot = snapshot {
                                if var data = snapshot.data(), let locations = data["locations"] as? [[String:String]] {
                                    if let src = taskJSON["src"] as? [String:Any], let srcAisle = src["aisle"] as? String {
                                        if let srcAisleSection = src["aisleSection"] as? String {
                                            if let srcSpot = taskJSON["spot"] as? String {
                                                if let dest = taskJSON["dest"] as? [String:Any] {
                                                    
                                                    var locs = [Location]()
                                                    var needsToBeAdded = true
                                                    for location in locations {
                                                        let loc = Location.from(location)
                                                        if loc.aisle == srcAisle && loc.aisleSection == srcAisleSection && loc.spot == srcSpot {
                                                            locs.append(Location.from(dest))
                                                            needsToBeAdded = false
                                                        } else {
                                                            locs.append(loc)
                                                        }
                                                    }
                                                    if needsToBeAdded {
                                                        locs.append(Location.from(dest))
                                                    }
                                                    
                                                    data["locations"] = locs.map({$0.json})
                                                    FirebaseWrapper.itemReference(itemUUIDString: userDesignatedID, storeID: storeID).updateData(data)
                                                    semaphore.signal()
                                                
                                                } else {
                                                    error = StockManagerError.ModelErrors.illegalLocationType
                                                    semaphore.signal()
                                                }
                                            } else {
                                                error = StockManagerError.ModelErrors.illegalLocationType
                                                semaphore.signal()
                                            }
                                        } else {
                                            error = StockManagerError.ModelErrors.illegalLocationType
                                            semaphore.signal()
                                        }
                                    } else {
                                        error = StockManagerError.ModelErrors.illegalLocationType
                                        semaphore.signal()
                                    }
                                } else {
                                    error = StockManagerError.APIErrors.castingError
                                    semaphore.signal()
                                }
                            } else {
                                error = StockManagerError.DatabaseErrors.connectionError
                                semaphore.signal()
                            }
                        }
                    }
                } else {
                    error = StockManagerError.DatabaseErrors.noItemResultsFound
                    semaphore.signal()
                }
                
                
                semaphore.signal()
            }
        }
            
        let _ = semaphore.wait(wallTimeout: .distantFuture)
            
        return (error,taskJSON)
            
    }
    
    
}
