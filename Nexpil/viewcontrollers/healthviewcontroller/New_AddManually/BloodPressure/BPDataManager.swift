//
//  BPDataManager.swift
//  Nexpil
//
//  Created by Guang on 11/3/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

class BPDataManager {
    public static var Measurement = ""
    public static var Date = GlobalManager.GetToday()
    
    public static func SendData() -> Bool {
        let value1 = (Measurement.components(separatedBy: "/")[0] as NSString).integerValue
        let value2 = (Measurement.components(separatedBy: "/")[1] as NSString).integerValue
        return DataManager().insertBloodPressure(date: Date, time: GetTiming(), timeIndex: GetTimeIndex(), value1: value1, value2: value2)
    }
    
    public static func GetTiming() -> String {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "GMT")!
        var hour = calendar.component(.hour, from: Date)
        var min = calendar.component(.minute, from: Date)
        min = (min/5) * 5
        if hour > 12 {
            hour -= 12
            return "\(hour):\(min)pm"
        } else {
            return "\(hour):\(min)am"
        }
    }
    
    public static func GetTimeIndex() -> String {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "GMT")!
        let hour = calendar.component(.hour, from: Date)
        
        if hour >= 1 && hour <= 11 {
            return "0"
        } else if hour == 0 || (hour >= 12 && hour <= 14) {
            return "1"
        } else if hour >= 15 && hour <= 23 {
            return "2"
        }
        return "0"
    }
    
    public static func GetDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        return formatter.string(from: Date)
    }
}
