//
//  ForgetPassword.swift
//  Nexpil
//
//  Created by ankit vaish on 10/05/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class ForgetPassword: UIViewController {
    
    @IBOutlet weak var submitButton: NPButton!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    public var delegate: LoginScreenViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onClose(){
        delegate.m_forgetPasswordProc = 0
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        delegate.m_forgetPasswordProc = 3
        self.dismiss(animated: false, completion: {
            self.delegate.ProcessForgetPassword()
        })
    }
}
