//
//  PharmacyTableViewCellTwo.swift
//  Pharmacies
//
//  Created by Mohammed Faizuddin on 3/29/19.
//  Copyright © 2019 Mohammed Faizuddin. All rights reserved.
//

import UIKit


class PharmacyTableViewCellTwo: UITableViewCell {
    
    
    @IBOutlet weak var cellBackgroundView: UIView!
    
    
    
    override func layoutSubviews() {
        self.cellBackgroundView.layer.cornerRadius = 20
        self.cellBackgroundView.layer.masksToBounds = false
        
        self.cellBackgroundView.layer.shadowColor = UIColor.darkGray.cgColor
        self.cellBackgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.cellBackgroundView.layer.shadowRadius = 4.0
        self.cellBackgroundView.layer.shadowOpacity = 0.2
    }

}
