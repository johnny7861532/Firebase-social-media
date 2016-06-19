//
//  postViewController.swift
//  Firebase test2
//
//  Created by Johnny Hsieh on 2016/6/13.
//  Copyright © 2016年 Johnny' mac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import Photos

class postViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var postTextFiled: UITextField!
    @IBOutlet weak var postImage: UIImageView!
    var DatabaseRef: FIRDatabaseReference!
    var StorageRef: FIRStorageReference!
    // set error alert!
    func errorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        DatabaseRef = FIRDatabase.database().reference()
        StorageRef = FIRStorage.storage().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapDidPickPhoto(sender: AnyObject) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.Camera){
        picker.sourceType = .Camera
        }else{
        picker.sourceType = .PhotoLibrary
        }
        self.presentViewController(picker, animated: true, completion: nil)
    }
   
    

    
    //picker delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        postImage.image = image
        dismissViewControllerAnimated(true, completion: nil)
        
        
    }

    @IBAction func tapDidSentPost(sender: AnyObject){
        // set up timestamp
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd, H:mm:ss"
        let defaultTimeZoneStr = formatter.stringFromDate(NSDate())
        // set up userpprofile
        let userNameRef = self.DatabaseRef.child("users/\(FIRAuth.auth()!.currentUser!.uid)/username")
        let userPhotoRef = self.DatabaseRef.child("users/\(FIRAuth.auth()!.currentUser!.uid)/userPhoto")
        userNameRef.observeSingleEventOfType(.Value, withBlock: {(snapShot) in
        let username = snapShot.value as! String
        
        
        userPhotoRef.observeSingleEventOfType(.Value, withBlock: {(snapShot)in
        let userPhotoUrl = snapShot.value as! String
        
       
     
        // set up post text
        
        let postText = self.postTextFiled.text
        let finalpostText = postText!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if postText!.characters.count>50 {
            self.errorAlert("Opps!", message: "username must less than 50 characters!")
        }else{
            var data = NSData()
            data = UIImageJPEGRepresentation(self.postImage.image!, 0.8)!
            // set upload path
            let key = self.DatabaseRef.child("posts").childByAutoId().key
            let filePath = "\(FIRAuth.auth()!.currentUser!.uid)/\("posts")/\(key)"
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpg"
            self.StorageRef.child(filePath).putData(data, metadata: metaData){(metaData, error) in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }else{
                    //storage downURL
                    let downLoadURL = metaData!.downloadURL()!.absoluteString
                    let post = ["\(key)":["username": username, "userPhoto": userPhotoUrl, "postPhoto": downLoadURL,"postText": postText!,"User":FIRAuth.auth()!.currentUser!.uid, "time":defaultTimeZoneStr] ]
                    //store downloadURL at database
                    self.DatabaseRef.child("posts").updateChildValues(post)
                    dispatch_async(dispatch_get_main_queue(), {()-> Void in
                        let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainNavigation")
                        self.presentViewController(viewController, animated: true, completion: nil)
                    })
                    
                }
            }
                }
                
        
    })
    
           })
}
    
    func textFieldShouldReturn(textFiled: UITextField) ->Bool{
        textFiled.resignFirstResponder()
        return true
    }

}