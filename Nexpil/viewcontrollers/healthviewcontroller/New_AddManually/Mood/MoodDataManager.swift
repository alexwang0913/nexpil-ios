//
//  MoodDataManager.swift
//  Nexpil
//
//  Created by Guang on 11/5/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

class MoodDataManager {
    static var Date = GlobalManager.GetToday()
    static var Feeling = 0
    static var Note = ""
    
    static func SendData() -> Bool {
        return DataManager().insertMood(date: Date, feeling: Feeling, notes: Note)
    }
    
    static func GetFeelingString() -> String {
        let feelingStrList = ["Very Sad", "Sad", "Neutral", "Happy", "Very Happy"]
        return feelingStrList[Feeling]
    }
}
