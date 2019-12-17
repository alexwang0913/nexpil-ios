//
//  LoginScreenViewController.swift
//  Nexpil
//
//  Created by Cagri Sahan on 9/23/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Alamofire

class LoginScreenViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var addressField: InformationCardEditable!
    @IBOutlet weak var passwordField: InformationCardEditable1!
    @IBOutlet weak var signinButtonBottomConstraint: NSLayoutConstraint!
    
    public var m_forgetPasswordProc = 0
    
    private var originalBottomConstraint: CGFloat?
    private let center = NotificationCenter.default
    private var keyboardHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.showHideButton.isHidden = true
        addressField.textView.delegate = self
        passwordField.textView.delegate = self
        UINavigationBar.appearance().barTintColor = UIColor.init(hex: "#FCFCFC")

        let backImage = UIImage(named: "Back")
        let logoImage = UIImage(named: "nexpil logo - alternate")
        self.navigationItem.titleView = UIImageView(image: logoImage)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(self.closeWindow))
        
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        addressField.textView.keyboardType = .emailAddress
        passwordField.textView.returnKeyType = .go
        addressField.textView.returnKeyType = .go
        
        originalBottomConstraint = signinButtonBottomConstraint.constant
        
        center.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        addressField.textView.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    @objc func closeWindow()
    {
        dismiss(animated: false, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        if DataUtils.getEmail()?.isEmpty == false
        {
            addressField.textView.text = DataUtils.getEmail()
        }
        if DataUtils.getPassword()?.isEmpty == false
        {
            passwordField.textView.text = DataUtils.getPassword()
        }
    }
    
    public func ProcessForgetPassword() {        
        switch m_forgetPasswordProc {
        case 1:
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ResetPasswordCodeVC") as! ResetPasswordCodeVC
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            self.present(vc, animated: false)
            break
        case 2:
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ForgetPassword") as! ForgetPassword
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            self.present(vc, animated: false)
            break
        case 3:
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "DoneVC") as! DoneVC
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            self.present(vc, animated: false)
            break
        default:
            break
        }
    }
    
    
    @IBAction func userSignin(_ sender: Any) {
  
        if addressField.textView.text!.isEmpty {
            DataUtils.messageShow(view: self, message: "Please input email", title: "")
            return
        }

        if DataUtils.isValidEmailAddress(emailAddressString: addressField.textView.text!) == false {
            DataUtils.messageShow(view: self, message: "Please input valid email", title: "")
            return
        }

        if passwordField.textView.text!.isEmpty {
            DataUtils.messageShow(view: self, message: "Please input password", title: "")
            return
        }

        if DataUtils.isConnectedToNetwork() == false {
            DataUtils.messageShow(view: self, message: "Please check your internet connection.", title: "")
            return
        }
        loginUser()
    }
    func loginUser()
    {
        let localTimeZoneName = TimeZone.current.identifier
        let deviceToken = UserDefaults.standard.value(forKey: "DeviceToken") as? String ?? ""
        let params = [
            "email" : addressField.textView.text!,
            "password" : passwordField.textView.text!,
            "choice" : "1",
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
                    if result == "true" {
                        DataUtils.setSkipButton(time: true)
                        let defaults = UserDefaults.standard
                        defaults.set(self.passwordField.textView.text!, forKey: "password")
                        let patientInfo = PatientInfo.init(json: json["userinfo"] as! [String:Any])
                        patientInfo.saveUserInfo()
//                        self.getUserMedication()
                        self.gotoMainScreen()
                     }else {
                        let message = json["message"] as! String
                        DataUtils.messageShow(view: self, message: message, title: "")
                    }
                }
            })
    }
    
//    func getUserMedication(){
//        let params = [
//            "userid" : PreferenceHelper().getId(),
//            "choice" : "5"
//            ] as [String : Any]
//        Alamofire.request(DataUtils.APIURL + DataUtils.MYDRUG_URL, method: .post, parameters: params)
//            .responseJSON(completionHandler: { response in
//
//                debugPrint(response);
//
//                if let data = response.result.value {
//                    let json : [String:Any] = data as! [String : Any]
//                    //let statusMsg: String = json["status_msg"] as! String
//                    //self.showResultMessage(statusMsg)
//                    //self.showGraph(json)
//                    let result = json["status"] as? String
//                    if result == "true"
//                    {
//                        let data = json["data"] as! NSArray
//                        self.ConvertToMedicationArrayAndSaveToLocalDB(datas:data)
//
//                    }
//                    else
//                    {
//                        let message = json["message"] as! String
//                        DataUtils.messageShow(view: self, message: message, title: "")
//                    }
//                }
//            })
//    }
//    func ConvertToMedicationArrayAndSaveToLocalDB(datas:NSArray) {
//        var dics = [MyMedication]()
//        for data in datas
//        {
//            if let un = data as? [String:Any]{
//                let prescribe = un["prescribe"] as? String ?? ""
//                let dose = un["dose"] as? String ?? ""
//                let quantity = un["quantity"] as? String ?? ""
//                let direction = un["direction"] as? String ?? ""
//                let taketime = un["taketime"] as? String ?? ""
//                let patientname = un["patientname"] as? String ?? ""
//                let pharmacy = un["pharmacy"] as? String ?? ""
//                let medicationname = un["medicationname"] as? String ?? ""
//                let strength = un["strength"] as? String ?? ""
//                let filed_date = un["filed_date"] as? String ?? ""
//                let warnings = un["warnings"] as? String ?? ""
//                let frequency = un["frequency"] as? String ?? ""
//                let lefttablet = un["lefttablet"] as? String ?? ""
//                let prescription = un["prescription"] as? String ?? ""
//                let createat = un["createat"] as? String ?? ""
//                let endat = un["endat"] as? String ?? ""
//                let id = un["id"] as? String ?? ""
//                let type = un["type"] as? String ?? ""
//                
//                let mymedication = MyMedication(prescribe: prescribe, directions: direction, dose: dose, image: "", quantity: quantity, type: type, taketime: taketime, medicationname: medicationname, filedDate: filed_date, warning: warnings, frequency: frequency, strength: strength, pharmacy: pharmacy, patientname: patientname, lefttablet: lefttablet, prescription: Int(prescription)!, createat: createat, endat: endat, id: Int(id)!, amount: "")
//                 dics.append(mymedication)
//            }
//        }
//       DBManager.getObject().insetMedicationHistoryData1(datas: dics)
//    }
    
    func gotoMainScreen() {
        setupTimeRange()
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainviewcontroller") as! UITabBarController
        //viewController.tabBar.roundCorners([.topLeft, .topRight], radius: 10)
        viewController.tabBar.layer.cornerRadius = 10
        viewController.tabBar.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner];
        viewController.tabBar.layer.borderWidth = 1
        //viewController.tabBar.layer.borderColor = UIColor.init(hex: "707070").cgColor
        viewController.tabBar.layer.borderColor = UIColor(red: (112/255.0), green: (112/255.0), blue: (112/255.0), alpha: 0.2).cgColor
        viewController.tabBar.clipsToBounds = true
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: false, completion: nil)
    }
    
    func setupTimeRange() {
        DataUtils.setTimeRange(index: 0, time: "1:00-11:59")
        DataUtils.setTimeRange(index: 1, time: "12:00-16:59")
        DataUtils.setTimeRange(index: 2, time: "17:00-19:59")
        DataUtils.setTimeRange(index: 3, time: "20:00-23:59")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if  addressField.textView == textField
        {
//            if passWordFieldHeight.constant < 73.0
//            {
//                UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
//                    self.passWordFieldHeight.constant = self.passWordFieldHeight.constant + 15
//                    self.view.layoutIfNeeded()
//                }, completion: { (finished: Bool) in
//
//                })
//
//            }
            
            addressField.identifier.text = textField.placeholder
        }
        else
        {
//            if addressFieldHeight.constant < 73.0
//            {
//                UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
//                    self.addressFieldHeight.constant = self.addressFieldHeight.constant + 15
//                    self.view.layoutIfNeeded()
//                }, completion: { (finished: Bool) in
//
//                })
//
//            }
            passwordField.showHideButton.isHidden = false
            passwordField.identifier.text = textField.placeholder
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if addressField.textView == textField
        {
            if textField.text?.trimmingCharacters(in: .whitespaces) != ""
            {
                addressField.identifier.text = textField.placeholder
//                if passWordFieldHeight.constant < 73.0
//                {
//                    passWordFieldHeight.constant = passWordFieldHeight.constant + 15
//                }
            }
            else
            {
                addressField.identifier.text = ""
//                passWordFieldHeight.constant = passWordFieldHeight.constant - 15
            }
        }
        else
        {
            if textField.text?.trimmingCharacters(in: .whitespaces) != ""
            {
                passwordField.identifier.text = textField.placeholder
//                if addressFieldHeight.constant < 73.0
//                {
//                    addressFieldHeight.constant = addressFieldHeight.constant + 15
//                }
                passwordField.showHideButton.isHidden = false
            }
            else
            {
                passwordField.identifier.text = ""
                passwordField.showHideButton.isHidden = true
//                addressFieldHeight.constant = addressFieldHeight.constant - 15
            }
        }
    }
    
    @IBAction func onForgotPassword(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        self.present(vc, animated: false)
    }

    @objc func keyboardWillShow(_ notification: Notification)
    {
        keyboardHeight = (notification.userInfo?["UIKeyboardBoundsUserInfoKey"] as! CGRect).height
//        signinButtonBottomConstraint?.constant = self.originalBottomConstraint! + self.keyboardHeight!
        signinButtonBottomConstraint?.constant = self.keyboardHeight!
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(_ notification:Notification) {
        signinButtonBottomConstraint?.constant = self.originalBottomConstraint!
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
}
