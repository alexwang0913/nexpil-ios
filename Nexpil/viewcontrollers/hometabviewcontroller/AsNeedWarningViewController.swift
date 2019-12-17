//
//  AsNeedWarningViewController.swift
//  Nexpil
//
//  Created by mac on 9/10/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

protocol AsNeedWarningDelegate {
    func accpetWarning(_ index: Int)
}
class AsNeedWarningViewController: UIViewController {

    @IBOutlet weak var content: UILabel!
    
    
    var delegate: AsNeedWarningDelegate?
    var index: Int?
    var medicationname: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        content.text = "You took \(medicationname) less than 4 hour ago."
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Global_ShowFrostGlass(self.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Global_HideFrostGlass()
    }
    
    @IBAction func acceptButtonClick(_ sender: Any) {
        self.dismiss(animated: false, completion: {
            self.delegate?.accpetWarning(self.index!)
        })
    }
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}
