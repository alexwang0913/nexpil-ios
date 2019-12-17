//
//  ForgotPasswordViewController.swift
//  Nexpil
//
//  Created by Admin on 21/12/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import MessageUI
class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    var delegate: LoginScreenViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func gotoBack(_ sender: Any) {
        delegate.m_forgetPasswordProc = 0
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func onSend(_ sender: Any) {
        delegate.m_forgetPasswordProc = 1
        self.dismiss(animated: false, completion: {
            self.delegate.ProcessForgetPassword()
        })
    }
}
