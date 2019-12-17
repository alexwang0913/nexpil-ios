//
//  NewMoodAmdSecondViewController.swift
//  Nexpil
//
//  Created by Guang on 11/5/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class NewMoodAmdSecondViewController: UIViewController {

    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var feelingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
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
        
        feelingLabel.text = MoodDataManager.GetFeelingString()
        updateDateLabel()
    }

    @IBAction func closeButtonClick(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func nextButtonClick(_ sender: Any) {
        weak var pvc = self.presentingViewController
        self.dismiss(animated: false, completion: {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewMoodAmdThirdViewController") as! NewMoodAmdThirdViewController
            vc.modalPresentationStyle = .overFullScreen
            pvc?.present(vc, animated: false, completion: nil)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Global_ShowFrostGlass(self.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Global_HideFrostGlass()
    }
    
    func updateDateLabel() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        dateLabel.text = formatter.string(from: MoodDataManager.Date)
    }
}

extension NewMoodAmdSecondViewController: CalendarViewDataSource {
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

extension NewMoodAmdSecondViewController: CalendarViewDelegate {
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        MoodDataManager.Date = date
        self.updateDateLabel()
    }
    func calendar(_ calendar : CalendarView, didScrollToMonth date : Date) {
        
    }
}
