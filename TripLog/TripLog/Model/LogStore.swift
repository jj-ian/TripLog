//
//  LogStore.swift
//  TripLog
//
//  Created by Julie Chien on 3/13/16.
//  Copyright © 2016 Julie Chien. All rights reserved.
//

import UIKit

// Interface to the Log database
class LogStore {
    
    // I was going to replace this with Core Data but ran out of time
    var allLogs = [Log]()
    
    func addLog(newLog: Log) {
        allLogs.insert(newLog, atIndex: 0)
    }
    
    
}