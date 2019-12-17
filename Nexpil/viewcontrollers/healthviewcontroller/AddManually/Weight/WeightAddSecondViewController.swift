//
//  WeightAddSecondViewController.swift
//  Nexpil
//
//  Created by mac on 9/4/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class WeightAddSecondViewController: UIViewController {
    
    
    @IBOutlet weak var currentCircle: UIImageView!
    @IBOutlet weak var labelBackView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weightLabel: UITextField!
    
    var dateString: String = ""
    var date: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateLabel.text = dateString
        
        currentCircle.backgroundColor = UIColor.white
        currentCircle.layer.borderWidth = 2
        currentCircle.layer.borderColor = #colorLiteral(red: 0.2862745098, green: 0.2235294118, blue: 0.8901960784, alpha: 1)
        currentCircle.layer.cornerRadius = 15
        currentCircle.layer.masksToBounds = false
    }
    
    @IBAction func closeButtonClick(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func doneButtonClick(_ sender: Any) {
        let value = (weightLabel.text! as NSString).doubleValue
        
        if !DataManager().insertWeight(date: date!, value: value) {
            DataUtils.messageShow(view: self, message: "Failed in add data", title: "")
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Global_ShowFrostGlass(self.view)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Global_HideFrostGlass()
    }
    
}
