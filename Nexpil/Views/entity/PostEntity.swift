//
//  PostEntity.swift
//  Nexpil
//
//  Created by Admin on 22/06/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit
struct PostEntity {
    var userid: Int
    var type: Int // 0: text, 1: image, 2: video, 3: health, 4: mood, 5: cell user, 6: post message, 7: question
    var title: String
    var content: String
    var filename:String
    var mediaurl:String
    var createat:String
    var username:String
    var userimage:String
    var postid:Int
    var phonenumber:String
    var firstname:String
    var lastname:String
    var comment:String
    var likecounts:Int
    var commentcounts:Int
    var moodstate:String
    var comments:[NSDictionary]
    var healthType: String
    var healthValue: String
    var showComment = false
    var showMoreComment = false
    
    init(json:[String : Any])
    {
        self.userid = (json["userid"] as! NSString).integerValue
        self.type = (json["type"] as! NSString).integerValue
        self.title = ""
        self.content = (json["content"] as! NSString) as String
        self.filename = (json["filename"] as! NSString) as String
        self.mediaurl = (json["mediaurl"] as! NSString) as String
        self.createat = (json["createat"] as! NSString) as String
        self.healthType = (json["health_type"] as! NSString) as String
        self.healthValue = (json["health_value"] as! NSString) as String
        self.postid = (json["id"] as! NSString).integerValue
        self.firstname = (json["firstname"] as! NSString) as String
        self.lastname = (json["lastname"] as! NSString) as String
        self.username = firstname + " " + lastname.prefix(1).uppercased() + "."
        self.userimage = (json["userimage"] as! NSString) as String
        self.phonenumber = ""
        self.comment = ""
        self.commentcounts = (json["commentcounts"] as! NSString).integerValue
        self.likecounts = (json["likecounts"] as! NSString).integerValue
        let comments = json["comments"] as? [[String:Any]]
        //self.userimage = (json["userimage"] as! NSString) as String
        self.comments = []
        for item in comments!
        {
            let comment = item as! NSDictionary
            self.comments.append(comment)
        }
        self.moodstate = (json["moodstate"] as! NSString) as String
    }
    init(userid:Int, type:Int,title:String,content:String,filename:String,mediaurl:String,createat:String,username:String,userimage:String,phonenumber:String)
    {
        self.userid = userid
        self.type = type
        self.title = title
        self.content = content
        self.filename = filename
        self.mediaurl = mediaurl
        self.createat = createat
        self.username = username
        self.userimage = userimage
        self.postid = 0
        self.phonenumber = phonenumber
        self.firstname = ""
        self.lastname = ""
        self.comment = ""
        self.likecounts = 0
        self.commentcounts = 0
        self.comments = []
        self.moodstate = ""
        healthType = ""
        healthValue = ""
    }
}
