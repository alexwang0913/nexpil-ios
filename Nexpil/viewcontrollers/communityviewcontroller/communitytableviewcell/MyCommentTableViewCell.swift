//
//  MyCommentTableViewCell.swift
//  Nexpil
//
//  Created by Guang on 8/23/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Alamofire

class MyCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var content: UILabel!
    
    var m_tag: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeButtonClick(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PostLike"), object: nil, userInfo: ["tag": m_tag])
    }
    
    
    @IBAction func replyButtonClick(_ sender: Any) {
    }
    
    func commontInit(_ comment: NSDictionary) {
        let firstName = comment.object(forKey: "first_name") as! String
        let lastName = comment.object(forKey: "last_name") as! String
        let content = comment.object(forKey: "content") as! String
        let userimage = comment.object(forKey: "userimage") as! String
        let createat = comment.object(forKey: "createat") as! String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        let date = dateFormatter.date(from:createat)!
        let myTime = Date()
        
        let interval = myTime.timeIntervalSince(date)
        let hour = interval / 3600;
        let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
        
        
        userName.text = "\(firstName) \(lastName)"
        self.content.text = content
        self.time.text = "\(Int(hour)) Hours \(Int(minute)) Minutes ago"
        
        if userimage == "" {
            let image = UIImage(named: "Intersection 1")
            self.userImage.image = image
        } else {
            let url = URL(string: DataUtils.PROFILEURL + userimage)
            self.userImage.kf.setImage(with: url)
        }
        self.userImage.layer.cornerRadius = self.userImage.frame.size.height / 2
        self.userImage.clipsToBounds = true
    }
}
