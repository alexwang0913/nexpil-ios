//
//  CommunityOnboardingSignupViewController.swift
//  Nexpil
//
//  Created by mac on 6/30/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Alamofire

class CommunityOnboardingSignupViewController: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNum: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPasswordRepeat: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onContinue(){
        
        if txtName.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input name", title: "")
            return
        }
        if txtPhoneNum.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input phone number", title: "")
            return
        }
        if txtPassword.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input password", title: "")
            return
        }
        if txtEmail.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input email address", title: "")
            return
        }
        if DataUtils.isValidEmailAddress(emailAddressString: txtEmail.text!) == false
        {
            DataUtils.messageShow(view: self, message: "Please input valid email address", title: "")
            return
        }
        if txtPassword.text! != txtPasswordRepeat.text! {
            DataUtils.messageShow(view: self, message: "Passwords mismatch", title: "")
            return
        }
        self.view.endEditing(true)
        
        let localTimeZoneName = TimeZone.current.identifier
        let deviceToken = UserDefaults.standard.value(forKey: "DeviceToken") as? String ?? ""
        let params = [
            "email" : txtEmail.text!,
            "password" : txtPassword.text!,
            "phone_number" : txtPhoneNum.text!,
            "first_name" : txtName.text!,            
            "usertype" : "patient",
            "choice" : "0",
            "timezone": localTimeZoneName,
            "deviceToken": deviceToken
            ] as [String : Any]        
        
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        Alamofire.request(DataUtils.APIURL + DataUtils.AUTH_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                if let data = response.result.value {
                    let json : [String:Any] = data as! [String : Any]
                    let result = json["status"] as? String
                    if result == "true"
                    {
                        let defaults = UserDefaults.standard
                        defaults.set(self.txtPassword.text!, forKey: "password")
                        let patientInfo = PatientInfo.init(json: json["userinfo"] as! [String:Any])
                        patientInfo.saveUserInfo()
                        DataUtils.setTimeRange(index: 0, time: "1:00-11:59")
                        DataUtils.setTimeRange(index: 1, time: "12:00-16:59")
                        DataUtils.setTimeRange(index: 2, time: "17:00-19:59")
                        DataUtils.setTimeRange(index: 3, time: "20:00-23:59")
                        self.addUser()
                    }
                    else
                    {
                        let message = json["message"] as! String
                        DataUtils.messageShow(view: self, message: message, title: "")
                    }
                } else {
                    DataUtils.messageShow(view: self, message: "Server Error", title: "")
                }
            })
    }
    
    func addUser(){
        let usercode = UserDefaults.standard.string(forKey: "signup_usercode")
        let params = [
            "userid" : PreferenceHelper().getId(),
            "choice" : "2",
            "usercode" : usercode ?? ""
            ] as [String : Any]
        Alamofire.request(DataUtils.APIURL + DataUtils.COMMUNITYUSERS_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                if let data = response.result.value {
                    let json : [String:Any] = data as! [String : Any]
                    print(json)
                    let result = json["status"] as? String
                    if result == "true"
                    {
                        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VCNotificationEnable") as! VCNotificationEnable
                        viewController.m_communityUserData = (json["data"] as! [[String: Any]])[0]
                        viewController.isCommunityUser = true
                        self.present(viewController, animated: false, completion: nil)
                        
                        
                    }
                    else {
                        let message = json["message"] as! String
                        DataUtils.messageShow(view: self, message: message, title: "")
                    }
                } else {
                    DataUtils.messageShow(view: self, message: "Server Error", title: "")
                }
            })
    }
}
