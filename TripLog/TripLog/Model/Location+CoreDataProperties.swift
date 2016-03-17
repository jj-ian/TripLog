//
//  Location+CoreDataProperties.swift
//  TripLog
//
//  Created by Julie Chien on 3/15/16.
//  Copyright © 2016 Julie Chien. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Location {

    @NSManaged var address: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?

}
