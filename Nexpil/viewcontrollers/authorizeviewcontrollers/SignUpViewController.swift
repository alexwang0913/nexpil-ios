//
//  SignUpViewController.swift
//  Nexpil
//
//  Created by Admin on 4/8/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

import SkyFloatingLabelTextField

import Alamofire

class SignUpViewController: InformationCardEditViewController {

    var currentTextField = 0
    var passwordShow = true
    var confirmpasswordShow = true
    
    @IBOutlet weak var backBtn: GradientView!
    
    @IBOutlet weak var fullName: InformationCard!
    @IBOutlet weak var emailAddress: InformationCard!
    @IBOutlet weak var password: InformationCard!
    @IBOutlet weak var phoneNum: InformationCard!
    
    
    @IBOutlet weak var signupBtn: GradientView!
    override func viewDidLoad() {
        super.viewDidLoad()        
        let logoImage = UIImage(named: "nexpil logo - alternate")
        self.navigationItem.titleView = UIImageView(image: logoImage)
        self.navigationItem.rightBarButtonItem = nil
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fullName.value!.text = DataUtils.getPatientFullName()
        emailAddress.value!.text = DataUtils.getEmail()
        password.value!.text = DataUtils.getPassword()
        phoneNum.value!.text = UserDefaults.standard.string(forKey: "phone_number")
        if fullName.value.text == ""
        {
            fullName.value.text = "Full Name"
            fullName.value.textColor = UIColor.init(hex: "333333", alpha: 0.5)
            fullName.identifier.text = ""
            fullName.identifier.isHidden = true
        }
        else {
            fullName.value.textColor = UIColor.init(hex: "333333")
            fullName.identifier.isHidden = false
        }
        if emailAddress.value.text == ""
        {
            emailAddress.value.text = "Email Address"
            emailAddress.value.textColor = UIColor.init(hex: "333333", alpha: 0.5)
            emailAddress.identifier.text = ""
            emailAddress.identifier.isHidden = true
        }
        else {
            emailAddress.value.textColor = UIColor.init(hex: "333333")
            emailAddress.identifier.isHidden = false
        }
        if password.value.text == ""
        {
            password.value.text = "Password"
            password.value.textColor = UIColor.init(hex: "333333", alpha: 0.5)
            password.identifier.text = ""
            password.identifier.isHidden = true
        }
        else {
            password.value.textColor = UIColor.init(hex: "333333")
            password.identifier.isHidden = false
        }
        
        if phoneNum.value.text == ""
        {
            phoneNum.value.text = "Phone Number"
            phoneNum.value.textColor = UIColor.init(hex: "333333", alpha: 0.5)
            phoneNum.identifier.text = ""
            phoneNum.identifier.isHidden = true
        }
        else {
            phoneNum.value.textColor = UIColor.init(hex: "333333")
            phoneNum.identifier.isHidden = false
        }
    }
    
    @IBAction func userSignup(_ sender: Any) {
        if DataUtils.getPatientFullName() == ""
        {
            DataUtils.messageShow(view: self, message: "Please input Full Name", title: "")
            return
        }
        if DataUtils.getEmail() == ""
        {
            DataUtils.messageShow(view: self, message: "Please input email address", title: "")
            return
        }
        if DataUtils.isValidEmailAddress(emailAddressString: DataUtils.getEmail()!) == false
        {
            DataUtils.messageShow(view: self, message: "Please input valid email", title: "")
            return
        }
        if DataUtils.getPassword() == ""
        {
            DataUtils.messageShow(view: self, message: "Please input password", title: "")
            return
        }
        if UserDefaults.standard.string(forKey: "phone_number") == "" {
            DataUtils.messageShow(view: self, message: "Please input phone number", title: "")
            return
        }
        gotoSignupAndMedication()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func convertToDictionary(datas:[MyMedication]) -> [[String : Any]] {
        var dics = [[String : Any]]()
        for data in datas
        {
            if data.asneeded == 1 {
                let dic: [String: Any] = ["direction":data.directions, "dose":data.dose, "quantity":data.quantity, "prescribe":data.prescribe, "taketime":data.taketime, "patientname":data.patientname, "pharmacy":data.pharmacy,"medicationname":data.medicationname,"strength":data.strength,"filed_date":data.filedDate,"warnings":data.warnings,"frequency":data.frequency,"lefttablet":data.lefttablet,"prescription":data.prescription,"createat":data.createat, "endat":data.endat, "amount": data.amount, "asneeded": 1]
                dics.append(dic)
            } else {
                let timings = data.taketime.components(separatedBy: ",") as [String]
                for time in timings {
                    let dic: [String: Any] = ["direction":data.directions, "dose":data.dose, "quantity":data.quantity, "prescribe":data.prescribe, "taketime":time.trimmingCharacters(in: .whitespaces), "patientname":data.patientname, "pharmacy":data.pharmacy,"medicationname":data.medicationname,"strength":data.strength,"filed_date":data.filedDate,"warnings":data.warnings,"frequency":data.frequency,"lefttablet":data.lefttablet,"prescription":data.prescription,"createat":data.createat, "endat":data.endat, "amount": data.amount]
                    dics.append(dic)
                }
            }
        }
        return dics
//        var dics = [[String : Any]]()
//        for data in datas
//        {
//            let dic: [String: Any] = ["direction":data.directions, "dose":data.dose, "quantity":data.quantity, "prescribe":data.prescribe, "taketime":"", "patientname":data.patientname, "pharmacy":data.pharmacy,"medicationname":data.medicationname,"strength":data.strength,"filed_date":data.filedDate,"warnings":data.warnings,"frequency":data.frequency,"lefttablet":data.lefttablet,"prescription":data.prescription,"createat":data.createat]
//            dics.append(dic)
//        }
//        return dics
    }
    
    func gotoSignupAndMedication()
    {
        do {
            var datas:[MyMedication] = DBManager.getObject().getMedications()
            for i in 0..<datas.count {
                let endDate = Date().addingTimeInterval(TimeInterval(3600 * 24 * 7))
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd hh:mm"
                datas[i].endat = formatter.string(from: endDate)
            }
            let dicArray = convertToDictionary(datas:datas)
            let jsonData = try JSONSerialization.data(withJSONObject: dicArray, options: [])
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                let params = [
                    "datas" : JSONString,                    
                    "email" : emailAddress.value.text!,
                    "password" : password.value.text!,
                    "phone_number" : phoneNum.value.text!,
                    "first_name" : fullName.value.text!,
                    "last_name" : "",
                    "usertype" : "patient",
                    "choice" : "4"
                    ] as [String : Any]
                DataUtils.customActivityIndicatory(self.view,startAnimate: true)
                Alamofire.request(DataUtils.APIURL + DataUtils.MYDRUG_URL, method: .post, parameters: params)
                    .responseJSON(completionHandler: { response in
                        DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                        
                        if let data = response.result.value {
                            let json : [String:Any] = data as! [String : Any]
                            let result = json["status"] as? String
                            if result == "true"
                            {
                              //  let _ = DBManager.getObject().deleteMedicationDrug2()
                                let message = json["message"] as! String
                                let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
                                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                    DataUtils.setSkipButton(time: true)                                    
                                    let defaults = UserDefaults.standard
                                    defaults.set(self.password.value.text!, forKey: "password")
                                    let patientInfo = PatientInfo.init(json: json["userinfo"] as! [String:Any])
                                    patientInfo.saveUserInfo()
                                    DBManager.getObject().deleteTmpDrug()
                                    
                                    self.gotoMainScreen()
                                }
                                alert.addAction(OKAction)
                                self.present(alert, animated: true, completion: nil)
                            }
                            else
                            {
                                let message = json["message"] as! String
                                DataUtils.messageShow(view: self, message: message, title: "")
                            }
                        } else {
                            DataUtils.messageShow(view: self, message: response.error!.localizedDescription, title: "")
                        }
                    })
            }
        }
        catch {
            
        }
    }
    
    func gotoSignup()
    {
        let localTimeZoneName = TimeZone.current.identifier
        let deviceToken = UserDefaults.standard.value(forKey: "DeviceToken") as? String ?? ""
        
        let params = [
            "email" : emailAddress.value.text!,
            "password" : password.valueText,
            "phone_number" : phoneNum.value.text!,
            "first_name" : fullName.valueText,
            "last_name" : "",
            "usertype" : DataUtils.getPatient()!,
            "choice" : "0",
            "timezone": localTimeZoneName,
            "deviceToken": deviceToken
            ] as [String : Any]
        
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        Alamofire.request(DataUtils.APIURL + DataUtils.AUTH_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                
                debugPrint(response);
                
                if let data = response.result.value {                    
                    let json : [String:Any] = data as! [String : Any]
                    let result = json["status"] as? String
                    if result == "true"
                    {
                        let defaults = UserDefaults.standard
                        defaults.set(self.password.valueText, forKey: "password")
                        let patientInfo = PatientInfo.init(json: json["userinfo"] as! [String:Any])
                        patientInfo.saveUserInfo()
                        self.gotoMainScreen()
                    }
                    else
                    {
                        let message = json["message"] as! String
                        DataUtils.messageShow(view: self, message: message, title: "")
                    }
                }
            })
    }
    
    func gotoMainScreen()
    {
        setupTimeRange()
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VCNotificationEnable") as! VCNotificationEnable
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: false, completion: nil)
    }
    
    func setupTimeRange() {
        DataUtils.setTimeRange(index: 0, time: "1:00-11:59")
        DataUtils.setTimeRange(index: 1, time: "12:00-16:59")
        DataUtils.setTimeRange(index: 2, time: "17:00-19:59")
        DataUtils.setTimeRange(index: 3, time: "20:00-23:59")
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
