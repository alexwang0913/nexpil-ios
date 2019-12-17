//
//  MyMedication.swift
//  Nexpil
//
//  Created by Admin on 4/18/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct MyMedication {
    var id : Int
    var directions: String
    var dose : String
    var image : String
    var quantity : Int = 0
    var prescribe: String
    var taketime : String
    var patientname : String
    var pharmacy : String
    var medicationname : String
    var strength : String
    var frequency : String
    var lefttablet : String
    var warnings : String
    var type : String
    var filedDate : String  
    var prescription : Int
    var createat : String
    public var endat: String
    var amount: String = ""
    var asneeded: Int = 0
    
    init(json:[String : Any])
    {
        self.prescribe = (json["prescribe"] as! NSString) as String
        self.directions = (json["directions"] as! NSString) as String
        self.dose = (json["dose"] as! NSString) as String
        self.image = (json["image"] as! NSString) as String
//        self.quantity = (json["quantity"] as! NSString) as String
        self.type = (json["type"] as! NSString) as String
        
        self.taketime = (json["taketime"] as! NSString) as String
        self.medicationname = (json["medicationname"] as! NSString) as String
        self.filedDate = (json["filed_date"] as! NSString) as String
        self.warnings = (json["warnings"] as! NSString) as String
        self.frequency = (json["frequency"] as! NSString) as String
        self.strength = (json["strength"] as! NSString) as String
        self.pharmacy = (json["pharmacy"] as! NSString) as String
        self.patientname = (json["patientname"] as! NSString) as String
        
        self.id = (json["id"] as! NSString).integerValue
        self.lefttablet = (json["lefttablet"] as! NSString) as String
        self.prescription = (json["prescription"] as! NSString).integerValue
        self.createat = (json["createat"] as! NSString) as String
        self.endat = (json["endat"] as! NSString) as String
        self.amount = (json["amount"] as! NSString) as String
    }
    init()
    {
        self.prescribe = ""
        self.directions = ""
        self.dose = ""
        self.image = ""
//        self.quantity = ""
        self.type = ""
        self.taketime = ""
        self.medicationname = ""
        self.filedDate = ""
        self.warnings = ""
        self.frequency = ""
        self.strength = ""
        self.pharmacy = ""
        self.patientname = ""
        self.id = 0
        self.lefttablet = ""
        self.prescription = 0
        self.createat = ""
        self.endat = ""
    }
    init(prescribe:String,directions:String,dose:String,image:String,quantity:Int,type:String,taketime:String,medicationname:String,filedDate:String,warning:String,frequency:String,strength:String,pharmacy:String,patientname:String,lefttablet:String,prescription:Int,createat:String, endat:String, id:Int, amount: String, asneeded: Int)
    {
        self.prescribe = prescribe
        self.directions = directions
        self.dose = dose
        self.image = image
        self.quantity = quantity
        self.type = type
        self.taketime = taketime
        self.medicationname = medicationname
        self.filedDate = filedDate
        self.warnings = warning
        self.frequency = frequency
        self.strength = strength
        self.pharmacy = pharmacy
        self.patientname = patientname
        self.id = id
        self.lefttablet = lefttablet
        self.prescription = prescription
        self.createat = createat
        self.endat = endat
        self.amount = amount
        self.asneeded = asneeded
    }
}
