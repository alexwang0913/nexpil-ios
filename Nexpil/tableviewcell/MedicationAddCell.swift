//
//  MedicationHistoryButtonViewCell2.swift
//  Nexpil
//
//  Created by Admin on 4/7/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class MedicationAddCell: UITableViewCell {

    @IBOutlet weak var addbtn: GradientView!
    
    public func setColor(_ color: UIColor){
        addbtn.topColor = color
        addbtn.bottomColor = color
    }
}
