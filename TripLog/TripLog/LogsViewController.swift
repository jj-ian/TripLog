//
//  LogsViewController.swift
//  TripLog
//
//  Created by Julie Chien on 3/13/16.
//  Copyright © 2016 Julie Chien. All rights reserved.
//

import UIKit
import CoreLocation
//import CoreData

class LogsViewController: UITableViewController, CLLocationManagerDelegate {
    
    var logStore: LogStore!
    
    @IBAction func toggleTripLoggingMode(sender: AnyObject) {
        
        // if turned on
        //self
       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // get height of status bar
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        TripManager.sharedManager.viewController = self
        TripManager.sharedManager.startLogging()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
       // timer.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addCompletedTrip(newLog: Log) {
        self.logStore.addLog(newLog)
        tableView.reloadData()
    }
    


    // MARK: - Table view data source
/*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
*/
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(logStore.allLogs.count)
        return logStore.allLogs.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)

        // Set text on the cell with the description of the log that's at the nth index of logs, where n = row this cell will appear in on the tableview
        let log = logStore.allLogs[indexPath.row]
        print(log.startAddress)
        
        cell.textLabel?.text = log.startAddress + " > " + log.endAddress
        
        // shows times in 12- or 24-hour clock depending on device locale
        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle
        
        let seconds = round(log.timeElapsed)
        let timeElapsedMin = Int(round((seconds % 3600) / 60));
        
        cell.detailTextLabel?.text = formatter.stringFromDate(log.startTime) + " - " + formatter.stringFromDate(log.endTime) + " (" + String(timeElapsedMin) + "min)"
        
        cell.imageView?.image = UIImage(named: "icon_car.png")
        
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
