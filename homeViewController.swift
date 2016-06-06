//
//  homeViewController.swift
//  Firebase test2 Auth
//
//  Created by Johnny' mac on 2016/5/25.
//  Copyright © 2016年 Johnny' mac. All rights reserved.
//

import Firebase
import FirebaseDatabase
import FirebaseStorage
import Photos


class homeViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var userPhoto: UIImageView!

    @IBOutlet weak var userNameLabel: UILabel!
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
        
    }
    
    
      
    override func viewWillAppear(animated: Bool) {
        if FIRAuth.auth()!.currentUser == nil{
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(viewController, animated: true, completion: nil)
                
            })
            
        }else{
            
            
            let userID = FIRAuth.auth()?.currentUser?.uid
            databaseRef.child("users").child(userID!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                // Get user value
                let username = snapshot.value!["username"] as! String
               
                self.userNameLabel.text = username
                
            })

        }
}
    
    @IBAction func tapDidChangePhoto(sender: AnyObject) {
        
        var picker = UIImagePickerController()
        // photo editing
        picker.allowsEditing = true
        picker.delegate = self
        // if it's a photo from carmera else from photolibaray
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
        
        picker.sourceType = .PhotoLibrary
        }
        presentViewController(picker, animated: true, completion:nil)
        }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // Get local file URLs
        guard let image: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        let imageData = UIImagePNGRepresentation(image)!
        guard let imageURL: NSURL = info[UIImagePickerControllerReferenceURL] as? NSURL else { return }
        
        // Get a reference to the location where we'll store our photos
       self.storageRef.child("userPhotos")
        
        // Get a reference to store the file at chat_photos/<FILENAME>
        let photoRef = storageRef.child("\(NSUUID().UUIDString).png")
        
        // Upload file to Firebase Storage
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/png"
        photoRef.putData(imageData, metadata: metadata).observeStatus(.Success) { (snapshot) in
            // When the image has successfully uploaded, we get it's download URL
            let text = snapshot.metadata?.downloadURL()?.absoluteString
            // Set the download URL to the message box, so that the user can send it to the database
            self.userPhoto.image = UIImage.init(data: imageData)
        }
        
        // Clean up picker
        dismissViewControllerAnimated(true, completion: nil)
    }
    }


