//
//  post.swift
//  Firebase test2
//
//  Created by Johnny Hsieh on 2016/6/14.
//  Copyright © 2016年 Johnny' mac. All rights reserved.
//
import UIKit
import Foundation
class Post: NSObject{
    var username: String?
    var postText: String?
    var time: NSData?
    var userPhoto: UIImage?
    var postPhoto: UIImage?
    init(username: String?, postText:String?,time: NSData?, userPhoto:UIImage?, postPhoto: UIImage) {
        self.username = username
        self.postText = postText
        self.time = NSData()
        self.userPhoto = userPhoto
        self.postPhoto = postPhoto
    }
    
    }
