//
//  TripManager.swift
//  TripLog
//
//  Created by Julie Chien on 3/16/16.
//  Copyright © 2016 Julie Chien. All rights reserved.
//

import UIKit
import CoreLocation
private let _sharedTripManger = TripManager()

let tripStartThresholdMetersPerSec = 4.4704 // 4.4704 meters/sec, which is 10 mph
let stillnessThresholdSec = 5.0 // seconds that must pass between location updates for user to be marked as still

class TripManager: NSObject, CLLocationManagerDelegate {
    weak var viewController: LogsViewController?
    lazy var storedLocations = [CLLocation]()
    lazy var timer = NSTimer()
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    // MARK: Initialization
    static let sharedManager = TripManager()
    override private init() {
        super.init()
        print("tripmanager init called")
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .AutomotiveNavigation
        
        // movement threshold
        locationManager.distanceFilter = 10.0
        
    }
    
    // MARK: Logging starting/stopping
    func startLogging() {
        print("logging started")
        requestLocationPermission()
        startLocationUpdates()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("eachClockTick"), userInfo: nil, repeats: true)
        
    }
    
    func stopLogging() {
        print("logging stopped")
        locationManager.stopUpdatingLocation()
        timer.invalidate()
        storedLocations.removeAll()
        
    }
    
    // MARK: Updating location
    func requestLocationPermission() {
        print("requesting location permission")
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            print("Not authorized, requesting permission")
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func startLocationUpdates() {
        print("starting location updates")
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            let lastLocation = locations.last!
            
            if storedLocations.count == 0 {
                print("no stored locations, trip is starting")
                if lastLocation.speed > tripStartThresholdMetersPerSec {
                    storedLocations.append(lastLocation)
                }
                
                
            } else {
                print("stored locations exist, continuing trip " + String(lastLocation))
                storedLocations.append(lastLocation)
            }
        }
        
    }
    
    // MARK: Checking for trip stop/start
    func eachClockTick() {
        checkPosition()
    }
    
    func checkPosition() {
        // if storeLocations is nonempty, then trip has already started. we only need to check if trip has stopped
        if storedLocations.count > 0 {
            let lastLocation = storedLocations.last!
            let currentTime = NSDate()
            let elapsedTime = currentTime.timeIntervalSinceDate(lastLocation.timestamp)
            
            if elapsedTime > stillnessThresholdSec {
                print("user has been still, logging trip")
                // location hasn't been updated in 60, so user must be still
                let startLocation = storedLocations.first!
                let endLocation = storedLocations.last!
                var startAddress = ""
                var endAddress = ""
                
                let distanceTraveled = endLocation.distanceFromLocation(startLocation)
                
                if distanceTraveled > 0 {
                    
                    // Do Geocode stuff on background thread
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                        
                        let semaphore = dispatch_semaphore_create(1)
                        
                        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
                        self.geocoder.reverseGeocodeLocation(startLocation, completionHandler: { (placemarks, error) -> Void in
                            if error == nil {
                                if let placemark = placemarks?.first {
                                    startAddress = placemark.name!
                                } else {
                                    startAddress = "\(startLocation.coordinate)"
                                }
                            }
                            dispatch_semaphore_signal(semaphore)
                            
                        })
                        
                        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
                        
                        self.geocoder.reverseGeocodeLocation(endLocation, completionHandler: { (placemarks, error) -> Void in
                            if error == nil {
                                if let placemark = placemarks?.first {
                                    endAddress = placemark.name!
                                } else {
                                    endAddress = "\(endLocation.coordinate)"
                                }
                            }
                            dispatch_semaphore_signal(semaphore)
                            
                        })
                        
                        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
                        
                        // Update UI on main thread
                        dispatch_async(dispatch_get_main_queue()) {
                            print("start " + startAddress)
                            print("end " + endAddress)
                            let newLog = Log(startAddress: startAddress, endAddress: endAddress, startTime: startLocation.timestamp, endTime: endLocation.timestamp)
                            self.viewController?.addCompletedTrip(newLog)
                            
                            self.storedLocations.removeAll()
                        }
                        
                        dispatch_semaphore_signal(semaphore)
                        
                    })
                    
                }
            }
            
        }
    }
    
}
