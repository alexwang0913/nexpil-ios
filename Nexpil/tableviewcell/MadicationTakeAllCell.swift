//
//  MadicationHistoryButtonViewCell.swift
//  Nexpil
//
//  Created by Admin on 4/7/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class MadicationTakeAllCell: UITableViewCell {

    @IBOutlet weak var takeAllLabel: UILabel!
    @IBOutlet weak var takeall: GradientView!
    
    public func setColor(_ color: UIColor){        
        takeall.topColor = color
        takeall.bottomColor = color
    }
    public func setTitle(_ title: String) {
        takeAllLabel.text = title
    }
}
