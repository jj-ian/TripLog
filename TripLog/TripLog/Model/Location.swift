//
//  Location.swift
//  TripLog
//
//  Created by Julie Chien on 3/15/16.
//  Copyright © 2016 Julie Chien. All rights reserved.
//

import Foundation
import CoreData


class Location: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        address = ""
        latitude = -1
        longitude = -1
        
    }

}
