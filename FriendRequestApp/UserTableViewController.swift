//
//  UserTableViewController.swift
//  Digg
//
//  Created by Akkshay Khoslaa on 1/5/15.
//  Copyright (c) 2015 Akkshay Khoslaa. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    var users = [""]
    var following = [Bool]()
    var refresher:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        updateUsers()
        
        //code below initializes the refresh control and adds it above the table view
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action:"refresh", forControlEvents:UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
    }
    
    func updateUsers() {
        
        //Code below updates the users using a followers class
        var query = PFUser.query()
        
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
            
            self.users.removeAll(keepCapacity: true)
            
            for object in objects {
                
                var user:PFUser = object as PFUser
                var isFollowing:Bool
                
                if user.username != PFUser.currentUser().username {
                    
                    self.users.append(user.username)
                    isFollowing = false
                    var query = PFQuery(className:"followers")
                    query.whereKey("follower", equalTo:PFUser.currentUser().username)
                    
                    query.whereKey("following", equalTo:user.username)
                    query.findObjectsInBackgroundWithBlock {
                        (objects: [AnyObject]!, error: NSError!) -> Void in
                        if error == nil {
                            
                            for object in objects {
                                
                                isFollowing = true
                                
                            }
                            
                            self.following.append(isFollowing)
                            
                            self.tableView.reloadData()
                            
                        } else {
                            // Log details of the failure
                            println(error)
                        }
                        self.refresher.endRefreshing()
                    }
                    
                }
                
                
                
                
                
                
                
                
                
            }
            
            
        })
    }
    
    func refresh() {
        updateUsers()
        println("refreshed")
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
        return users.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        if following.count > indexPath.row {
            
            if following[indexPath.row] == true {
                
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                
            }
            
        }
        
        cell.textLabel?.text = users[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        if cell.accessoryType != UITableViewCellAccessoryType.Checkmark {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            //Once the cell is check marked, indicating that the current user has friend requested another user, the query below adds the current user to the requested user's reqeusts array
            var query = PFQuery(className:"friends")
            query.whereKey("username", equalTo:cell.textLabel?.text)
            
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    // The find succeeded.
                    NSLog("Successfully retrieved \(objects.count) records.")
                    // Do something with the found objects
                    for object in objects {
                        object.addUniqueObject(PFUser.currentUser().username, forKey: "requests")
                        object.saveInBackgroundWithTarget(nil, selector: nil)
                    }
                } else {
                    // Log details of the failure
                    NSLog("Error: %@ %@", error, error.userInfo!)
                }
            }
        
        }
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
