//
//  AddManuallyThirdViewController.swift
//  Nexpil
//
//  Created by mac on 9/3/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class BloodGlucoseAddManuallyThirdViewController: UIViewController {
    
    @IBOutlet weak var measurementLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var defaultCircle: UIImageView!
    
    var measurement: String = ""
    var time: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        measurementLabel.text = "\(measurement) mg/dl"
        timeLabel.text = time
        
        defaultCircle.layer.borderWidth = 2
        defaultCircle.layer.borderColor = #colorLiteral(red: 0.2862745098, green: 0.2235294118, blue: 0.8901960784, alpha: 1)
        defaultCircle.layer.cornerRadius = 15
        defaultCircle.backgroundColor = UIColor.white

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
//        calendarView.eventDates.append(["date":Date(), "type":"today"])
        calendarView.reloadData()
    }
    
    
    @IBAction func closeButtonClick(_ sender: Any) {
        presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func doneButtonClick(_ sender: Any) {
        let viewController = UIStoryboard(name: "Health", bundle: nil).instantiateViewController(withIdentifier: "BloodGlucoseAddManuallyFinalViewController") as! BloodGlucoseAddManuallyFinalViewController
        
        viewController.modalPresentationStyle = .overFullScreen
        
        let presentingVC = self.presentingViewController
        self.dismiss(animated: false, completion: {()->Void in
            presentingVC!.present(viewController, animated: false, completion: nil)
        })
    }
    
}

extension BloodGlucoseAddManuallyThirdViewController: CalendarViewDataSource {
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

extension BloodGlucoseAddManuallyThirdViewController: CalendarViewDelegate {
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yy"
        
        let dateString = formatter.string(from: date) // string purpose I add here
        
        print(dateString)
        self.dateLabel.text = dateString
    }
    func calendar(_ calendar : CalendarView, didScrollToMonth date : Date) {
        
    }
}
