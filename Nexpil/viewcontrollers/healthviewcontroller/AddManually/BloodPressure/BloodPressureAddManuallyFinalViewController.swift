//
//  BloodPressureAddManuallyFinalViewController.swift
//  Nexpil
//
//  Created by mac on 9/4/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class BloodPressureAddManuallyFinalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        Global_ShowFrostGlass(self.view)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        Global_HideFrostGlass()
    }
    
    @IBAction func closeButtonClick(_ sender: Any) {
//        presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
}
