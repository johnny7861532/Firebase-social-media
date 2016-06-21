//
//  homeViewController.swift
//  Firebase test2 Auth
//
//  Created by Johnny' mac on 2016/5/25.
//  Copyright © 2016年 Johnny' mac. All rights reserved.
//

import Firebase
import Photos


class homeViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var userPhoto: UIImageView!

    @IBOutlet weak var userNameLabel: UILabel!
    let picker = UIImagePickerController()
    var databaseRef: FIRDatabaseReference!
    var storageRef: FIRStorageReference!
    
    
    @IBAction func tapDidLogOut(sender: AnyObject) {
    try!FIRAuth.auth()!.signOut()
        dispatch_async(dispatch_get_main_queue(), {()-> Void in
            let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
            self.presentViewController(viewController, animated: true, completion: nil)
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      storageRef = FIRStorage.storage().reference()
      databaseRef = FIRDatabase.database().reference()
     //edit userphoto to circle
      userPhoto.layer.cornerRadius = userPhoto.frame.size.height/2
      userPhoto.clipsToBounds = true
    if FIRAuth.auth()!.currentUser == nil{
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(viewController, animated: true, completion: nil)
                
            })
            
        }else{
            
            
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        self.databaseRef.child("users").child(userID!).observeEventType(.Value, withBlock: { (snapshot) in
            // Get user value
            dispatch_async(dispatch_get_main_queue()){
                let username = snapshot.value!["username"] as! String
                self.userNameLabel.text = username
                // check if user has photo
                if snapshot.hasChild("userPhoto"){
                    // set image locatin
                    let filePath = "\(userID!)/\("userPhoto")"
                    // Assuming a < 10MB file, though you can change that
                    self.storageRef.child(filePath).dataWithMaxSize(10*1024*1024, completion: { (data, error) in
                    let userPhoto = UIImage(data: data!)
                    self.userPhoto.image = userPhoto
                    })
        }
        
        }
        
        })
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
               }

    
    @IBAction func tapDidChangePhoto(sender: AnyObject) {
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
        userPhoto.image = image
        dismissViewControllerAnimated(true, completion: nil)
        var data = NSData()
        data = UIImageJPEGRepresentation(userPhoto.image!, 0.8)!
        // set upload path
        let filePath = "\(FIRAuth.auth()!.currentUser!.uid)/\("userPhoto")"
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpg"
        self.storageRef.child(filePath).putData(data, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
            //store downloadURL
            let downloadURL = metaData!.downloadURL()!.absoluteString
            //store downloadURL at database
        self.databaseRef.child("users").child(FIRAuth.auth()!.currentUser!.uid).updateChildValues(["userPhoto": downloadURL])
            }

            }
                       }
    
    
    
        
    }


   