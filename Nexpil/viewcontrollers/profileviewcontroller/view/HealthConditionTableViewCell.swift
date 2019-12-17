//
//  HealthConditionTableViewCell.swift
//  Nexpil
//
//  Created by mac on 8/27/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class HealthConditionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var uiView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        uiView.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 3.0
        uiView.layer.masksToBounds = false
        uiView.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
