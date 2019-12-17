//
//  NewBpAmdSecondViewController.swift
//  Nexpil
//
//  Created by Guang on 11/3/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class NewBpAmdSecondViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var measurementLabel: UITextField!
    @IBOutlet weak var amButton: UIButton!
    @IBOutlet weak var pmButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateView: GradientView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet var hourViews: [GradientView]!
    @IBOutlet var minViews: [GradientView]!
    @IBOutlet var hourLabels: [UILabel]!
    @IBOutlet var minLabels: [UILabel]!
    
    var hour = 1
    var min = 5
    var identifyAmPm = 0 // 0: AM 1: PM

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<12 {
            hourViews[i].topColor = UIColor.white
            hourViews[i].bottomColor = UIColor.white
            hourViews[i].cornerRadius = 20
            hourViews[i].tag = i
            hourViews[i].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleHourViewTap(sender:))))
            
            minViews[i].topColor = UIColor.white
            minViews[i].bottomColor = UIColor.white
            minViews[i].cornerRadius = 20
            minViews[i].tag = i
            minViews[i].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMinVIewTap(sender:))))
            
            hourLabels[i].textColor = UIColor.init(hex: "333333")
            minLabels[i].textColor = UIColor.init(hex: "333333")
        }
        
        // Init
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "GMT")!
        var hour = calendar.component(.hour, from: GlobalManager.GetToday())
        var min = calendar.component(.minute, from: GlobalManager.GetToday())
        
        self.hour = hour
        self.min = min
        
        min = (min / 5) * 5
        
        if hour > 12 {
            hour = hour - 12
            setPmButtonActive()
        } else {
            setAmButtonActive()
        }
        
        timeLabel.text = "\(hour):\(min)"
        setViewActive(view: hourViews[hour-1], label: hourLabels[hour-1])
        setViewActive(view: minViews[min/5], label: minLabels[min/5])
        
        measurementLabel.text = BPDataManager.Measurement
        measurementLabel.delegate = self
        
        dateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlerTapDateView)))
        dateLabel.text = BPDataManager.GetDate()
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
    
    @IBAction func amButtonClick(_ sender: Any) {
        setAmButtonActive()
        
    }
    
    @IBAction func pmButtonClick(_ sender: Any) {
        setPmButtonActive()
    }
    
    private func setAmButtonActive() {
        identifyAmPm = 0
        amButton.setImage(UIImage(named: "AM"), for: .normal)
        pmButton.setImage(UIImage(named: "night_off"), for: .normal)
    }
    
    private func setPmButtonActive() {
        identifyAmPm = 1
        amButton.setImage(UIImage(named: "midday_off"), for: .normal)
        pmButton.setImage(UIImage(named: "PM"), for: .normal)
    }
    
    private func setViewActive(view: GradientView, label: UILabel) {
        view.topColor = UIColor(cgColor: NPColorScheme(rawValue: 2)!.gradient[0])
        view.bottomColor = UIColor(cgColor: NPColorScheme(rawValue: 2)!.gradient[1])
        label.textColor = UIColor.white
    }
    
    @objc func handleHourViewTap(sender: UITapGestureRecognizer) {
        let index = sender.view!.tag
        hour = index + 1 + identifyAmPm * 12
        updateTimeLabel()
        
        for i in 0..<12 {
            hourViews[i].topColor = UIColor.white
            hourViews[i].bottomColor = UIColor.white
            hourLabels[i].textColor = UIColor.init(hex: "333333")
        }
        setViewActive(view: hourViews[index], label: hourLabels[index])
    }
    
    private func updateTimeLabel() {
        let h = hour > 12 ? hour - 12 : hour
        let m = (min/5) * 5
        timeLabel.text = "\(h):\(m)"
    }
    
    @objc func handleMinVIewTap(sender: UITapGestureRecognizer) {
        let index = sender.view!.tag
        min = index * 5
        updateTimeLabel()
        for i in 0..<12 {
            minViews[i].topColor = UIColor.white
            minViews[i].bottomColor = UIColor.white
            minLabels[i].textColor = UIColor.init(hex: "333333")
        }
        setViewActive(view: minViews[index], label: minLabels[index])
    }
    
    @objc func handlerTapDateView() {
        BPDataManager.Measurement = measurementLabel.text!
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "GMT")!
        BPDataManager.Date = calendar.date(bySettingHour: hour, minute: min, second: 0, of: BPDataManager.Date)!
        
        let pvc = self.presentingViewController
        self.dismiss(animated: false, completion: {
            let viewController = (self.storyboard?.instantiateViewController(withIdentifier: "NewBpAmdThirdViewController") as? NewBpAmdThirdViewController)!
            viewController.modalPresentationStyle = .overFullScreen
            pvc?.present(viewController, animated: true, completion: nil)
        })
    }
    
    @IBAction func closeButtonClick(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Global_ShowFrostGlass(self.view)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Global_HideFrostGlass()
    }
    
    @IBAction func doneButtonClick(_ sender: Any) {
        BPDataManager.Measurement = measurementLabel.text!
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "GMT")!
        BPDataManager.Date = calendar.date(bySettingHour: hour, minute: min, second: 0, of: BPDataManager.Date)!
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
    
}
