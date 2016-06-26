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
        downloadPost()
    }
    func downloadPost(){
        let userPostRef = self.databaseRef.child("posts")
        
        userPostRef.queryOrderedByChild("time").observeEventType(.ChildAdded, withBlock: {(snapshot) in
            if let postAdd  = snapshot.value as? NSDictionary{
                
                let url = snapshot.value?["postPhoto"] as! String
                let userPhotoUrl = snapshot.value?["userPhoto"] as! String
                FIRStorage.storage().referenceForURL(url).dataWithMaxSize(10 * 1024 * 1024, completion: { (data, error) in
                    let postPhoto = UIImage(data: data!)!
                    
                    
                })
                FIRStorage.storage().referenceForURL(userPhotoUrl).dataWithMaxSize(10 * 1024 * 1024, completion: { (data, error) in
                    let userPhoto = UIImage(data: data!)!
                    
                    
                })
                
                let myPost = Post(data: postAdd)
                self.posts.insert(myPost, atIndex: 0)
                
            }
            self.tableView.reloadData()
        })
        
        
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
        
        
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "postCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)as! timelineTableViewCell
        //Dispatch the main thread here
        
        
        cell.usernameLabel.text = self.posts[indexPath.row].username
        cell.postText.text = self.posts[indexPath.row].postText
        cell.timeLabel.text = self.posts[indexPath.row].time
        cell.postPhoto.image = self.posts[indexPath.row].postPhoto
        cell.userPhoto.image = self.posts[indexPath.row].userPhoto
        
        
        
        return cell
        
    }
}