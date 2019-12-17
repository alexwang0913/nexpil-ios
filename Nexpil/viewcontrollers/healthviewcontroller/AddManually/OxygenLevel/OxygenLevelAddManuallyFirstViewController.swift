//
//  OxygenLevelAddManuallyFirstViewController.swift
//  Nexpil
//
//  Created by mac on 9/4/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class OxygenLevelAddManuallyFirstViewController: UIViewController {

    @IBOutlet weak var currentCircle: UIImageView!
    @IBOutlet weak var defaultCircle: UIImageView!
    @IBOutlet weak var defaultCircle1: UIImageView!
    @IBOutlet weak var textFieldBackView: UIView!
    @IBOutlet weak var measurementTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentCircle.backgroundColor = UIColor.white
        currentCircle.layer.borderWidth = 2
        currentCircle.layer.borderColor = #colorLiteral(red: 0.2235294118, green: 0.8274509804, blue: 0.8901960784, alpha: 1)
        currentCircle.layer.cornerRadius = 15
        currentCircle.layer.masksToBounds = false
        
        defaultCircle.layer.borderWidth = 2
        defaultCircle.layer.borderColor = UIColor.lightGray.cgColor
        defaultCircle.layer.cornerRadius = 15
        defaultCircle.backgroundColor = UIColor.white
        
        defaultCircle1.layer.borderWidth = 2
        defaultCircle1.layer.borderColor = UIColor.lightGray.cgColor
        defaultCircle1.layer.cornerRadius = 15
        defaultCircle1.backgroundColor = UIColor.white
        
        textFieldBackView.layer.shadowColor = UIColor.black.cgColor
        textFieldBackView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        textFieldBackView.layer.shadowOpacity = 0.16
        textFieldBackView.layer.shadowRadius = 12.0
        textFieldBackView.layer.masksToBounds = false
        textFieldBackView.layer.cornerRadius = 30
    }

    @IBAction func closeButtonClick(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func nextButtonClick(_ sender: Any) {
        let viewController = UIStoryboard(name: "Health", bundle: nil).instantiateViewController(withIdentifier: "OxygenLevelAddManuallySecondViewController") as! OxygenLevelAddManuallySecondViewController
        viewController.measurement = measurementTextField.text ?? ""
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Global_ShowFrostGlass(self.view)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Global_HideFrostGlass()
    }
}
