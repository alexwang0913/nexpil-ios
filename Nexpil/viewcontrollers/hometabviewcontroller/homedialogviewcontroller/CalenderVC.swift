//
//  CalenderVC.swift
//  Nexpil
//
//  Created by mac on 8/23/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

public protocol CalenderVCDelegate {
    func closeCalendarDialog(_ date: Date)
}

class CalenderVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var vwCalendar: CalendarView!
    @IBOutlet weak var btnDone: NPButton!
    public var m_themeIdx = 0
    public var medicationCreateList: [Date] = []
    public var delegate: CalenderVCDelegate?
    @IBOutlet weak var dialogHeight: NSLayoutConstraint!
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    private var selectDate: Date = GlobalManager.GetToday()
    private var eventList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CalendarView.Style.cellShape                = .round
        CalendarView.Style.cellColorDefault         = UIColor.clear
        CalendarView.Style.headerTextColor          = NPColorScheme(rawValue: m_themeIdx)!.color
        CalendarView.Style.cellTextColorDefault     = UIColor.darkText
        CalendarView.Style.cellTextColorToday       = UIColor.white// NPColorScheme(rawValue: 0)!.color
        CalendarView.Style.firstWeekday             = .sunday
        CalendarView.Style.cellTextColorWeekend     = NPColorScheme(rawValue: m_themeIdx)!.color
        CalendarView.Style.locale                   = Locale(identifier: "en_US")
        CalendarView.Style.timeZone                 = TimeZone(abbreviation: "UTC")!
        CalendarView.Style.cellColorToday = NPColorScheme(rawValue: m_themeIdx)!.color
        CalendarView.Style.headerFontName = "Montserrat"
        CalendarView.Style.colorTheme = m_themeIdx
        CalendarView.Style.hideCellsOutsideDateRange = false
        CalendarView.Style.changeCellColorOutsideRange = false
        CalendarView.Style.cellSelectedBorderColor = NPColorScheme(rawValue: m_themeIdx)!.color
        
        vwCalendar.backgroundColor = UIColor.clear
        vwCalendar.dataSource = self
        vwCalendar.delegate = self
        // Add reminders
        for date in medicationCreateList {
            let event_date = date.addingTimeInterval(TimeInterval(3600 * 24 * 30))
            if GlobalManager.compareDate(event_date, GlobalManager.GetToday()) { // just skip today for event
                continue
            }
            vwCalendar.eventDates.append(["date": event_date, "description": "Refill medication"])
        }
        
        vwCalendar.reloadData()
        btnDone.colorScheme = m_themeIdx
        
        dialogHeight.constant = 400
        eventView.isHidden = true
        eventTableView.delegate = self
        eventTableView.dataSource = self
        
        let btnList = ["icon_add_more_morning", "icon_add_more_midday", "icon_add_more_evening", "icon_add_more_night"]
//        if let image = UIImage(named: btnList[m_themeIdx]) {
//            addButton.setImage(image, for: .disabled)
//        }
        addButton.setImage(UIImage(named: "icon_add_more_grey"), for: .disabled)
        addButton.isEnabled = false
    }

    @IBAction func onClose(){
        self.delegate?.closeCalendarDialog(self.selectDate)
        self.dismiss(animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventTableView.dequeueReusableCell(withIdentifier: "CalendarEventTableViewCell", for: indexPath) as! CalendarEventTableViewCell
        cell.eventText.text = self.eventList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension CalenderVC: CalendarViewDataSource {
    func startDate() -> Date {
        return Date()
    }
    
    func endDate() -> Date {
        
        var dateComponents = DateComponents()
        
        dateComponents.year = 2
        let today = Date()
        
        let twoYearsFromNow = self.vwCalendar.calendar.date(byAdding: dateComponents, to: today)!
        
        return twoYearsFromNow
        
    }
}


extension CalenderVC: CalendarViewDelegate {
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        self.selectDate = date
        eventList = []
        for item in self.vwCalendar.eventDates {
            let date1 = item["date"] as! Date
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM dd"
            formatter.timeZone = TimeZone(abbreviation: "GMT")
            
            if formatter.string(from: date) == formatter.string(from: date1) {
                let description = item["description"] as! String
                eventList.append(description)
            }
        }
        
        if eventList.count > 0 {
            self.eventTableView.reloadData()
            self.eventView.isHidden = false
            self.dialogHeight.constant = 600
        } else {
            self.eventView.isHidden = true
            self.dialogHeight.constant = 400
        }
    }
    
    func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {
        
    }
}

class CalendarEventTableViewCell: UITableViewCell {
    @IBOutlet weak var eventText: UILabel!
    
}
