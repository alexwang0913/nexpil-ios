//
//  UserNameViewController.swift
//  Nexpil
//
//  Created by Admin on 01/01/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class UserNameViewController: UIViewController {

    @IBOutlet weak var bottomButtonConstant: NSLayoutConstraint!
    @IBOutlet weak var firstName: InformationCardEditable!
    @IBOutlet weak var lastName: InformationCardEditable!
    let center = NotificationCenter.default
    var originalHeight: CGFloat?
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().barTintColor = UIColor.init(hex: "#FCFCFC")
        UINavigationBar.appearance().tintColor = UIColor.init(hex: "#FCFCFC")
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(hex: "#FCFCFC")]
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().layer.borderColor = UIColor.init(hex: "#FCFCFC").cgColor
        UINavigationBar.appearance().layer.borderWidth = 7.0
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        originalHeight = bottomButtonConstant.constant
        
        firstName.textView.becomeFirstResponder()
    }
    @IBAction func closeWindow() {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if DataUtils.getPatientFullName() != ""
        {
            firstName.textView.text = DataUtils.getPatientFullName()?.components(separatedBy: " ")[0]
            lastName.textView.text = DataUtils.getPatientFullName()?.components(separatedBy: " ")[1]
        }
        firstName.textView.autocapitalizationType = .sentences
        lastName.textView.autocapitalizationType = .sentences
        center.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        firstName.textView.resignFirstResponder()
        lastName.textView.resignFirstResponder()
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification)
    {
        let keyboardHeight = (notification.userInfo?["UIKeyboardBoundsUserInfoKey"] as! CGRect).height
        bottomButtonConstant.constant = self.originalHeight! + keyboardHeight
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        bottomButtonConstant?.constant = self.originalHeight!
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func gotoNext(_ sender: Any) {
        if firstName.textView.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input first name", title: "")
            return
        }
        if lastName.textView.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input last name", title: "")
            return
        }
        DataUtils.setPatientFullName(patientfullname: firstName.textView.text! + " " + lastName.textView.text!)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EmailViewController") as! EmailViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
