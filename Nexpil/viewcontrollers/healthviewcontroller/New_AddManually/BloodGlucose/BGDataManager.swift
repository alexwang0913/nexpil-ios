//
//  BGStaticManager.swift
//  Nexpil
//
//  Created by Guang on 11/3/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import Alamofire

public class BGDataManager {
    public static var Measurement = ""
    public static var Timing = 0
    public static var Date: Date?
    
    public static func GetTiming() -> String {
        let timingStrList = ["Before Breakfast", "Before Lunch", "Before Dinner", "After Breakfast", "After Lunch", "After Dinner"]
        return timingStrList[Timing]
    }
    
    public static func GetDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        return formatter.string(from: Date!)
    }
    
    
    public static func SendData()->Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        
        return DataManager().insertBloodGlucose(date: Date!, whenIndex: "\(Timing)", value: (Measurement as NSString).integerValue)
//        let params = [
//            "choice": 0,
//            "measurement": Measurement,
//            "timing": Timing,
//            "date": formatter.string(from: Date!),
//            "userid": PreferenceHelper().getId()
//            ] as [String : Any]
//
//        Alamofire.request(DataUtils.APIURL + DataUtils.HEALTH_BLOODGLUCOSE_URL, method: .post, parameters: params)
//            .responseJSON(completionHandler: { response in
//                switch response.result {
//                case .success:
//                    handler(true)
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    handler(false)
//                }
//            })
    }
}
