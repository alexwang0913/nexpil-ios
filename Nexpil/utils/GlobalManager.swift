//
//  GlobalManager.swift
//  Nexpil
//
//  Created by Guang on 9/29/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import UIKit

class GlobalManager {
    static var TAB_ITEMS: [TabObj] = [TabObj]()
    
    static func GetToday() -> Date {
        let currentDate = Date()
        let timezoneOffset =  TimeZone.current.secondsFromGMT()
        let epochDate = currentDate.timeIntervalSince1970
        let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
        let today = Date(timeIntervalSince1970: timezoneEpochOffset)
        return today
    }
    
    static func capitalizeFirstLetters(_ originText: String) -> String {
        let subTexts = originText.components(separatedBy: " ")
        var result = ""
        for (idx, text) in subTexts.enumerated() {
            if idx < 3 {
                result += text.prefix(1).uppercased() + text.lowercased().dropFirst() + " "
            } else {
                result += text + " "
            }
        }
        
        return result
    }
    
    static func compareDate(_ date1: Date, _ date2: Date) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        
        if formatter.string(from: date1) == formatter.string(from: date2) {
            return true
        }
        return false
    }
    
    /**
        Convrt String to Number. For instance one -> 1, two -> 2
     */
    static func convertStringToNumber(_ keyword: String) -> Int {
        if Int(keyword) != nil {
            return Int(keyword)!
        }
        let charNumbers = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"]
        for (idx, char) in charNumbers.enumerated() {
            if char == keyword {
                return idx + 1
            }
        }
        return 0
    }
}
