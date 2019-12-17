//
//  NewBgAmdThirdViewController.swift
//  Nexpil
//
//  Created by Guang on 11/3/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class NewBgAmdThirdViewController: UIViewController {

    @IBOutlet weak var measurementLabel: UITextField!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var timingView: GradientView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CalendarView.Style.cellShape                = .round
        CalendarView.Style.cellColorDefault         = UIColor.clear
        CalendarView.Style.headerTextColor          = NPColorScheme(rawValue: 1)!.color
        CalendarView.Style.cellTextColorDefault     = UIColor.darkText
        CalendarView.Style.cellTextColorToday       = UIColor.white
        CalendarView.Style.firstWeekday             = .sunday
        CalendarView.Style.cellTextColorWeekend     = NPColorScheme(rawValue: 1)!.color
        CalendarView.Style.locale                   = Locale(identifier: "en_US")
        CalendarView.Style.timeZone                 = TimeZone(abbreviation: "UTC")!
        CalendarView.Style.cellColorToday = NPColorScheme(rawValue: 1)!.color
        CalendarView.Style.headerFontName = "Montserrat"
        
        CalendarView.Style.hideCellsOutsideDateRange = false
        CalendarView.Style.changeCellColorOutsideRange = false
        CalendarView.Style.cellSelectedBorderColor = NPColorScheme(rawValue: 1)!.color
        CalendarView.Style.colorTheme = 1
        
        calendarView.backgroundColor = UIColor.clear
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.reloadData()
        
        measurementLabel.text = BGDataManager.Measurement
        timingLabel.text = BGDataManager.GetTiming()
        timingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showTimingView)))
    }

    @IBAction func closeButtonClick(_ sender: UIButton) {
        close()
    }
    
    private func close() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func closeDialog() {
        close()
    }
    
    func closeCurrentDialog() {
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
    
    override func viewWillAppear(_ animated: Bool) {
        Global_ShowFrostGlass(self.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Global_HideFrostGlass()
    }
}

extension NewBgAmdThirdViewController: CalendarViewDataSource {
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

extension NewBgAmdThirdViewController: CalendarViewDelegate {
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        BGDataManager.Date = date
    }
    func calendar(_ calendar : CalendarView, didScrollToMonth date : Date) {
        
    }
}
