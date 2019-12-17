//
//  Notification.swift
//  Nexpil
//
//  Created by Admin on 24/06/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct NotificationEntity {
    var userid: Int
    var firstname: String
    var lastname: String
    var notification: String
    var createat:String
    var userimage:String
    var type: Int = 0
    
    init(json:[String : Any])
    {
        self.userid = json["userid"] as? Int ?? 0
        self.notification = json["notification"] as? String ?? ""
        self.createat = json["createat"] as? String ?? ""
        self.firstname = json["firstname"] as? String ?? ""
        self.lastname = json["lastname"] as? String ?? ""
        self.userimage = json["userimage"] as? String ?? ""
        self.type = json["userimage"] as? Int ?? 0
    }
}
