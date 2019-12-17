//
//  DoneVC.swift
//  Nexpil
//
//  Created by ankit vaish on 10/05/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class DoneVC: UIViewController {
    
    public var delegate: LoginScreenViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (timer) in
            self.delegate.m_forgetPasswordProc = 0
            self.dismiss(animated: false, completion:nil)
        }
    }
}
