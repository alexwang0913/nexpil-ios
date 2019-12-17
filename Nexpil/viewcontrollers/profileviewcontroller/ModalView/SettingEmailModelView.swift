//
//  SettingEmailModelView.swift
//  Nexpil
//
//  Created by NTGMM-02 on 06/02/19.
//  Copyright © 2019 Admin. All rights reserved.
//


import UIKit

protocol SettingEmailModalViewDelegate {
    func popSettingEmailModalViewDismissal()
    func popSettingEmailSaveView(CurrentEmail:String,newEmail:String,ConfirmEmail:String)
}

class SettingEmailModelView: UIView {
    @IBOutlet weak var backUV: UIView!
    @IBOutlet weak var backUB: UIButton!
    @IBOutlet weak var saveUB: UIButton!
    @IBOutlet weak var currentEmailTF: UITextField!
    @IBOutlet weak var ConfirmEmailTF: UITextField!
    
    @IBOutlet weak var newEmailTF: UITextField!
    var delegate: SettingEmailModalViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //  Initialation code
        backUV.setPopItemViewStyle(radius: 30.0, title: .large)
        backUB.setPopItemViewStyle(radius: 22.5)
        
        self.hideKeyboardWhenTappedAround()
        
        currentEmailTF.text = DataUtils.getEmail() ?? ""
    }
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    @IBAction func onClickBackUB(_ sender: Any) {
        self.delegate?.popSettingEmailModalViewDismissal()
    }
    
    @IBAction func onClickSaveUB(_ sender: Any) {
        if let CurrentEmail = currentEmailTF.text, let newEmail = newEmailTF.text,let confirmEmail = ConfirmEmailTF.text{
            self.delegate?.popSettingEmailSaveView(CurrentEmail: CurrentEmail, newEmail: newEmail, ConfirmEmail: confirmEmail)
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }

}
