//
//  LogsViewController.swift
//  TripLog
//
//  Created by Julie Chien on 3/13/16.
//  Copyright © 2016 Julie Chien. All rights reserved.
//

import UIKit
import CoreLocation

class LogsViewController: UITableViewController, CLLocationManagerDelegate {
    let carImageName = "icon_car.png"
    let carImageScale = 0.5
    var logStore: LogStore!

    // MARK: Toggle
    @IBOutlet weak var tripLogToggle: UISwitch!
    
    
    @IBAction func toggleTripLoggingMode(sender: UISwitch) {
        if tripLogToggle.on {
            print("switch turned on")
            TripManager.sharedManager.startLogging()
        } else {
            print("switch turned off")
            TripManager.sharedManager.stopLogging()
            
        }
    }
    
    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()

        // get height of status bar
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        TripManager.sharedManager.viewController = self
        if tripLogToggle.on {
            TripManager.sharedManager.startLogging()
        }
        
    }

    // MARK: - Table view data source
    
    func addCompletedTrip(newLog: Log) {
        self.logStore.addLog(newLog)
        tableView.reloadData()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logStore.allLogs.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)

        // Set text on the cell with the description of the log that's at the nth index of logs, where n = row this cell will appear in on the tableview
        let log = logStore.allLogs[indexPath.row]
        
        cell.textLabel?.text = log.startAddress + " > " + log.endAddress
        
        // shows times in 12- or 24-hour clock depending on device locale
        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle
        
        let seconds = round(log.timeElapsed)
        let timeElapsedMin = Int(round((seconds % 3600) / 60));
        
        cell.detailTextLabel?.text = formatter.stringFromDate(log.startTime) + " - " + formatter.stringFromDate(log.endTime) + " (" + String(timeElapsedMin) + "min)"
        
        if var carImage = UIImage(named: carImageName) {
        carImage = imageWithImage(carImage, scaledToSize: CGSize( width: Double(carImage.size.width) * carImageScale, height: Double(carImage.size.height) * carImageScale))
            cell.imageView?.image = carImage
        }
        
        return cell
    }
    
    // MARK: Misc
    // resizing image, pulled from StackOverflow
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    


}
