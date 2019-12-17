//
//  MedicationHistoryPrescriptionTableViewCell.swift
//  Nexpil
//
//  Created by Admin on 4/25/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class MedicationUntakenCell: UITableViewCell {

    @IBOutlet weak var checkbtn: UIButton!
    @IBOutlet weak var medicationname: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var backgroundview: UIView!
    @IBOutlet weak var vwNotification: UIView!
    @IBOutlet weak var remainDayLabel: UILabel!
    
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
            checkbtn.setImage(UIImage(named: "ltpurple_Take Medication-1"), for: .normal)
            break;
        case "4939E3":
            checkbtn.setImage(UIImage(named: "Drkpurple_Take Medication"), for: .normal)
            break;
        default:
            break;
        }
    }
}
