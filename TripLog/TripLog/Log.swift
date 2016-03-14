//
//  Log.swift
//  TripLog
//
//  Created by Julie Chien on 3/13/16.
//  Copyright © 2016 Julie Chien. All rights reserved.
//

import UIKit

class Log: NSObject {
    var startAddress: String
    var endAddress: String
    var startTime: NSDate
    var endTime: NSDate
    var timeElapsed: NSTimeInterval
    
    init(startAddress: String, endAddress: String, startTime: NSDate, endTime: NSDate) {
        self.startAddress = startAddress
        self.endAddress = endAddress
        self.startTime = startTime
        self.endTime = endTime
        self.timeElapsed = endTime.timeIntervalSinceDate(startTime)
        
        super.init()
    }

}
