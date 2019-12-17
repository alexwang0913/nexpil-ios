//
//  CloseAddMedicationViewController.swift
//  Nexpil
//
//  Created by Admin on 4/30/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class CloseAddMedicationViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    var delegate:ShadowDelegate1?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mainView.viewShadow()
        mainView.layer.cornerRadius = 30
        mainView.addShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.16, x: 0, y: 3, blur: 6.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeNo(_ sender: Any) {
        self.delegate?.removeShadow(root: false)
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func closeYes(_ sender: Any) {
        self.dismiss(animated: false, completion: {
            self.delegate?.removeShadow(root: true)
        })
    }
}
