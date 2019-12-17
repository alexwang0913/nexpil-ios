//
//  PostTableViewCell.swift
//  Nexpil
//
//  Created by Admin on 4/11/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var userphoto: UIImageView!
    @IBOutlet weak var healthBtn: UIButton!
    @IBOutlet weak var moodbtn: UIButton!
    @IBOutlet weak var photobtn: UIButton!
    @IBOutlet weak var userbackground: GradientView!
    @IBOutlet weak var userLabelView: GradientView!
    @IBOutlet weak var whatsonyourmind: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        userLabelView.clipsToBounds = true
        userLabelView.layer.cornerRadius = 20
        userLabelView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        userLabelView.setGradient(colors: NPColorScheme(rawValue: 3)!.gradient)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
