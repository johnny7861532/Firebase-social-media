//
//  post.swift
//  Firebase test2
//
//  Created by Johnny Hsieh on 2016/6/14.
//  Copyright © 2016年 Johnny' mac. All rights reserved.
//
import UIKit
import Foundation
class Post {
    var username: String?
    var postText: String?
    var time: String?
    var userPhoto: UIImage?
    var postPhoto: UIImage?
    var url: String?
    var userPhotoUrl:String?
    init(data: NSDictionary) {
       username = data["username"] as? String
       postText = data["postText"] as? String
        time = data["time"]as? String
        userPhoto = data["userPhoto"] as? UIImage
        postPhoto = data["postPhoto"] as? UIImage
        url = data["postPhoto"] as? String
        userPhotoUrl = data["userPhoto"] as? String
    }
    
    }
