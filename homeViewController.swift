//
//  homeViewController.swift
//  Firebase test2 Auth
//
//  Created by Johnny' mac on 2016/5/25.
//  Copyright © 2016年 Johnny' mac. All rights reserved.
//

import Firebase
import FirebaseDatabase


class homeViewController: UIViewController {
    @IBOutlet weak var userPhoto: UIImageView!

    @IBOutlet weak var userNameLabel: UILabel!
    var databaseRef: FIRDatabaseReference!
    @IBAction func tapDidLogOut(sender: AnyObject) {
    try!FIRAuth.auth()!.signOut()
        dispatch_async(dispatch_get_main_queue(), {()-> Void in
            let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
            self.presentViewController(viewController, animated: true, completion: nil)
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
      
    override func viewWillAppear(animated: Bool) {
        if FIRAuth.auth()!.currentUser == nil{
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(viewController, animated: true, completion: nil)
                
            })
            
        }else{
            databaseRef = FIRDatabase.database().reference()
            
            let userID = FIRAuth.auth()?.currentUser?.uid
            databaseRef.child("users").child(userID!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                // Get user value
                let username = snapshot.value!["username"] as! String
               
                self.userNameLabel.text = username
                
            })

        }
}
   
}
