//
//  NewBpAmdFirstViewController.swift
//  Nexpil
//
//  Created by Guang on 11/3/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class NewBpAmdFirstViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var measurementLabel: UITextField!
    @IBOutlet weak var timingView: GradientView!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var dateView: GradientView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showTimingView)))
        dateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDateView)))
        timingLabel.text = BPDataManager.GetTiming()
        dateLabel.text = BPDataManager.GetDate()
        
        measurementLabel.delegate = self
    }
    
    var backspacePressed = false
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            backspacePressed = isBackSpace == -92
        }

        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text
        let firstDigit = (text?.prefix(1) as! NSString).integerValue
        
        if ((firstDigit < 3 && text?.count == 3) || (firstDigit > 2 && text?.count == 2)) && !backspacePressed {
            textField.text! += "/"
        }
    }

    @IBAction func doneButtonClick(_ sender: Any) {
        BPDataManager.Measurement = measurementLabel.text!
        if BPDataManager.SendData() {
            let pvc = self.presentingViewController
            self.dismiss(animated: false, completion: {
                let viewController = (self.storyboard?.instantiateViewController(withIdentifier: "BloodPressureAddManuallyFinalViewController") as? BloodPressureAddManuallyFinalViewController)!
                viewController.modalPresentationStyle = .overFullScreen
                pvc?.present(viewController, animated: true, completion: nil)
            })
        } else {
            DataUtils.messageShow(view: self, message: "Error in add data", title: "Error")
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @objc func showTimingView() {
        BPDataManager.Measurement = measurementLabel.text!
        weak var pvc = self.presentingViewController
        self.dismiss(animated: false, completion:  {
            let viewController = (self.storyboard?.instantiateViewController(withIdentifier: "NewBpAmdSecondViewController") as? NewBpAmdSecondViewController)!
            viewController.modalPresentationStyle = .overFullScreen
            pvc?.present(viewController, animated: true, completion: nil)
        })
    }
    
    @objc func showDateView() {
        BPDataManager.Measurement = measurementLabel.text!
        weak var pvc = self.presentingViewController
        self.dismiss(animated: false, completion:  {
            let viewController = (self.storyboard?.instantiateViewController(withIdentifier: "NewBpAmdThirdViewController") as? NewBpAmdThirdViewController)!
            viewController.modalPresentationStyle = .overFullScreen
            pvc?.present(viewController, animated: true, completion: nil)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Global_ShowFrostGlass(self.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Global_HideFrostGlass()
    }
            
    @IBAction func closeButtonClick(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}
