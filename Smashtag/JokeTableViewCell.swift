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
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dislikeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    var data: NSDictionary? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        profileImageView?.image = nil
        nameLabel?.text = nil
        contentLabel?.text = nil
//        pictureImageView?.image = nil
        
        if let user = data?["user"] as? NSDictionary {
//            profileImageView.image = UIImage(contentsOfFile: post.profileImageURL!)
            nameLabel?.text = user["login"] as? String
//            contentLabel.text = post.content
            let userId = user["id"] as! String
            var index = advance(userId.endIndex, -4)
            let prefixUserId = userId.substringToIndex(index)
            
            if let icon = user["icon"] as? String {
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
        else {
            nameLabel?.text = "匿名"
        }
        
        let imageId = data?["id"] as! String
        let index = advance(imageId.endIndex, -4)
        let prefixImageId = imageId.substringToIndex(index)
        if let picture = data?["image"] as? String {
            var url = "http://pic.qiushibaike.com/system/pictures/\(prefixImageId)/\(imageId)/small/\(picture)"
            println("\(url)")
            let pictureURL = NSURL(string: url)
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
                if let pictureData = NSData(contentsOfURL: pictureURL!) {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.pictureImageView?.hidden = false
                        self.pictureImageView?.image = UIImage(data: pictureData)
                        self.pictureImageView?.bounds.size = self.pictureImageView!.image!.size
                    }
                }
            }
        }
        else {
            self.pictureImageView?.hidden = true
        }
        
        var content = data?["content"] as! String
        contentLabel?.text = content
        
        var time = data?["published_at"] as! Double
        let date = NSDate(timeIntervalSince1970: time)
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = NSTimeZone(name: "UTC")
//        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
//        formatter.timeStyle = NSDateFormatterStyle.MediumStyle
        let dateString = formatter.stringFromDate(date)
        timeLabel?.text = "\(dateString)"
        println("\(date)")
        
        var vote = data?["votes"] as! NSDictionary
        let like = vote["up"] as! Int
        let dislike = vote["down"] as! Int
        likeLabel?.text = "👍(\(like))"
        dislikeLabel?.text = "👎(\(dislike))"
        
        let comment = data?["comments_count"] as! Int
        commentLabel?.text = "评论(\(comment))"
        
    }
}
