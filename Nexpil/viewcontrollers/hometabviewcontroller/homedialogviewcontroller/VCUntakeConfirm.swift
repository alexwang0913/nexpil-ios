//
//  VCUntakeConfirm.swift
//  Nexpil
//
//  Created by mac on 7/17/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class VCUntakeConfirm: UIViewController {

    @IBOutlet weak var mainView: UIView!
    public var vc_parent: MedicationInfoMainViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.viewShadow()
        mainView.addShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.16, x: 0, y: 3, blur: 6.0)
        mainView.layer.cornerRadius = 30
    }
    

    @IBAction func onAction(_ sender: UIButton) {
        self.dismiss(animated: false, completion: {
            if sender.tag == 1 {
                self.vc_parent.onEditTime()
            } else if sender.tag == 2 {
                self.vc_parent.UntakeDrug()
            }
        })
    }

}
