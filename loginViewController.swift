//
//  loginViewController.swift
//  Firebase test2 Auth
//
//  Created by Johnny' mac on 2016/5/24.
//  Copyright © 2016年 Johnny' mac. All rights reserved.
//

import UIKit
import Firebase

class loginViewController: UIViewController {
   
    @IBOutlet weak var passWordField: UITextField!
   
    @IBOutlet weak var emailField: UITextField!
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

    @IBAction func tapDidLogin(sender: AnyObject) {
        var email = self.emailField.text
        var password = self.passWordField.text
        email = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        password = password!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if email!.characters.count<8{
        self.errorAlert("Opps!", message: "please type vaild email!")
        } else if password!.characters.count<8{
        self.errorAlert("Opps!", message: "Please type vaild password!")
        
        } else{
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,80,80)) as UIActivityIndicatorView
            self.view.addSubview(spinner)
            spinner.startAnimating()
            FIRAuth.auth()?.signInWithEmail(email!, password: password!){(user,error) in
                spinner.stopAnimating()
                if let error = error {
                self.errorAlert("Opps!", message:"user doesn't exit!")
                }else{
                self.sccuessAlert("Sccuess", message: "Login in")
                    dispatch_async(dispatch_get_main_queue(),{()-> Void in
                    let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("Home")
                        UIApplication.sharedApplication().keyWindow?.rootViewController = loginViewController
                    })
                }
            }
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
        
    }
    @IBAction func unwindToLoginScreen(segue: UIStoryboardSegue){ }

}

