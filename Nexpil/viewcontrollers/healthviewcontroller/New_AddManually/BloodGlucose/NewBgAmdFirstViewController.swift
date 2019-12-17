//
//  NewBgAmdFirstViewController.swift
//  Nexpil
//
//  Created by Guang on 11/3/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Alamofire

class NewBgAmdFirstViewController: UIViewController {
    
    @IBOutlet weak var timingView: GradientView!
    @IBOutlet weak var measurementLabel: UITextField!
    @IBOutlet weak var dateView: GradientView!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        Global_ShowFrostGlass(self.view)
        
        timingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showTimingView)))
        dateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDateView)))
        
        // Init Data
        timingLabel.text = "Before Breakfast"
        BGDataManager.Date = GlobalManager.GetToday()
        dateLabel.text = BGDataManager.GetDate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Global_ShowFrostGlass(self.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Global_HideFrostGlass()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Global_HideFrostGlass()
    }
    
    @IBAction func closeButtonClick(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func showTimingView() {
        BGDataManager.Measurement = measurementLabel.text!
        weak var pvc = self.presentingViewController
        self.dismiss(animated: false, completion: {
            let viewController = (self.storyboard?.instantiateViewController(withIdentifier: "NewBgAmdSecondViewController") as? NewBgAmdSecondViewController)!
            viewController.modalPresentationStyle = .overFullScreen
            pvc?.present(viewController, animated: true, completion: nil)
        })
    }
    
    @objc func showDateView() {
        BGDataManager.Measurement = measurementLabel.text!
        weak var pvc = self.presentingViewController
        self.dismiss(animated: false, completion: {
            let viewController = (self.storyboard?.instantiateViewController(withIdentifier: "NewBgAmdThirdViewController") as? NewBgAmdThirdViewController)!
            viewController.modalPresentationStyle = .overFullScreen
            pvc?.present(viewController, animated: false, completion: nil)
        })
    }

    func closeDialog() {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func doneButtonClick(_ sender: Any) {
        let measurement = measurementLabel.text
        
        if measurement == "" {
            DataUtils.messageShow(view: self, message: "Enter measurement", title: "Confirm")
        } else {
            BGDataManager.Measurement = measurement!
            if BGDataManager.SendData() {
                weak var pvc = self.presentingViewController
                self.dismiss(animated: false, completion: {
                    let viewController = (self.storyboard?.instantiateViewController(withIdentifier: "BloodGlucoseAddManuallyFinalViewController") as? BloodGlucoseAddManuallyFinalViewController)!
                    viewController.modalPresentationStyle = .overFullScreen
                    pvc?.present(viewController, animated: true, completion: nil)
                })
            } else {
                DataUtils.messageShow(view: self, message: "Error in add data", title: "Error")
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
}
