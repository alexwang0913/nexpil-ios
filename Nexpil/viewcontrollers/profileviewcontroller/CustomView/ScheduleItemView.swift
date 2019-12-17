//
//  ScheduleItemView.swift
//  Nexpil
//
//  Created by JinYingZhe on 1/24/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class ScheduleItemView: UIView {
    @IBOutlet weak var avatarUIV: UIImageView!
    @IBOutlet weak var nameUL: UILabel!
    @IBOutlet weak var timeUL: UILabel!
    @IBOutlet weak var wholeUV: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setDectorContent(withData data: NSDictionary) {
        let name = data.value(forKey: "title")
        let timeStart = Int(data.value(forKey: "timeStart") as! String)!
        let timeEnd = Int(data.value(forKey: "timeEnd") as! String)!
        let image = data.value(forKey: "image")
        
        var startLabel = timeStart > 11 ? timeStart == 12 ? "12:00pm" : "\(timeStart - 12):00pm" : "\(timeStart):00am"
        var endLabel = timeEnd > 11 ? timeEnd == 12 ? "12:00pm" : "\(timeEnd-12):00pm" : "\(timeEnd):00am"
        
        nameUL.text = name as? String
        timeUL.text = "\(startLabel) - \(endLabel)"
        avatarUIV.image = UIImage(named: (image as? String)!)
        
        let radiu = avatarUIV.layer.frame.width / 2
        avatarUIV.layer.cornerRadius = radiu
        
        wholeUV.setPopItemViewStyle()
        wholeUV.layer.cornerRadius = 22.5
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
