//
//  UserCache.swift
//  Pharmacies
//
//  Created by Mohammed Faizuddin on 3/26/19.
//  Copyright © 2019 Mohammed Faizuddin. All rights reserved.
//

import SQLite
import MapKit

class UserCache {
    
    static let instance = UserCache()
    private let database: Connection?
    
    let userInfoTable = Table("userInfo")
    
    private let id = Expression<Int64>("id")
    private let currentLatitude = Expression<Double>("currentLocationLatitude")
    private let currentLongitude = Expression<Double>("currentLocationLongitude")
    private let homeLatitude = Expression<Double>("homeAddressLatitude")
    private let homeLongitude = Expression<Double>("homeAddressLongitude")
    
     var firstCall = 0
    
    private init() {
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do {
            database = try Connection("\(path)/UserCache.sqlite3")
        } catch {
            database = nil
            print ("Unable to open database")
        }
        
        //createTable()
        
        
    }
    
//    func createTable()  {
//        let createTable = self.userInfoTable.create(ifNotExists: true) { (table) in
//            table.column(self.id, primaryKey: true)
//            table.column(self.currentLatitude)
//            table.column(self.currentLongitude)
//            table.column(self.homeLatitude)
//            table.column(self.homeLongitude)
//        }
//        do {
//            try self.database!.run(createTable)
//            print("CREATED USER INFO TABLE")
//        } catch {
//            print(error)
//        }
//        
//            insertDefaultValues()
//        
//        
//    }
    
    func insertDefaultValues() {

        let currentLatitude: Double = 0.0
        let currentLongitude: Double = 0.0
        let homeLatitude: Double = 42.042301
        let homeLongitude: Double = -87.889320

        let insertDefaultInfo = self.userInfoTable.insert(self.id <- 1, self.currentLatitude <- currentLatitude, self.currentLongitude <- currentLongitude, self.homeLatitude <- homeLatitude, self.homeLongitude <- homeLongitude)

                do {
                    let id = try self.database!.run(insertDefaultInfo)
                    print("INSERTED DEFAULT USER INFO")
                    print(id)

                } catch {
                    print(error)
                }

    }
    
    func updateLocation(of location: String, latitude: Double, longitude: Double) {
        
        switch location {
        case "home":
            let loc = self.userInfoTable.filter(self.id == 1)
            let updateLocation = loc.update(self.homeLatitude <- latitude, self.homeLongitude <- longitude)
            do {
                try self.database!.run(updateLocation)
                print("UPDATED HOME LOCATION")
            } catch {
                print(Result.error)
            }

        case "current":
            let loc = self.userInfoTable.filter(self.id == 1)
            let updateLocation = loc.update(self.currentLatitude <- latitude, self.currentLongitude <- longitude)
            do {
                try self.database!.run(updateLocation)
                print("UPDATED CURRENT LOCATION")
            } catch {
                print(Result.error)
            }

        default:
            print("NOT FOUND")
        }
    }
    
    func getLocation(of location: String) -> CLLocationCoordinate2D {
        
        var returnValue = CLLocationCoordinate2D()
        
        do {
            let userInfo = try self.database!.prepare(self.userInfoTable)
            
            for info in userInfo {
                
                if info[self.id] == 1
                {
                switch location {
                case "home":
                    let latitude = info[self.homeLatitude]
                    let longitude = info[self.homeLongitude]
                    returnValue = CLLocationCoordinate2DMake(latitude, longitude)
                    print("RETURNING: \(latitude) \(longitude)")

                    
                case "current":
                    let latitude = info[self.currentLatitude]
                    let longitude = info[self.currentLongitude]
                    returnValue = CLLocationCoordinate2DMake(latitude, longitude)
                    print("RETURNING: \(latitude) \(longitude)")

                default:
                    returnValue = CLLocationCoordinate2D(latitude: 0, longitude: 0)
                }
                }
            }
            }
        catch {
            print(error)
        }
        
        return returnValue
    }

//    func delete() {
//        do {
//            try self.database!.run(userInfoTable.delete())
//
//            print("DELETED DATA FROM THE USER TABLE")
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
//            let vFileURL = NSURL(fileURLWithPath: "\(path)/UserCache.sqlite3")
//            try fm.removeItem(at: vFileURL as URL)
//            print("DATABASE DELETED FROM MEMORY!")
//        } catch {
//            print("ERROR ON DELETING USER DATABASE \(Result.error)")
//        }
//    }
}
