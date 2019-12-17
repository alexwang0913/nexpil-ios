//
//  NewBpAmdThirdViewController.swift
//  Nexpil
//
//  Created by Guang on 11/4/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class NewBpAmdThirdViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var measurementLabel: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeView: GradientView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CalendarView.Style.cellShape                = .round
        CalendarView.Style.cellColorDefault         = UIColor.clear
        CalendarView.Style.headerTextColor          = NPColorScheme(rawValue: 3)!.color
        CalendarView.Style.cellTextColorDefault     = UIColor.darkText
        CalendarView.Style.cellTextColorToday       = UIColor.white
        CalendarView.Style.firstWeekday             = .sunday
        CalendarView.Style.cellTextColorWeekend     = NPColorScheme(rawValue: 3)!.color
        CalendarView.Style.locale                   = Locale(identifier: "en_US")
        CalendarView.Style.timeZone                 = TimeZone(abbreviation: "UTC")!
        CalendarView.Style.cellColorToday = NPColorScheme(rawValue: 3)!.color
        CalendarView.Style.headerFontName = "Montserrat"
        
        CalendarView.Style.hideCellsOutsideDateRange = false
        CalendarView.Style.changeCellColorOutsideRange = false
        CalendarView.Style.cellSelectedBorderColor = NPColorScheme(rawValue: 3)!.color
        CalendarView.Style.colorTheme = 3
        
        calendarView.backgroundColor = UIColor.clear
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.reloadData()
        
        measurementLabel.text = BPDataManager.Measurement
        measurementLabel.delegate = self
        timeLabel.text = BPDataManager.GetTiming()
        
        timeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapTimeView)))
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

    override func viewDidAppear(_ animated: Bool) {
        Global_ShowFrostGlass(self.view)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Global_HideFrostGlass()
    }
    
    @IBAction func closeButtonClick(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
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
    
    @objc func handleTapTimeView() {
        BPDataManager.Measurement = measurementLabel.text!
        
        let viewController = (self.storyboard?.instantiateViewController(withIdentifier: "NewBpAmdSecondViewController") as? NewBpAmdSecondViewController)!
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true, completion: nil)
    }
}

extension NewBpAmdThirdViewController: CalendarViewDataSource {
    func startDate() -> Date {
        return Date()
    }
    
    func endDate() -> Date {
        
        var dateComponents = DateComponents()
        
        dateComponents.year = 2
        let today = Date()
        
        let twoYearsFromNow = self.calendarView.calendar.date(byAdding: dateComponents, to: today)!
        
        return twoYearsFromNow
    }
}

extension NewBpAmdThirdViewController: CalendarViewDelegate {
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "GMT")!
        var components1 = calendar.dateComponents([.hour, .minute, .second], from: BPDataManager.Date)
        let components2 = calendar.dateComponents([.year, .month, .day], from: date)
        components1.day = components2.day
        components1.month = components2.month
        components1.year = components2.year
        
        BPDataManager.Date = calendar.date(from: components1)!
    }
    func calendar(_ calendar : CalendarView, didScrollToMonth date : Date) {
        
    }
}
