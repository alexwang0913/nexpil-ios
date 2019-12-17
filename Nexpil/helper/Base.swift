//
//  Base.swift
//  Nexpil
//
//  Created by Ajai Nair on 4/4/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

var FrostGlassBackground:VisualEffectView!
var FrostGlassBackground1:VisualEffectView!
func Global_ShowFrostGlass(_ vw: UIView!){
    vw.insertSubview(FrostGlassBackground, at: 0)
}

func Global1_ShowFrostGlass(_ vw: UIView!){
    vw.insertSubview(FrostGlassBackground1, at: 0)
}

func Global_SetGlassEffect(){
    FrostGlassBackground = VisualEffectView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    FrostGlassBackground.colorTint = UIColor.black
    FrostGlassBackground.colorTintAlpha = 0.5
    FrostGlassBackground.blurRadius = 5
    FrostGlassBackground.scale = 1
}

func Global_SetGlassEffect1(){
    FrostGlassBackground1 = VisualEffectView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    FrostGlassBackground1.colorTint = UIColor.black
    FrostGlassBackground1.colorTintAlpha = 0.5
    FrostGlassBackground1.blurRadius = 5
    FrostGlassBackground1.scale = 1
}

func Global_HideFrostGlass(){
    FrostGlassBackground.removeFromSuperview()
}

func Global_CenterView(_ view:UIView!){
    let parent = view.superview!
    view.frame = CGRect(x: (parent.frame.size.width - view.frame.size.width) / 2, y: view.frame.origin.y, width: view.frame.size.width, height: view.frame.size.height)
}

func Global_HttpErrorHandle(_ error: JSONError){
    switch error {
    case .noInternetConnection:
        showAlert(title: "Connection Error", message: "Please Check your Internet Connection.")
    case .payloadSerialization:
        showAlert(title: "Data Error", message: "Request Data is invalid.")
    case .invalidURL:
        showAlert(title: "Url Error", message: "Url is invalid.")
    case .requestFailed(let er):
        showAlert(title: "Request Failed", message: er.localizedDescription)
    case .nonHTTPResponse:
        showAlert(title: "Response Error", message: "No http response.")
    case .responseDeserialization:
        showAlert(title: "Response Parse Error", message: "Response is not JSON format.")
    case .unknownError:
        showAlert(title: "Unknown Error", message: "Internal Server Error")
    }
}

func showAlert(title: String?, message: String?, handler: (() -> ())? = nil) {
    DispatchQueue.main.async {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            handler?()
            alert.dismiss(animated: true, completion: nil)
        }))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }
}

func showAlert(_ vc: UIViewController, title: String?, message: String?, handler: (() -> ())? = nil) {
    DispatchQueue.main.async {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            handler?()
            alert.dismiss(animated: true, completion: nil)
        }))
        
        vc.present(alert, animated: true)
    }
}

func showAlert(title: String?, message: String?, actionTitle: String, block: (() -> ())? = nil) {
    showAlert(title: title, message: message, cancelTitle: "OK", actionTitle: actionTitle, block: block)
}

func showAlert(title: String?, message: String?, cancelTitle: String?, actionTitle: String, block: (() -> ())? = nil) {
    DispatchQueue.main.async {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { _ in
            block?()
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }
}

func showAlert(_ vc: UIViewController, title: String?, message: String?, cancelTitle: String?, actionTitle: String, block: (() -> ())? = nil) {
    DispatchQueue.main.async {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { _ in
            block?()
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        vc.present(alert, animated: true)
    }
}

let healthManager = DataManager()
func getBloodGlocose() -> String {
    let array = healthManager.fetchBloodGlucoseGetAllDaysData()
    if array.count > 0 {
        let data = ((array[0] as! NSDictionary)["data"] as! NSArray)[0] as! BloodGlucose
        let value = data.value
        
        return String(format: "%ld", value)
        
    } else {
        return ""
    }
}

func getBloodPressure() -> String {
    let array = healthManager.fetchBloodPressureGetAllDaysData()
    if array.count > 0 {
        let data = ((array[0] as! NSDictionary)["data"] as! NSArray)[0] as! BloodPressure
        let value1 = data.value1
        let value2 = data.value2
        
        return String(format: "%ld/%ld", value1, value2)
    } else {
        return ""
    }
}

func getOxygenlevel() -> String {
    let array = healthManager.fetchOxygenLevelGetAllDaysData()
    if array.count > 0 {
        let data = ((array[0] as! NSDictionary)["data"] as! NSArray)[0] as! OxygenLevel
        let value = data.value
        
        return String(format: "%ld", value)
    } else {
        return ""
    }
}

func getMood() -> String {
    let array = healthManager.fetchMood()
    if array.count > 0 {
        let data = array.firstObject as! Mood
        let value = Int(data.feeling)
        
//        let arrayFeeling = [
//            ["index": "0", "imageName": "feel_0", "title": "Very Sad"],
//            ["index": "1", "imageName": "feel_1", "title": "Sad"],
//            ["index": "2", "imageName": "feel_2", "title": "Neutral"],
//            ["index": "3", "imageName": "feel_3", "title": "Happy"],
//            ["index": "4", "imageName": "feel_4", "title": "Very Happy"],
//        ]
        let arrayFeeling = ["Very Sad", "Sad", "Neutral", "Happy", "Very Happy"]
        return arrayFeeling[value]
//        return String(format: "%@", ((arrayFeeling[value] as NSDictionary).value(forKey: "title") as! String))
    } else {
        return ""
    }
}

func getSteps() -> String {
    let array = healthManager.fetchStepsGetAllDaysData()
    if array.count > 0 {
        let dic = array[0] as! NSDictionary
        if dic.value(forKey: "data") != nil {
            let arrayDic = dic.value(forKey: "data") as! NSArray
            if arrayDic.count > 0 {
                let data = arrayDic[0] as! Steps
                let value = data.value
                return String(format: "%0.0f", value)
            } else {
                return ""
            }
        } else {
            return ""
        }
        
    } else {
        return ""
    }
}

func getWeight() -> String {
    let array = healthManager.fetchWeightGetAllWeekData()
    
    if array.count > 0 {
        let value = (((array[0] as! NSDictionary)["data"] as! NSArray)[0] as! NSDictionary)["value"] as! Double
        
        return String(format: "%0.0f", value)
    } else {
        return ""
//        if UserDefaults.standard.value(forKey: "weight") != nil {
//            let weight = UserDefaults.standard.value(forKey: "weight") as! Double
//
//            return String(format: "%.0f", weight * 2.2)
//        } else {
//            return ""
//        }
    }
}

func getHemoglobinAlc() -> String {
    let array = healthManager.fetchHemoglobinAlc()
    if array.count > 0 {
        let data = array[0] as! HemoglobinAlc
        let value = data.value
        
        return String(format: "%0.1f", value)
    } else {
        return "0.0"
    }
}

func getLipidPanel() -> String {
    let array = healthManager.fetchLipidPanelGetAllYearData(index: "HDL")
    if array.count > 0 {
        let data = ((array[0] as! NSDictionary)["data"] as! NSArray)[0] as! NSDictionary
        let value = (data["average"] as! NSNumber).stringValue
        
        return String(format: "%@", value)
    } else {
        return "00"
    }
}

func getINR() -> String {
    let array = healthManager.fetchINR()
    if array.count > 0 {
        let data = array[0] as! INR
        let value = data.value
        
        return String(format: "%0.1f", value)
    } else {
        return "0.0"
    }
}
