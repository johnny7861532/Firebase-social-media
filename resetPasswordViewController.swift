//
//  resetPasswordViewController.swift
//  Firebase test2 Auth
//
//  Created by Johnny' mac on 2016/5/24.
//  Copyright © 2016年 Johnny' mac. All rights reserved.
//

import UIKit
import Firebase

class resetPasswordViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBAction func tapDidReset(sender: AnyObject) {
    let email = self.emailField.text
    let finalemail = email?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    FIRAuth.auth()?.sendPasswordResetWithEmail(email!, completion: nil)
    let  alert = UIAlertController(title: "Password resrt!", message: "An email containing information on how to reset your password has been sent to  \(finalemail!)", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
        
    }
    
    }
