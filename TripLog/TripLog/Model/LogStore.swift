//
//  LogStore.swift
//  TripLog
//
//  Created by Julie Chien on 3/13/16.
//  Copyright © 2016 Julie Chien. All rights reserved.
//

import UIKit

class LogStore {
    var allLogs = [Log]()
    
    func addLog(newLog: Log) {
        allLogs.append(newLog)
    }
    
    init() {
        for i in 0..<5 {
            let log = Log(startAddress: String(i) + " fake st", endAddress: String(2*i) + " real ln", startTime: NSDate(timeIntervalSinceReferenceDate: Double(i)*100.0), endTime: NSDate(timeIntervalSinceReferenceDate: Double(i)*200.0))
            addLog(log)
            
        }
        print(allLogs)
    }
    
    /*
    func createLog(startAddress: String, endAddress: String, startTime: NSDate, endTime: NSDate) -> Log {
        let newLog = Log(startAddress: startAddress, endAddress: endAddress, startTime: startTime, endTime: endTime)
        allLogs.append(newLog)
        return newLog
        
    }*/
}