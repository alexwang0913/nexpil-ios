//
//  DrugInfo.swift
//  Nexpil
//
//  Created by Guang on 10/18/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

class MyDrugInfo {
    var timing: String = ""
    var take_drugs: [[String: Any]] = []
    var untake_drugs: [[String: Any]] = []
    
    init (_ drugInfo: [String: Any]) {
        self.timing = drugInfo["timing"] as! String
        self.take_drugs = drugInfo["take_drugs"] as! [[String: Any]]
        self.untake_drugs = drugInfo["untake_drugs"] as! [[String: Any]]
    }
}
