//
//  PhoneNumberViewController.swift
//  Nexpil
//
//  Created by mac on 6/29/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class PhoneNumberViewController: UIViewController {

    @IBOutlet weak var txtPhoneNumber: InformationCardEditable!
    @IBOutlet weak var bottomButtonConstant: NSLayoutConstraint!
    let center = NotificationCenter.default
    var originalHeight: CGFloat?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let backImage = UIImage(named: "Back")
        let logoImage = UIImage(named: "nexpil logo - alternate")
        self.navigationItem.titleView = UIImageView(image: logoImage)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(self.closeWindow))
        UINavigationBar.appearance().barTintColor = UIColor.init(hex: "#FCFCFC")
        UINavigationBar.appearance().tintColor = UIColor.init(hex: "#FCFCFC")
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(hex: "#FCFCFC")]
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().layer.borderColor = UIColor.init(hex: "#FCFCFC").cgColor
        UINavigationBar.appearance().layer.borderWidth = 7.0
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        originalHeight = bottomButtonConstant.constant
        txtPhoneNumber.textView.becomeFirstResponder()
    }
    @objc func closeWindow() {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if DataUtils.getEmail() != ""
        {
            txtPhoneNumber.textView.text = UserDefaults.standard.string(forKey: "phone_number")
        }
        txtPhoneNumber.textView.keyboardType = .decimalPad
        center.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        txtPhoneNumber.textView.resignFirstResponder()
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
        UserDefaults.standard.setValue(txtPhoneNumber.textView.text, forKey: "phone_number")
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
