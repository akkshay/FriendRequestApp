//
//  ViewController.swift
//  Digg
//
//  Created by Akkshay Khoslaa on 1/4/15.
//  Copyright (c) 2015 Akkshay Khoslaa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title:String, dispError:String) { //Function to display alerts for erorrs in sign up form
        var alert = UIAlertController(title: "Error in form", message: dispError, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var uname: UITextField!
    @IBOutlet weak var pword: UITextField!
    @IBOutlet weak var verifyPword: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBAction func signUp(sender: AnyObject) {
        
        //The code below checks if the sign up form has been filled out properly
        
        var dispError = "Please enter a "
        
        if uname.text == "" {
            dispError += "username"
        }
        if pword.text == "" {
            if dispError != "Please enter a " {
                dispError += ", password"
            } else {
                dispError += "password"
            }
        }
        if email.text == "" {
            if dispError != "Please enter a " {
                dispError += ", email"
            } else {
                dispError += "email"
            }
        }
        if verifyPword.text == "" {
            if dispError != "Please enter a " {
                dispError += ", and verify your password"
            } else {
                dispError = "Please verify your password"
            }
        }
       
        if dispError != "Please enter a " {
            
            displayAlert("Incomplete Form", dispError: dispError)
            
        //The code below registers the user if the signup form has no mistakes
            
        } else {
            var user = PFUser()
            user.username = uname.text
            user.password = pword.text
            user.email = email.text
            // other fields can be set just like with PFObject
            
            //The code below adds a scrolling circle to indicate that the app is doing work
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool!, signupError: NSError!) -> Void in
                
                self.activityIndicator.stopAnimating() //Stops the scrolling circle as action has been completed
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if signupError == nil {
                    // The user is properly registered and may now use the app
                    var friendRecord = PFObject(className: "friends")
                    friendRecord["username"] = self.uname.text
                    friendRecord.saveInBackgroundWithTarget(nil, selector: nil)

                    self.performSegueWithIdentifier("jumpToUserTableFromSignup", sender: self)
                } else {
                    
                    //Thee code below handles errors if the user was not properly registered
                    
                    if let errorString = signupError.userInfo?["error"] as? NSString {
                        dispError = errorString
                    } else {
                        dispError = "Please try again later"
                    }
                    self.displayAlert("Could Not Sign Up", dispError: dispError)}
            }
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
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(animated: Bool) {
        
        //The code below takes the user into the app if they are logged in. It does not require users to log in everytime the app is opened.
        
        if PFUser.currentUser() != nil {
            self.performSegueWithIdentifier("jumpToUserTableFromSignup", sender: self)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

