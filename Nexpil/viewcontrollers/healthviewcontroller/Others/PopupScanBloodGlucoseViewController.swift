//
//  PopupScanBloodGlucoseViewController.swift
//  Nexpil
//
//  Created by mac on 8/31/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class PopupHealthPremerModalViewController: UIViewController {
    
    @IBOutlet weak var continueButton: NPButton!
    var scheme = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.colorScheme = scheme
    }

    @IBAction func continueButtonClick(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        Global_ShowFrostGlass(self.view)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        Global_HideFrostGlass()
    }
}
