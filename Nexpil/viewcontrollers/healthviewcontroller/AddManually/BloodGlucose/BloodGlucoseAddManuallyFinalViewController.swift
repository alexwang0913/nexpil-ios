//
//  AddManuallyFinalViewController.swift
//  Nexpil
//
//  Created by mac on 9/3/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class BloodGlucoseAddManuallyFinalViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func closeButtonClick(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Global_ShowFrostGlass(self.view)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Global_HideFrostGlass()
    }
    
}
