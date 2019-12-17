//
//  OxygenLevelAddManuallyFinalViewController.swift
//  Nexpil
//
//  Created by mac on 9/4/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class OxygenLevelAddManuallyFinalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        Global_ShowFrostGlass(self.view)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Global_HideFrostGlass()
    }
    
    @IBAction func closeButtonClick(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }

}
