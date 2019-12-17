//
//  MedicationAllItemTakenExpandCell.swift
//  Nexpil
//
//  Created by Yun Lai on 2018/12/5.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class MedicationAllItemTakenExpandCell: UITableViewCell {
    
    @IBOutlet weak var vwArrowDown: UIView!
    @IBOutlet weak var medicationname: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var vwBg:GradientView!
    public func setColor(_ color: UIColor){
        vwBg.topColor = color
        vwBg.bottomColor = color
    }
}
