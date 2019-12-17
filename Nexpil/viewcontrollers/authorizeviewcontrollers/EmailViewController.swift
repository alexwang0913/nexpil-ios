//
//  EmailViewController.swift
//  Nexpil
//
//  Created by Admin on 01/01/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class EmailViewController: UIViewController {

    @IBOutlet weak var emailAddress: InformationCardEditable!
    @IBOutlet weak var bottomButtonConstant: NSLayoutConstraint!
    let center = NotificationCenter.default
    var originalHeight: CGFloat?
    override func viewDidLoad() {
        super.viewDidLoad()
       
        originalHeight = bottomButtonConstant.constant
        emailAddress.becomeFirstResponder()
    }
    @IBAction func closeWindow() {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if DataUtils.getEmail() != ""
        {
            emailAddress.textView.text = DataUtils.getEmail()
        }
        emailAddress.textView.keyboardType = .emailAddress
        center.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        emailAddress.textView.resignFirstResponder()        
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
        if emailAddress.textView.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input email address", title: "")
            return
        }
        if DataUtils.isValidEmailAddress(emailAddressString: emailAddress.textView.text!) == false
        {
            DataUtils.messageShow(view: self, message: "Please input valid email address", title: "")
            return
        }
        DataUtils.setEmail(email: emailAddress.textView.text!)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PasswordViewController") as! PasswordViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
