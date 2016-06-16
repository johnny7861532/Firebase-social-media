//
//  timelineTableViewController.swift
//  Firebase test2
//
//  Created by Johnny Hsieh on 2016/6/13.
//  Copyright © 2016年 Johnny' mac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class timelineTableViewController: UITableViewController {
    var posts = [Post]()
    var databaseRef: FIRDatabaseReference!
    var storageRef: FIRStorageReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = FIRDatabase.database().reference()
        storageRef = FIRStorage.storage().reference()
    }
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
        
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "postCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)as! timelineTableViewCell
        
        let userNameRef = self.databaseRef.child("users/\(FIRAuth.auth()!.currentUser!.uid)/username")
        let userPhotoRef = self.databaseRef.child("users/\(FIRAuth.auth()!.currentUser!.uid)/userPhoto")
        let userPostRef = self.databaseRef.child("posts")
        
        userPhotoRef.observeSingleEventOfType(.Value , withBlock: { (snapshot) in
            
            
            let url = snapshot.value as! String
            
            
            FIRStorage.storage().referenceForURL(url).dataWithMaxSize(10 * 1024 * 1024, completion: { (data, error) in
                
                
                let userPhoto = UIImage(data: data!)
                cell.userPhoto.image = userPhoto
                cell.userPhoto.layer.cornerRadius = cell.userPhoto.frame.size.height/2
                cell.userPhoto.clipsToBounds = true
                })
        })
        userNameRef.observeSingleEventOfType(.Value, withBlock:{ (snapshot) in
            let userName = snapshot.value as! String
            cell.usernameLabel.text = userName
            
        })
        userPostRef.observeEventType(.ChildAdded, withBlock: {(snapshot) in
            if let postAdd  = snapshot.value as? NSDictionary{
                let myPost = Post(data: postAdd)
                self.posts.append(myPost)
                
                cell.postText.text = self.posts[indexPath.row].postText
                cell.timeLabel.text = self.posts[indexPath.row].time
                let url = snapshot.value?["postPhoto"] as! String
                
            FIRStorage.storage().referenceForURL(url).dataWithMaxSize(10 * 1024 * 1024, completion: { (data, error) in
                let postPhoto = UIImage(data: data!)
              cell.postPhoto.image = postPhoto
              
                

            })
            }
        })
        
            return cell
        }
    
        }
