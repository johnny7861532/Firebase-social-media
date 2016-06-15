//
//  timelineTableViewCell.swift
//  Firebase test2
//
//  Created by Johnny Hsieh on 2016/6/13.
//  Copyright © 2016年 Johnny' mac. All rights reserved.
//

import UIKit

class timelineTableViewCell: UITableViewCell {

    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postPhoto: UIImageView!
    @IBOutlet weak var userPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
