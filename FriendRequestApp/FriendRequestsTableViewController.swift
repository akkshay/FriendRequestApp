//
//  FriendRequestsTableViewController.swift
//  Digg
//
//  Created by Akkshay Khoslaa on 1/8/15.
//  Copyright (c) 2015 Akkshay Khoslaa. All rights reserved.
//

import UIKit

class FriendRequestsTableViewController: UITableViewController {
    
    var requests = [String]()
    var refresher:UIRefreshControl!
    
    func updateRequests() {
        
        //function updates the user's friend requests by querying the friends class
        var query = PFQuery(className:"friends")
        query.whereKey("username", equalTo:PFUser.currentUser().username)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                NSLog("Successfully retrieved \(objects.count) records.")
                // Do something with the found objects
                for object in objects {
                    if object["requests"]! != nil {
                        self.requests = object["requests"]! as Array
                    }
                    
                    self.tableView.reloadData()
                }
                
            } else {
                // Log details of the failure
            }
            self.refresher.endRefreshing()
        }
        
    }
   
    func refresh() {
        updateRequests()
        println("refreshed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateRequests()
        
        //code below initializes the refresher control and adds it to the table view
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action:"refresh", forControlEvents:UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.requests.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //creates each cell using the requestsTableCell class. We downcast cell to a requestsTableCell so we may modify textLabel2
        var cell = self.tableView.dequeueReusableCellWithIdentifier("requestsTableCell") as requestsTableCell
        cell.textLabel2?.text = requests[indexPath.row]
    
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
