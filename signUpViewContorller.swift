//
//  signUpViewContorller.swift
//  Firebase test2 Auth
//
//  Created by Johnny' mac on 2016/5/24.
//  Copyright © 2016年 Johnny' mac. All rights reserved.
//

import UIKit
import Firebase




class signUpViewContorller: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var databaseRef: FIRDatabaseReference!
    // setup alert
    func errorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func sccuessAlert(title: String, message:String){
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
    presentViewController(alert, animated: true, completion: nil)
    
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
     databaseRef = FIRDatabase.database().reference()
    
    }
    
    @IBAction func touchDidSignUp(sender: AnyObject) {
    let username = self.usernameField.text
    let email = self.emailField.text
    let password = self.passwordField.text
    //refresh textfiled
    let finalemail = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    let finalpassword = password!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    let finalusername = username?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    // verify signup information
        if username!.characters.count<5 {
            self.errorAlert("Opps!", message: "username must longer than 5 characters!")
        } else if email!.characters.count<8 {
            self.errorAlert("Opps!", message: "Please enter vaild email address!")
        }else if password!.characters.count<8{
        self.errorAlert("Opps!", message: "Your password must larger than 8 characters!")
        
        }
        else {
        // set spinner
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView()as UIActivityIndicatorView
            spinner.activityIndicatorViewStyle = .WhiteLarge
            spinner.center = view.center
            self.view.addSubview(spinner)
            spinner.startAnimating()
           FIRAuth.auth()?.createUserWithEmail(email!, password: password!){(user,error) in
           self.databaseRef.child("users").child(user!.uid).setValue(["username": username!])
            spinner.stopAnimating()
            if let error = error{
                self.errorAlert("Opps!", message:"\(error.localizedDescription)")
                }else{
                
                self.sccuessAlert("Sccuess", message: "User created!")
                

                    dispatch_async(dispatch_get_main_queue(), {()-> Void in
                        let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("Home")
                        UIApplication.sharedApplication().keyWindow?.rootViewController = loginViewController
                    })
                    }
                
            }
        
        }
    }
    
    func textFieldShouldReturn(textFiled: UITextField) ->Bool{
    textFiled.resignFirstResponder()
    return true
    }
    }
