//
//  PharmacyCache.swift
//  Pharmacies
//
//  Created by Mohammed Faizuddin on 3/26/19.
//  Copyright © 2019 Mohammed Faizuddin. All rights reserved.
//

import SQLite
import MapKit

class PharmacyCache {
    static let instance = PharmacyCache()
    private let database: Connection?
    
    let pharmaciesTable = Table("pharmacies")
    
    private let id = Expression<Int64>("id")
    private let name = Expression<String>("name")
    private let address = Expression<String>("address")
    private let phone = Expression<String>("phone")
    private let latitude = Expression<Double>("latitude")
    private let longitude = Expression<Double>("longitude")
    private let pharmacyType = Expression<String>("pharmacyType")
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do {
            database = try Connection("\(path)/PharmacyCache.sqlite3")
        } catch {
            database = nil
            print ("Unable to open database")
        }
        
        createTable()
    }
    
    func createTable()  {
        let createTable = self.pharmaciesTable.create(ifNotExists: true) { (table) in
            table.column(self.name)
            table.column(self.address)
            table.column(self.phone)
            table.column(self.latitude)
            table.column(self.longitude)
            table.column(self.pharmacyType)
            
            table.primaryKey(address, pharmacyType)
            
        }
        do {
            try self.database!.run(createTable)
            print("CREATED PHARMACIES TABLE")
        } catch {
            print(error)
        }
    }
    
//    func addPharmacy(pharmacy: Pharmacy1, pharmacyType: String) {
//
//        let name = pharmacy.name
//        let phone = pharmacy.phone
//        let address = pharmacy.address
//        let latitude = pharmacy.coordinates?.latitude as! Double
//        let longitude = pharmacy.coordinates?.longitude as! Double
//        let pharmacyType = pharmacyType
//
//
//
//
//        let insertPharmacy = self.pharmaciesTable.insert(self.name <- name, self.address <- address, self.phone <- phone, self.latitude <- latitude, self.longitude <- longitude, self.pharmacyType <- pharmacyType)
//
//        do {
//            let id = try self.database!.run(insertPharmacy)
//            print("INSERTED PHARMACY \(id)")
//
//        } catch {
//            print(error)
//        }
//
//    }
    
    
//    func getPharmaciesFromCache(pharmacyType: String) -> [Pharmacy1]{
//
//        var pharmaciesInDatabase = [Pharmacy1]()
//
//        do {
//            let pharmacies = try self.database!.prepare(self.pharmaciesTable)
//
//            for pharmacy in pharmacies {
//
//                if "\(pharmacy[self.pharmacyType])" == pharmacyType {
//                    pharmaciesInDatabase.append(Pharmacy1(name: "\(pharmacy[self.name])", address: "\(pharmacy[self.address])", phone: "\(pharmacy[self.phone])", coordinates: CLLocationCoordinate2D(latitude: pharmacy[self.latitude], longitude: pharmacy[self.longitude])))
//                }
//            }
//        }
//        catch {
//            print(error)
//        }
//
//        return pharmaciesInDatabase
//    }
//
//
//    func contains(this pharmacy: Pharmacy1) -> Bool {
//        do {
//            let pharmacies = try self.database!.prepare(self.pharmaciesTable)
//
//            for pharm in pharmacies {
//
//                if "\(pharm[self.address])" == pharmacy.address && "\(pharm[self.pharmacyType])" == "myPharmacies" {
//                    return true
//                }
//            }
//        }
//        catch {
//            print(error)
//        }
//        return false
//
//    }
    
//    func removeFromMyPharmacies(pharmacy: Pharmacy1) {
//
//        let pharmacy = self.pharmaciesTable.filter(self.pharmacyType == "myPharmacies" && self.address == pharmacy.address)
//        let deletePharmacy = pharmacy.delete()
//        do {
//            try self.database!.run(deletePharmacy)
//            print("REMOVED FROM MY PHARMACIES.")
//        } catch {
//            print(error)
//        }
//    }
//
//    func deleteAll(from type: String) {
//
//        if(type != "myPharmacies") {
//
//            do {
//                let pharmacies = try self.database!.prepare(self.pharmaciesTable)
//                for _ in pharmacies {
//                    let pharmacy = self.pharmaciesTable.filter(self.pharmacyType == type)
//                    let deletePharmacy = pharmacy.delete()
//                    try self.database!.run(deletePharmacy)
//                }
//            } catch {
//                print(Result.error)
//            }
//            print("REMOVING OLD PHARMACIES FROM \(type) SECTION.")
//
//        }
//    }
//
//
//    func delete() {
//        do {
//            try self.database!.run(pharmaciesTable.delete())
//
//            print("DELETED DATA FROM THE PHARMACIES TABLE")
//        } catch {
//            print(error)
//        }
//    }
//
//    func destroy() {
//
//        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//        let fm = FileManager.default
//        do {
//            let vFileURL = NSURL(fileURLWithPath: "\(path)/PharmacyCache.sqlite3")
//            try fm.removeItem(at: vFileURL as URL)
//            print("DATABASE DELETED FROM MEMORY!")
//        } catch {
//            print("ERROR ON DELETING PHARMACIES DATABASE \(Result.error)")
//        }
//    }
}
