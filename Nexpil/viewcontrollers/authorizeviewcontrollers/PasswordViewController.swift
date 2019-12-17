//
//  PasswordViewController.swift
//  Nexpil
//
//  Created by Admin on 01/01/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit


class PasswordViewController: UIViewController {

    @IBOutlet weak var password: InformationCardEditable!
    @IBOutlet weak var confirmPassword: InformationCardEditable!
    @IBOutlet weak var bottomButtonConstant: NSLayoutConstraint!
    let center = NotificationCenter.default
    var originalHeight: CGFloat?
    override func viewDidLoad() {
        super.viewDidLoad()
        password.textView.isSecureTextEntry = true
        confirmPassword.textView.isSecureTextEntry = true
        
        originalHeight = bottomButtonConstant.constant
        
        password.textView.becomeFirstResponder()
    }
    @objc func closeWindow() {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if DataUtils.getPassword() != ""
        {
            password.textView.text = DataUtils.getPassword()
            confirmPassword.textView.text = DataUtils.getPassword()
        }
        center.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        password.textView.resignFirstResponder()
        confirmPassword.textView.resignFirstResponder()        
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

    @IBAction func gotoNext(_ sender: Any) {
     
        if password.textView.text! == "" || confirmPassword.textView.text! == ""
        {
            DataUtils.messageShow(view: self, message: "Please input password", title: "")
            return
        }
        if password.textView.text!.count < 6
        {
            DataUtils.messageShow(view: self, message: "Password length must be above 6 characters.", title: "")
            return
        }
        if password.textView.text! != confirmPassword.textView.text!
        {
            DataUtils.messageShow(view: self, message: "Please check password again.", title: "")
            return
        }
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhoneNumberViewController") as! PhoneNumberViewController
        self.navigationController?.pushViewController(viewController, animated: true)
        
        DataUtils.setPassword(password: password.textView.text!)
        
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
