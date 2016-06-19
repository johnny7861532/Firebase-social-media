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
        
        let userPostRef = self.databaseRef.child("posts")
        userPostRef.queryOrderedByChild("time").observeEventType(.ChildAdded, withBlock: {(snapshot) in
            if let postAdd  = snapshot.value as? NSDictionary{
                let myPost = Post(data: postAdd)
                self.posts.insert(myPost, atIndex: 0)
                
                //Dispatch the main thread here
                dispatch_async(dispatch_get_main_queue()) {
                    cell.usernameLabel.text = self.posts[indexPath.row].username
                    cell.postText.text = self.posts[indexPath.row].postText
                    cell.timeLabel.text = self.posts[indexPath.row].time
                    
                }
                let url = snapshot.value?["postPhoto"] as! String
                let userPhotoUrl = snapshot.value?["userPhoto"] as! String

            
                FIRStorage.storage().referenceForURL(url).dataWithMaxSize(10 * 1024 * 1024, completion: { (data, error) in
                    dispatch_async(dispatch_get_main_queue()) {
                        let postPhoto = UIImage(data: data!)
                        cell.postPhoto.image = postPhoto
                    }

                    FIRStorage.storage().referenceForURL(userPhotoUrl).dataWithMaxSize(10 * 1024 * 1024, completion: { (data, error) in
                        dispatch_async(dispatch_get_main_queue()) {
                            let userPhoto = UIImage(data: data!)
                            cell.userPhoto.image = userPhoto
                        }
                       
                    })
                    
                    
                

            })
            }
        })
        
            return cell
        }
    
        }
