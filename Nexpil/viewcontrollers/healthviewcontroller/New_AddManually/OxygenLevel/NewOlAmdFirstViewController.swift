//
//  NewOlAmdFirstViewController.swift
//  Nexpil
//
//  Created by Guang on 11/5/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class NewOlAmdFirstViewController: UIViewController {

    @IBOutlet weak var measurementLabel: UITextField!
    @IBOutlet weak var timeViewr: GradientView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateViewer: GradientView!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        timeLabel.text = OLDataManager.GetTiming()
        dateLabel.text = OLDataManager.GetDate()
        
        timeViewr.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showTimingView)))
        dateViewer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDateView)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Global_ShowFrostGlass(self.view)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Global_HideFrostGlass()
    }
    
    @IBAction func doneButtonClick(_ sender: Any) {
        OLDataManager.Measurement = measurementLabel.text!
        
        if OLDataManager.SendData() {
            let pvc = self.presentingViewController
            self.dismiss(animated: false, completion: {
                let finalVC = self.storyboard?.instantiateViewController(withIdentifier: "OxygenLevelAddManuallyFinalViewController") as? OxygenLevelAddManuallyFinalViewController
                finalVC?.modalPresentationStyle = .overFullScreen
                pvc?.present(finalVC!, animated: false, completion: nil)
            })
        } else {
            DataUtils.messageShow(view: self, message: "Error in add data", title: "Error")
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func closeButtonClick(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func showTimingView() {
        OLDataManager.Measurement = measurementLabel.text!
        weak var pvc = self.presentingViewController
        self.dismiss(animated: false, completion:  {
            let viewController = (self.storyboard?.instantiateViewController(withIdentifier: "NewOlAmdSecondViewController") as? NewOlAmdSecondViewController)!
            viewController.modalPresentationStyle = .overFullScreen
            pvc?.present(viewController, animated: true, completion: nil)
        })
    }
    
    @objc func showDateView() {
        OLDataManager.Measurement = measurementLabel.text!
        weak var pvc = self.presentingViewController
        self.dismiss(animated: false, completion:  {
            let viewController = (self.storyboard?.instantiateViewController(withIdentifier: "NewOlAmdThirdViewController") as? NewOlAmdThirdViewController)!
            viewController.modalPresentationStyle = .overFullScreen
            pvc?.present(viewController, animated: true, completion: nil)
        })
    }
}
