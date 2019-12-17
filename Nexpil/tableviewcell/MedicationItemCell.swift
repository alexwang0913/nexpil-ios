//
//  MedicationHistoryCellTableViewCell.swift
//  Nexpil
//
//  Created by Admin on 4/7/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class MedicationItemCell: UITableViewCell {

    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var checkbtn: UIButton!  
    
    @IBOutlet weak var backgroundheight: NSLayoutConstraint!
    public func setColor(_ color: UIColor){
        content.textColor = color
        switch color.toHex() {
        case "39D3E3":
            checkbtn.setImage(UIImage(named: "drug_but_circle_wShadow"), for: .normal)
            break;
        case "397EE3":
            checkbtn.setImage(UIImage(named: "Drk_blue_Take Medication-2"), for: .normal)
            break;
        case "415CE3":
            checkbtn.setImage(UIImage(named: "Drkpurple_Take Medication"), for: .normal)
            break;
        case "4939E3":
            checkbtn.setImage(UIImage(named: "uncheck-n"), for: .normal)
            break;
        default:
            break;
        }
    }
    
}
