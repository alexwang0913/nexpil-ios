//
//  VCRemoveDrugConfirm.swift
//  Nexpil
//
//  Created by mac on 7/17/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class VCRemoveDrugConfirm: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    var delegate:ShadowDelegate1?
    public var m_drugName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mainView.viewShadow()
        mainView.addShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.16, x: 0, y: 3, blur: 6.0)
        mainView.layer.cornerRadius = 30
        lblTitle.text = "Are you sure you want to remove " + m_drugName + "?"
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
