//
//  NewBgAmdSecondViewController.swift
//  Nexpil
//
//  Created by Guang on 11/3/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class NewBgAmdSecondViewController: UIViewController {
    
    @IBOutlet weak var measurementLabel: UITextField!
    @IBOutlet weak var beforeView: GradientView!
    @IBOutlet weak var afterView: GradientView!
    @IBOutlet weak var beforeLabel: UILabel!
    @IBOutlet weak var afterLabel: UILabel!
    @IBOutlet weak var breakfastView: GradientView!
    @IBOutlet weak var breakfastLabel: UILabel!
    @IBOutlet weak var launchView: GradientView!
    @IBOutlet weak var launchLabel: UILabel!
    @IBOutlet weak var dinnerView: GradientView!
    @IBOutlet weak var dinnerLabel: UILabel!
    @IBOutlet weak var dateView: GradientView!
    @IBOutlet weak var dateLabel: UILabel!
    
    private var beforeString = "Before" // "Before" or "After"
    private var afterString = "Breakfast" // "Breakfast", "Lunch", and "Dinner"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        measurementLabel.text = BGDataManager.Measurement
        dateLabel.text = BGDataManager.GetDate()
        let beforeTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleBeforeViewTap(_:)))
        beforeView.addGestureRecognizer(beforeTapGesture)
        
        let afterTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleAfterViewTap(_:)))
        afterView.addGestureRecognizer(afterTapGesture)
        
        let breakfastTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleBreakfastViewTap(_:)))
        breakfastView.addGestureRecognizer(breakfastTapGesture)
        
        let launchTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleLanuchViewTap(_:)))
        launchView.addGestureRecognizer(launchTapGesture)
        
        let dinnerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleDinnerViewTap(_:)))
        dinnerView.addGestureRecognizer(dinnerTapGesture)
        
        dateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDateView)))
    }
    
    func updateUI() {
        measurementLabel.text = BGDataManager.Measurement
        dateLabel.text = BGDataManager.GetDate()
    }
    
    @IBAction func closeButtonClick(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func handleBeforeViewTap(_ sender: UITapGestureRecognizer? = nil) {
        selectView(beforeView, beforeLabel)
        styleView(afterView)
        
        afterLabel.textColor = UIColor.init(hex: "333333")
        beforeString = "Before"
    }
   
    @objc func handleAfterViewTap(_ sender: UITapGestureRecognizer? = nil) {
        selectView(afterView, afterLabel)
        styleView(beforeView)
        beforeLabel.textColor = UIColor.init(hex: "333333")
        beforeString = "After"
    }
   
    private func styleView(_ view: GradientView) {
        view.cornerRadius = 20
        view.topColor = UIColor.white
        view.bottomColor = UIColor.white
        view.shadowColor = UIColor.init(hex: "000000", alpha: 0.16)
    }
   
    private func selectView(_ view: GradientView, _ label: UILabel) {
        view.topColor = UIColor.init(cgColor: NPColorScheme.blue.gradient[0])
        view.bottomColor = UIColor.init(cgColor: NPColorScheme.blue.gradient[1])
        
        view.layer.shadowColor = UIColor.clear.cgColor
        label.textColor = UIColor.white
    }

    @objc func handleBreakfastViewTap(_ sender: UITapGestureRecognizer? = nil) {
        selectView(breakfastView, breakfastLabel)
        styleView(launchView)
        styleView(dinnerView)
       
        
        launchLabel.textColor = UIColor.init(hex: "333333")
        dinnerLabel.textColor = UIColor.init(hex: "333333")
        afterString = "Breakfast"
    }
   
    @objc func handleLanuchViewTap(_ sender: UITapGestureRecognizer? = nil) {
        selectView(launchView, launchLabel)
        styleView(breakfastView)
        styleView(dinnerView)
       
        breakfastLabel.textColor = UIColor.init(hex: "333333")
        dinnerLabel.textColor = UIColor.init(hex: "333333")
        afterString = "Lunch"
    }
   
    @objc func handleDinnerViewTap(_ sender: UITapGestureRecognizer? = nil) {
        selectView(dinnerView, dinnerLabel)
        styleView(breakfastView)
        styleView(launchView)
       
        breakfastLabel.textColor = UIColor.init(hex: "333333")
        launchLabel.textColor = UIColor.init(hex: "333333")
        afterString = "Dinner"
    }
    
    private func checkTimingType() -> Int {
        if beforeString == "Before" {
            if afterString == "Breakfast" {
                return 0
            } else  if afterString == "Lunch" {
                return 1
            } else if afterString == "Dinner" {
                return 2
            }
        } else if beforeString == "After" {
            if afterString == "Breakfast" {
                return 3
            } else  if afterString == "Lunch" {
                return 4
            } else if afterString == "Dinner" {
                return 5
            }
        }
        return 0
    }
    
    @objc func showDateView() {
        BGDataManager.Timing = checkTimingType()
        BGDataManager.Measurement = measurementLabel.text!
        
        weak var pvc = self.presentingViewController
        self.dismiss(animated: false, completion: {
            let viewController = (self.storyboard?.instantiateViewController(withIdentifier: "NewBgAmdThirdViewController") as? NewBgAmdThirdViewController)!
            viewController.modalPresentationStyle = .overFullScreen
            pvc?.present(viewController, animated: true, completion: nil)
        })
    }
    
    func closeDialog() {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Global_ShowFrostGlass(self.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Global_HideFrostGlass()
    }
    
    @IBAction func doneButtonClick(_ sender: Any) {
        let measurement = measurementLabel.text
        
        if measurement == "" {
            DataUtils.messageShow(view: self, message: "Enter measurement", title: "Confirm")
        } else {
            BGDataManager.Measurement = measurement!
            BGDataManager.Timing = checkTimingType()
            
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
