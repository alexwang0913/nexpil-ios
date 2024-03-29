//
//  DBManager.swift
//  ShipTankWedge
//
//  Created by Admin on 11/21/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import MapKit

var UserDrugs:[MyMedication] = []

class DBManager: NSObject {
    
    // Contacts Table Columns names
    let KEY_ID = "id"
    let KEY_MEDICATION_ID = "medication_id"
    let KEY_DATE = "date"
    let KEY_TAKE_TIME = "take_time"
    let KEY_EATEN_TIME = "eaten_time"
    let KEY_EAT_TEXT = "content"
    let KEY_MEDICATION_NAME = "medication_name"
    let KEY_DAY_TIME = "day_time"
    let KEY_PRESCRIPTION = "prescription"
    let KEY_NAME = "name"
    let KEY_DIRECTION = "direction"
    let KEY_DOSE = "dose"
    let KEY_QUANTITY = "quantity"
    let KEY_PRESCRIBE = "prescribe"
    //let KEY_TAKETIME = "taketime" : DataUtils.getMedicationWhen()!,
    let KEY_PHARMACY = "pharmacy"
    //"medicationname" : DataUtils.getMedicationName()!,
    let KEY_STRENGTH = "strength"
    let KEY_FIELDDATE = "filed_date"
    let KEY_FREQUENCY = "frequency"
    let KEY_LEFTTABLET = "lefttablet"
    //"prescription" : DataUtils.getPrescription(),
    let KEY_CREATEAT = "createat"
    
    let KEY_BRAND = "brand"
    let KEY_ADDRESS = "address"
    let KEY_IMAGE = "image"
    let KEY_PHONE = "phone_number"
    let KEY_LATITUDE = "latitude"
    let KEY_LONGITUDE = "longitude"
    
    let KEY_AMOUNT = "amount"
    let KEY_ASNEEDED = "asneeded"
    
    var lastid:Int = 0
    
    static var shared: DBManager?
    
    let databaseFileName = "database.sqlite"
    
    let TABLE_MEDICATION = "medication_history"
    let TABLE_MEDICATION1 = "medication_temp"
    let TABLE_MEDICATION2 = "medication"
    let TABLE_SPORTS1 = "detail"
    let TABLE_PHARMACY = "pharmance_temp"
    let TABLE_COMMUNITY_USER = "CommuntiyUser"
    var pathToDatabase: String!
    
    var database: FMDatabase!
    
    
    let pharmaciesTable = "pharmacies2"
    private let id = "id"
    private let name = "name"
    private let address = "address"
    private let phone = "phone"
    private let latitude = "latitude"
    private let longitude = "longitude"
    private let pharmacyType1 = "pharmacyType"
    
    
    static func getObject()->DBManager{
        if shared != nil{
            return shared!
        }else{
             shared = DBManager()
            return shared!
        }
    }
    override private init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
    }
    
    
    
    func createDatabase() -> Bool {
        var created = false
        
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            print(database)
            if database != nil {
                // Open the database.
                if database.open() {
                    let createMoviesTableQuery = "CREATE TABLE " + TABLE_MEDICATION + "("
                        + KEY_ID + " INTEGER PRIMARY KEY autoincrement,"
                        + KEY_DATE + " TEXT," + KEY_TAKE_TIME + " TEXT," +
                        KEY_EATEN_TIME + " TEXT," + KEY_EAT_TEXT + " TEXT," +
                        KEY_MEDICATION_NAME + " TEXT," + KEY_DAY_TIME + " TEXT," +
                        KEY_MEDICATION_ID + " INTEGER," + KEY_PRESCRIPTION + " INTEGER)"
                    
                    let createMoviesTableQuery2 = "CREATE TABLE " + TABLE_PHARMACY + "("
                        + KEY_ID + " INTEGER PRIMARY KEY autoincrement,"
                        + KEY_BRAND + " TEXT," + KEY_ADDRESS + " TEXT," +
                        KEY_PHONE + " TEXT," + KEY_LATITUDE + " TEXT," +
                        KEY_LONGITUDE + " TEXT)"
                    
                    let createMoviesTableQuery3 = "CREATE TABLE " + TABLE_COMMUNITY_USER + "("
                        + KEY_ID + " INTEGER PRIMARY KEY autoincrement,"
                        + KEY_NAME + " TEXT," + KEY_IMAGE + " BLOB)"
                    
                    let createMoviesTableQuery1 = "CREATE TABLE " + TABLE_MEDICATION1 + "("
                        + KEY_ID + " INTEGER PRIMARY KEY autoincrement,"
                        + KEY_DIRECTION + " TEXT," + KEY_DOSE + " TEXT," +
                        KEY_QUANTITY + " TEXT," + KEY_PRESCRIBE + " TEXT," +
                        KEY_TAKE_TIME + " TEXT," + KEY_PHARMACY + " TEXT," +
                        KEY_MEDICATION_NAME + " TEXT," + KEY_STRENGTH + " TEXT," +
                        KEY_FIELDDATE + " TEXT," + KEY_FREQUENCY + " TEXT," +
                        KEY_LEFTTABLET + " TEXT," + KEY_CREATEAT + " TEXT," +
                        KEY_PRESCRIPTION + " INTEGER," + KEY_AMOUNT + " TEXT," + KEY_ASNEEDED + " INTEGER)"
                    
                    let createMoviesTableQuery4 = "CREATE TABLE " + pharmaciesTable + "("
                        + id + " INTEGER PRIMARY KEY autoincrement,"
                        + name + " TEXT," + address + " TEXT," +
                        phone + " TEXT," + latitude + " TEXT," + longitude + " TEXT," + pharmacyType1 + " TEXT)"
                    
                    /*
                    let createMoviesTableQuery1 = "CREATE TABLE " + TABLE_SPORTS1 + "("
                        + KEY_ID + " INTEGER PRIMARY KEY autoincrement,"
                        + KEY_INFO + " TEXT," + KEY_TKNO + " TEXT," +
                        KEY_RE + " TEXT," + KEY_LENGTH + " TEXT," +
                        KEY_TKHEIGHT + " TEXT," + KEY_WIDTH + " TEXT," +
                        KEY_SOUNDING + " TEXT," + KEY_INNAGE + " TEXT," +
                        KEY_TABLEVOLUME + " TEXT" + ")"
                    */
                    do {
                        try database.executeUpdate(createMoviesTableQuery, values: nil)
                        try database.executeUpdate(createMoviesTableQuery1, values: nil)
                        try database.executeUpdate(createMoviesTableQuery2, values: nil)
                        try database.executeUpdate(createMoviesTableQuery3, values: nil)
                        try database.executeUpdate(createMoviesTableQuery4, values: nil)
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
                    
                    //database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        
        return created
    }
    
    func addPharmacy(pharmacy: Pharmacy1, pharmacyType: String) {

        print(pharmacyType)
        
        let query = "insert into \(pharmaciesTable) (\(name),\(address),\(phone),\(latitude),\(longitude),\(pharmacyType1)) values('\(pharmacy.name)','\(pharmacy.address)','\(pharmacy.phone)','\(pharmacy.coordinates!.latitude )','\( pharmacy.coordinates!.longitude )','\(pharmacyType)');"
        if !database.executeStatements(query) {
            print("Failed to insert initial data into the database.")
            print(database.lastError(), database.lastErrorMessage())
        }
        
    }
    func addPharmacyFromServer(pharmacy: Pharmacy, pharmacyType: String) {
        
        
        let query = "insert into \(pharmaciesTable) (\(name),\(address),\(phone),\(latitude),\(longitude),\(pharmacyType1)) values('\(pharmacy.brand)','\(pharmacy.address)','\(pharmacy.phone_number)','\(pharmacy.latitude)','\( pharmacy.longitude )','\(pharmacyType)');"
        if !database.executeStatements(query) {
            print("Failed to insert initial data into the database.")
            print(database.lastError(), database.lastErrorMessage())
        }
        
    }

    func getPharmaciesFromCache(pharmacyType: String) -> [Pharmacy1]{
        
        var datas:[Pharmacy1] = []
        if openDatabase() {
            let query = "select * from " + pharmaciesTable
            do {
                let results = try database.executeQuery(query, values: nil)
                while results.next() {
                    if "\(results.string(forColumn: pharmacyType1)!)" == pharmacyType {
                        
                        let coordinate = CLLocationCoordinate2D(latitude: Double(results.string(forColumn: latitude)!)!, longitude: Double(results.string(forColumn: longitude)!)!)
                        
                    let pharmacy = Pharmacy1.init(name: results.string(forColumn: name)!, address: results.string(forColumn: address)!, phone: results.string(forColumn: phone)!, coordinates:coordinate)
                    
                    datas.append(pharmacy)
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        return datas
    }
    

    
        ///////////////////////////////////////////////////////////////////////
    
    func contains(this pharmacy: Pharmacy1) -> Bool {
        
        if openDatabase() {
            let query = "select * from " + pharmaciesTable
            do {
                let results = try database.executeQuery(query, values: nil)
                while results.next() {
                    if "\(results.string(forColumn: address)!)" == pharmacy.address && "\(results.string(forColumn: pharmacyType1)!)" == "My Pharmacies" {
                        return true
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        return false
   }
    
    
    func removeFromMyPharmacies(pharmacy: Pharmacy1) {
         if openDatabase() {
            var query = ""
            
            query = "delete from \(pharmaciesTable) where \(pharmacyType1)=? & address=?"
            
            do {
                try database.executeUpdate(query, values: ["My Pharmacies",pharmacy.address])
            }
            catch {
                print(error.localizedDescription)
            }
        }
     
    }
    
    
    
// MARK:todelete
    
    func deleteAll(from type: String) {
        
        if(type != "My Pharmacies") {
            if openDatabase() {
                var query = ""
                
                query = "delete from \(pharmaciesTable) where \(pharmacyType1)=?"
                
                do {
                    try database.executeUpdate(query, values: [type])
                }
                catch {
                    print(error.localizedDescription)
                }
                //database.close()
            }
        }
    }
    func deleteMypharmacyAll(from type: String) {
            if openDatabase() {
                var query = ""
                
                query = "delete from \(pharmaciesTable) where \(pharmacyType1)=?"
                
                do {
                    try database.executeUpdate(query, values: [type])
                }
                catch {
                    print(error.localizedDescription)
                }
                //database.close()
            }
    }

    
    
    
    ///////////////////////////////////////////////////////////////////////
    
    
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        
        return false
    }
    
    func insetMedicationHistoryData(datas:[MedicationHistory])
    {
        if openDatabase() {
            var query = ""
            for data in datas {
//                if checkMedicationState(data: data) == false
//                {
                    query += "insert into \(TABLE_MEDICATION) (\(KEY_MEDICATION_ID),\(KEY_MEDICATION_NAME),\(KEY_TAKE_TIME),\(KEY_EATEN_TIME),\(KEY_EAT_TEXT),\(KEY_DAY_TIME),\(KEY_DATE),\(KEY_PRESCRIPTION)) values(\(data.medicationId),'\(data.medicationName)','\(data.takeTime)','\(data.eatenTime)','\(data.eatText)','\(data.dayTime)','\(data.date)',\(data.prescription));"
//                }
            }
            if !database.executeStatements(query) {
                print("Failed to insert initial data into the database.")
                print(database.lastError(), database.lastErrorMessage())
            }
            //database.close()
        }
    }
    func insertPharmacyData(data:Pharmacy)
    {
        if openDatabase() {
            var query = ""
            
            
            query += "insert into \(TABLE_PHARMACY) (\(KEY_BRAND),\(KEY_ADDRESS),\(KEY_PHONE),\(KEY_LATITUDE),\(KEY_LONGITUDE)) values('\(data.brand)','\(data.address)','\(data.phone_number)','\(data.latitude)','\(data.longitude));"
            
            
            if !database.executeStatements(query) {
                print("Failed to insert initial data into the database.")
                print(database.lastError(), database.lastErrorMessage())
            }
            //database.close()
        }
    }
    func insertCommunityUser(datas:[CommunityUser])
    {
        if openDatabase() {
            var query = ""
            for data in datas {
                let name = data.firstname + data.lastname
                    query += "insert into \(TABLE_COMMUNITY_USER) (\(KEY_NAME),\(KEY_IMAGE)) values('\(name)','\(data.userimage));"
            }
            if !database.executeStatements(query) {
                print("Failed to insert initial data into the database.")
                print(database.lastError(), database.lastErrorMessage())
            }
            //database.close()
        }
    }
    
    func getPharmacy() -> [Pharmacy] {
        var datas:[Pharmacy] = []
        if openDatabase() {
            let query = "select * from " + TABLE_PHARMACY
            do {
                let results = try database.executeQuery(query, values: nil)
                while results.next() {
                    let pharmacy = Pharmacy.init(id: Int(results.string(forColumn: KEY_ID)!)!, brand: results.string(forColumn: KEY_BRAND)!, address: results.string(forColumn: KEY_ADDRESS)!, phone_number: KEY_PHONE, latitude: KEY_LATITUDE, longitude: KEY_LONGITUDE)
                    datas.append(pharmacy)
                    
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        return datas
    }
    
    
    func checkMedicationState(data:MedicationHistory) -> Bool {
        var counts : Int = 0
        if openDatabase() {
            let query = "select count(*) as counts from " + TABLE_MEDICATION + " where \(KEY_DAY_TIME)=? and \(KEY_MEDICATION_ID)=? and \(KEY_DATE)=?"
            
            do {
                print(database)
                let results = try database.executeQuery(query, values: [data.dayTime,data.medicationId,data.date])
                
                while results.next() {
                    
                    counts = Int(results.int(forColumn: "counts"))
               
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            
        }
        return counts > 0 ? true:false
    }
    
    func insetMedicationHistoryData1(datas:[MyMedication])
    {
        if openDatabase() {
            var query = ""
            for data in datas {
                if checkMedicationState1(data: data) == false
                {
                    /*
                    let createMoviesTableQuery1 = "CREATE TABLE " + TABLE_MEDICATION1 + "("
                        + KEY_ID + " INTEGER PRIMARY KEY autoincrement,"
                        + KEY_DIRECTION + " TEXT," + KEY_DOSE + " TEXT," +
                        KEY_QUANTITY + " TEXT," + KEY_PRESCRIBE + " TEXT," +
                        KEY_TAKE_TIME + " TEXT," + KEY_PHARMACY + " TEXT," +
                        KEY_MEDICATION_NAME + " TEXT," + KEY_STRENGTH + " TEXT," +
                        KEY_FIELDDATE + " TEXT," + KEY_FREQUENCY + " TEXT," +
                        KEY_LEFTTABLET + " TEXT," + KEY_CREATEAT + " TEXT," +
                        KEY_PRESCRIPTION + " INTEGER)"
                    */
                    query += "insert into \(TABLE_MEDICATION1) (\(KEY_DIRECTION),\(KEY_DOSE),\(KEY_QUANTITY),\(KEY_PRESCRIBE),\(KEY_TAKE_TIME),\(KEY_PHARMACY),\(KEY_MEDICATION_NAME),\(KEY_STRENGTH),\(KEY_FIELDDATE),\(KEY_FREQUENCY),\(KEY_LEFTTABLET),\(KEY_CREATEAT),\(KEY_PRESCRIPTION), \(KEY_AMOUNT), \(KEY_ASNEEDED)) values('\(data.directions)','\(data.dose)','\(data.quantity)','\(data.prescribe)','\(data.taketime)','\(data.pharmacy)','\(data.medicationname)','\(data.strength)','\(data.filedDate)','\(data.frequency)','\(data.lefttablet)','\(data.createat)',\(data.prescription), '\(data.amount)',\(data.asneeded));"
                    

                    
                    
                }
                else {
                    updateMedication1(data: data)
                }
            }
            if !database.executeStatements(query) {
                print("Failed to insert initial data into the database.")
                print(database.lastError(), database.lastErrorMessage())
            }
            //database.close()
        }
    }
    func checkMedicationState1(data:MyMedication) -> Bool {
        var counts : Int = 0
        if openDatabase() {
            let query = "select count(*) as counts from " + TABLE_MEDICATION1 + " where \(KEY_MEDICATION_NAME)=?"
            
            do {
                print(database)
                let results = try database.executeQuery(query, values: [data.medicationname])
                
                while results.next() {
                    
                    counts = Int(results.int(forColumn: "counts"))
                    
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            
        }
        return counts > 0 ? true:false
    }
    func updateMedication1(data:MyMedication) {
        if openDatabase() {
            var query = ""
            
            /*
             let createMoviesTableQuery1 = "CREATE TABLE " + TABLE_MEDICATION1 + "("
             + KEY_ID + " INTEGER PRIMARY KEY autoincrement,"
             + KEY_DIRECTION + " TEXT," + KEY_DOSE + " TEXT," +
             KEY_QUANTITY + " TEXT," + KEY_PRESCRIBE + " TEXT," +
             KEY_TAKE_TIME + " TEXT," + KEY_PHARMACY + " TEXT," +
             KEY_MEDICATION_NAME + " TEXT," + KEY_STRENGTH + " TEXT," +
             KEY_FIELDDATE + " TEXT," + KEY_FREQUENCY + " TEXT," +
             KEY_LEFTTABLET + " TEXT," + KEY_CREATEAT + " TEXT," +
             KEY_PRESCRIPTION + " INTEGER)"
             */
            
            query = "update \(TABLE_MEDICATION1) set \(KEY_DIRECTION)=?,\(KEY_DOSE)=?,\(KEY_QUANTITY)=?,\(KEY_PRESCRIBE)=?,\(KEY_TAKE_TIME)=?,\(KEY_PHARMACY)=?,\(KEY_STRENGTH)=?,\(KEY_FIELDDATE)=?,\(KEY_FREQUENCY)=?,\(KEY_LEFTTABLET)=?,\(KEY_CREATEAT)=?,\(KEY_PRESCRIPTION)=?,\(KEY_AMOUNT)=?, \(KEY_ASNEEDED)=? where \(KEY_MEDICATION_NAME)=?"
            
            do {
                try database.executeUpdate(query, values: [data.directions,data.dose,data.quantity,data.prescribe,data.taketime,data.pharmacy,data.strength,data.filedDate,data.frequency,data.lefttablet,data.createat,data.prescription,data.medicationname,data.amount,data.asneeded])
            }
            catch {
                print(error.localizedDescription)
            }
            
            
            //database.close()
        }
        
    }
    
    func getMedications() -> [MyMedication] {
        var datas:[MyMedication] = []
        if openDatabase() {
            let query = "select * from " + TABLE_MEDICATION1
            do {
                let results = try database.executeQuery(query, values: nil)
                while results.next() {
                    let medicationshistory = MyMedication.init(prescribe: results.string(forColumn: KEY_PRESCRIBE)!, directions: results.string(forColumn: KEY_DIRECTION)!, dose: results.string(forColumn: KEY_DOSE)!, image: "", quantity: Int(results.string(forColumn: KEY_QUANTITY)!)!, type: "", taketime: results.string(forColumn: KEY_TAKE_TIME)!, medicationname: results.string(forColumn: KEY_MEDICATION_NAME)!, filedDate: results.string(forColumn: KEY_FIELDDATE)!, warning: "", frequency: results.string(forColumn: KEY_FREQUENCY)!, strength: results.string(forColumn: KEY_STRENGTH)!, pharmacy: results.string(forColumn: KEY_PHARMACY)!, patientname: "", lefttablet: results.string(forColumn: KEY_LEFTTABLET)!, prescription: Int(results.int(forColumn: KEY_PRESCRIPTION)), createat: results.string(forColumn: KEY_CREATEAT)!, endat: "", id:Int(results.string(forColumn: KEY_ID)!)!, amount: results.string(forColumn: KEY_AMOUNT)!, asneeded: Int(results.string(forColumn: KEY_ASNEEDED)!)!)
                    datas.append(medicationshistory)
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        return datas
    }
    
    
    func deleteMedicationDrug1(name:String) -> Bool {
        if openDatabase() {
            var query = ""
            
            query = "delete from \(TABLE_MEDICATION1) where \(KEY_MEDICATION_NAME)=?"
            
            do {
                try database.executeUpdate(query, values: [name])
            }
            catch {
                print(error.localizedDescription)
            }
            //database.close()
        }
        return true
    }
    
    func deleteTmpDrug() -> Bool {
        if openDatabase() {
            var query = ""
            
            query = "delete from \(TABLE_MEDICATION1) "
            
            do {
                try database.executeUpdate(query, values: nil)
            }
            catch {
                print(error.localizedDescription)
            }
            //database.close()
        }
        return true
    }
    
    func getTimesOfDay(data: MedicationHistory) -> [MedicationTime] {
        var datas:[MedicationTime] = []
        
        if openDatabase() {
            let query = "select count(*) as counts,\(KEY_TAKE_TIME),\(KEY_MEDICATION_NAME) from " + TABLE_MEDICATION + " where \(KEY_DAY_TIME)=? and \(KEY_DATE)=? and \(KEY_PRESCRIPTION)=? group by \(KEY_TAKE_TIME) order by \(KEY_TAKE_TIME) asc"
          
            
            do {
                print(database)
                let results = try database.executeQuery(query, values: [data.dayTime,data.date,data.prescription])
                
                while results.next() {
                    let medicationshistory = MedicationTime.init(time: results.string(forColumn: KEY_TAKE_TIME)!,count: Int(results.int(forColumn: "counts")),medicationName: results.string(forColumn: KEY_MEDICATION_NAME)!)
                    datas.append(medicationshistory)
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        return datas
    }
    
    func getMedicationInfos(daytime:String,date:String,takeTime:String,prescription:Int) -> [MedicationHistory] {
        var datas:[MedicationHistory] = []
        
        if openDatabase() {
            let query = "select * from \(TABLE_MEDICATION)  where \(KEY_DAY_TIME)=? and \(KEY_DATE)=? and \(KEY_TAKE_TIME)=? and \(KEY_PRESCRIPTION)=?"
            
            do {
                print(database)
                let results = try database.executeQuery(query, values: [daytime,date,takeTime,prescription])
                
                while results.next() {
                    let medicationshistory = MedicationHistory.init(id: Int(results.int(forColumn: KEY_ID)), medicationId: Int(results.int(forColumn: KEY_MEDICATION_ID)), date: results.string(forColumn: KEY_DATE)!, takeTime: results.string(forColumn: KEY_TAKE_TIME)!, eatenTime: results.string(forColumn: KEY_EATEN_TIME)!, eatText: results.string(forColumn: KEY_EAT_TEXT)!, medicationName: results.string(forColumn: KEY_MEDICATION_NAME)!, dayTime: results.string(forColumn: KEY_DAY_TIME)!,prescription: Int(results.int(forColumn: KEY_PRESCRIPTION)))
                    datas.append(medicationshistory)
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        return datas
    }
    
    func getMedicationInfosById(id:Int) -> [MedicationHistory] {
        var datas:[MedicationHistory] = []
        
        if openDatabase() {
            let query = "select * from \(TABLE_MEDICATION1)  where \(KEY_ID)=?"
            
            do {
                print(database)
                let results = try database.executeQuery(query, values: [id])
                
                while results.next() {
                    let medicationshistory =  MedicationHistory.init(id: Int(results.int(forColumn: KEY_ID)), medicationId: Int(results.int(forColumn: KEY_ID)), date: results.string(forColumn: KEY_CREATEAT)!, takeTime: results.string(forColumn: KEY_TAKE_TIME)!, eatenTime: results.string(forColumn: KEY_DOSE)!, eatText: results.string(forColumn: KEY_PRESCRIBE)!, medicationName: results.string(forColumn: KEY_MEDICATION_NAME)!, dayTime: results.string(forColumn: KEY_LEFTTABLET)!, prescription: Int(results.int(forColumn: KEY_PRESCRIPTION)))
                    datas.append(medicationshistory)
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        return datas
    }
    func getMedicationInfosById1(id:Int) -> [MedicationHistory] {
        var datas:[MedicationHistory] = []
        
        if openDatabase() {
            let query = "select * from \(TABLE_MEDICATION)  where \(KEY_ID)=?"
            
            do {
                print(database)
                let results = try database.executeQuery(query, values: [id])
                
                while results.next() {
                    let medicationshistory = MedicationHistory.init(id: Int(results.int(forColumn: KEY_ID)), medicationId: Int(results.int(forColumn: KEY_MEDICATION_ID)), date: results.string(forColumn: KEY_DATE)!, takeTime: results.string(forColumn: KEY_TAKE_TIME)!, eatenTime: results.string(forColumn: KEY_EATEN_TIME)!, eatText: results.string(forColumn: KEY_EAT_TEXT)!, medicationName: results.string(forColumn: KEY_MEDICATION_NAME)!, dayTime: results.string(forColumn: KEY_DAY_TIME)!,prescription: Int(results.int(forColumn: KEY_PRESCRIPTION)))
                    datas.append(medicationshistory)
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        return datas
    }
    func getMedicationInfoArray(daytime:String,date:String,medicationId:Int) -> [MedicationHistory] {
        var datas:[MedicationHistory] = []
        if openDatabase() {
//            let query = "select * from \(TABLE_MEDICATION)  where \(KEY_DAY_TIME)=? and \(KEY_DATE)=? and \(KEY_MEDICATION_ID)=?"
            let query = "select * from \(TABLE_MEDICATION)"
            
            do {
//                let results = try database.executeQuery(query, values: [daytime,date,medicationId])
                let results = try database.executeQuery(query, values: [])
                
                while results.next() {
                    let medicationshistory = MedicationHistory.init(id: Int(results.int(forColumn: KEY_ID)), medicationId: Int(results.int(forColumn: KEY_MEDICATION_ID)), date: results.string(forColumn: KEY_DATE)!, takeTime: results.string(forColumn: KEY_TAKE_TIME)!, eatenTime: results.string(forColumn: KEY_EATEN_TIME)!, eatText: results.string(forColumn: KEY_EAT_TEXT)!, medicationName: results.string(forColumn: KEY_MEDICATION_NAME)!, dayTime: results.string(forColumn: KEY_DAY_TIME)!,prescription: Int(results.int(forColumn: KEY_PRESCRIPTION)))
                    datas.append(medicationshistory)
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        return datas
    }
    
    func saveMedicationInfo(id:Int,eatTime:String,eatText:String) {
        if openDatabase() {
            var query = ""
            query = "update \(TABLE_MEDICATION) set \(KEY_EATEN_TIME)=?,\(KEY_EAT_TEXT)=? where \(KEY_ID)=?"
            
            do {
                try database.executeUpdate(query, values: [eatTime, eatText,id])
            }
            catch {
                print(error.localizedDescription)
            }
            
            
            //database.close()
        }
        
    }
    
    func updateMedicationTakeTime(id:Int,eatTime:String,eatText:String,taketime:String) {
        if openDatabase() {
            var query = ""
            query = "update \(TABLE_MEDICATION) set \(KEY_EATEN_TIME)=?,\(KEY_EAT_TEXT)=?,\(KEY_TAKE_TIME)=? where \(KEY_ID)=?"
            
            do {
                try database.executeUpdate(query, values: [eatTime, eatText,taketime,id])
            }
            catch {
                print(error.localizedDescription)
            }
            
            
            //database.close()
        }
        
    }
    
    func saveMedicationInfos(datas:[MedicationHistory]) -> Bool {
        if openDatabase() {
            var query = ""
            for data in datas {
                query = "update \(TABLE_MEDICATION) set \(KEY_EATEN_TIME)=? where \(KEY_ID)=?"
            
                do {
                    try database.executeUpdate(query, values: [data.eatenTime, data.id])
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            
            //database.close()
        }
        return true
    }
    
    func deleteMedicationDrug(id:Int) -> Bool {
        if openDatabase() {
            var query = ""
            
                query = "delete from \(TABLE_MEDICATION) where \(KEY_ID)=?"
                
                do {
                    try database.executeUpdate(query, values: [id])
                }
                catch {
                    print(error.localizedDescription)
                }
            
            
            //database.close()
        }
        return true
    }
    
    func deleteAllDrug(){
        if openDatabase() {
            var query = ""
            
            query = "delete from \(TABLE_MEDICATION)"
            
            do {
                try database.executeUpdate(query, values:nil)
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}
