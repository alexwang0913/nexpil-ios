//
//  AsNeededRememberTableViewCell.swift
//  Nexpil
//
//  Created by mac on 9/6/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class AsNeededRememberTableViewCell: UITableViewCell {

    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var vwBg:GradientView!
    public func setColor(_ color: UIColor){        
        vwBg.topColor = color
        vwBg.bottomColor = color
    }
}
