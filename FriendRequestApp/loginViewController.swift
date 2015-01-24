//
//  loginViewController.swift
//  Digg
//
//  Created by Akkshay Khoslaa on 1/5/15.
//  Copyright (c) 2015 Akkshay Khoslaa. All rights reserved.
//

import UIKit

class loginViewController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title:String, dispError:String) {
        
        //code below is used to display pop-up alerts
        var alert = UIAlertController(title: "Error in form", message: dispError, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    @IBOutlet weak var login_uname: UITextField!
    @IBOutlet weak var login_pword: UITextField!
    
    @IBAction func logIn(sender: AnyObject) {
        
        //code below makes sure that all the fields are filled out, and displays the appropriate error if they aren't
        var dispError = ""
        if login_uname.text == "" && login_pword.text == "" {
            dispError = "Please enter a username and password"
        } else if login_uname.text == "" {
            dispError = "Please enter a username"
        } else if login_pword.text == "" {
            dispError = "Please enter a password"
        }
        
        if dispError != "" {
            displayAlert("Error in form", dispError: dispError)
            
        } else {
            
            var user = PFUser()
            user.username = login_uname.text
            user.password = login_pword.text
            
            //code below shows a scrolling circle to indicate the app is doing work
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            //the code below logs in the user with parse backend
            PFUser.logInWithUsernameInBackground(login_uname.text, password:login_pword.text) {
                (user: PFUser!, signupError: NSError!) -> Void in
                
                if signupError == nil {
                    
                    self.performSegueWithIdentifier("jumpToUserTableFromLogin", sender: self)
                    println("Signed up")
                    
                } else {
                    
                    if let errorString = signupError.userInfo?["error"] as? NSString {
                        dispError = errorString
                    } else {
                        dispError = "Please try again later"
                    }
                    self.displayAlert("Could Not Sign Up", dispError: dispError)
                    
                }
            }
        }

    }
   override func viewDidAppear(animated: Bool) {
        
        //The code below takes the user into the app if they are logged in. It does not require users to log in everytime the app is opened.
        if PFUser.currentUser() != nil {
            self.performSegueWithIdentifier("jumpToUserTableFromLogin", sender: self)
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
