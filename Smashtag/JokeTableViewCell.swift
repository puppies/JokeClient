//
//  JokeTableViewCell.swift
//  Smashtag
//
//  Created by apple on 15/6/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

import UIKit

class JokeTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var data: NSDictionary? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        profileImageView?.image = nil
        nameLabel?.text = nil
        contentLabel?.text = nil
        
        if let user = data?["user"] as? NSDictionary {
//            profileImageView.image = UIImage(contentsOfFile: post.profileImageURL!)
            nameLabel?.text = user["login"] as? String
//            contentLabel.text = post.content
            if let icon = user["icon"] as? String {
                let userId = user["id"] as! String
                let index = advance(userId.endIndex, -4)
                let prefixUserId = userId.substringToIndex(index)
                let url = "http://pic.qiushibaike.com/system/avtnew/\(prefixUserId)/\(userId)/medium/\(icon)"
//                println("\(url)")
                let iconURL = NSURL(string: url)
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
                    if let imageData = NSData(contentsOfURL: iconURL!) {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.profileImageView?.image = UIImage(data: imageData)
                        }
                    }
                }
            }
            
        }
        
        var content = data?["content"] as? String
        contentLabel?.text = content
        
        
    }
}
