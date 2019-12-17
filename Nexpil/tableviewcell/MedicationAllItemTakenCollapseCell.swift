//
//  MedicationAllItemTakenCollapseCell.swift
//  Nexpil
//
//  Created by Yun Lai on 2018/12/5.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class MedicationAllItemTakenCollapseCell: UITableViewCell {
    
    @IBOutlet weak var vwArrowRight: UIView!
    @IBOutlet weak var medicationname: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var backgroundview: GradientView!
    @IBOutlet weak var vw1: GradientView!
    @IBOutlet weak var vw2: GradientView!
    public func setColor(_ color: UIColor){
        backgroundview.topColor = color
        backgroundview.bottomColor = color
        vw1.topColor = color
        vw1.bottomColor = color
        vw2.topColor = color
        vw2.bottomColor = color
    }
}
