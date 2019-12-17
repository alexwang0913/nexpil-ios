//
//  ResetPasswordCodeVC.swift
//  Nexpil
//
//  Created by mac on 7/2/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class ResetPasswordCodeVC: UIViewController {

    public var delegate: LoginScreenViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    @IBAction func onClose(){
        delegate.m_forgetPasswordProc = 0
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func onNext(){
        delegate.m_forgetPasswordProc = 2
        self.dismiss(animated: false, completion: {
            self.delegate.ProcessForgetPassword()
        })
    }
}
