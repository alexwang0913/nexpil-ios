//
//  Pharmacy.swift
//  Pharmacies
//
//  Created by Mohammed Faizuddin on 3/16/19.
//  Copyright © 2019 Mohammed Faizuddin. All rights reserved.
//

import Foundation
import MapKit

struct Pharmacy1 {
    var name: String
    var address: String
    var phone: String
    var coordinates: CLLocationCoordinate2D?
    
     init() {
        name = "No Name"
        address = "No Address"
        phone = "No Phone"
        coordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    init(name: String, address: String, phone: String, coordinates: CLLocationCoordinate2D) {
        self.name = name
        self.address = address
        self.phone = phone
        self.coordinates = coordinates
    }
    
}
struct Pharmacy {
    var id: Int
    var brand: String
    var address: String
    var phone_number: String
    var latitude: String
    var longitude: String
    init(json:[String : Any])
    {
        self.id = (json["id"] as! NSString).integerValue
        self.brand = (json["brand"] as! NSString) as String
        self.phone_number = (json["phone_number"] as! NSString) as String
        self.latitude = (json["latitude"] as! NSString) as String
        self.longitude = (json["longitude"] as! NSString) as String
        self.address = (json["address"] as! NSString) as String
    }
    init(id:Int, brand:String,address:String,phone_number:String,latitude:String,longitude:String)
    {
        self.id = id
        self.brand = brand
        self.phone_number = phone_number
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
    }
}
