//
//  HttpRequest.swift
//  Smashtag
//
//  Created by apple on 15/6/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

import Foundation

class HttpRequest {
    
    class func requestWithURL(url: String, handler: (data: NSDictionary) -> Void ) {
        var URL: NSURL? = NSURL(string: url)
        var req = NSURLRequest(URL: URL!)
        
        NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
                if (error != nil) {
                    
                }
                else {
                    var result: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                    handler(data: result)
 //                   println(result)
                    }
                })
    }
}
