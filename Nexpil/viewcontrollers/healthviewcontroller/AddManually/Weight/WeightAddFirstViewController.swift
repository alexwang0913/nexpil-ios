//
//  WeightAddFirstViewController.swift
//  Nexpil
//
//  Created by mac on 9/4/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class WeightAddFirstViewController: UIViewController {

    @IBOutlet weak var currentCircle: UIImageView!
    @IBOutlet weak var defaultCircle: UIImageView!
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var date: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentCircle.backgroundColor = UIColor.white
        currentCircle.layer.borderWidth = 2
        currentCircle.layer.borderColor = #colorLiteral(red: 0.2862745098, green: 0.2235294118, blue: 0.8901960784, alpha: 1)
        currentCircle.layer.cornerRadius = 15
        currentCircle.layer.masksToBounds = false
        
        defaultCircle.layer.borderWidth = 2
        defaultCircle.layer.borderColor = UIColor.lightGray.cgColor
        defaultCircle.layer.cornerRadius = 15
        defaultCircle.backgroundColor = UIColor.white
        
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
        
        date = GlobalManager.GetToday()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yy"
        
        let dateString = formatter.string(from: date!) // string purpose I add here
        
        self.dateLabel.text = dateString
    }
    
    @IBAction func nextButtonClick(_ sender: Any) {
        weak var pvc = self.presentingViewController
        self.dismiss(animated: false, completion: {
            let viewController = UIStoryboard(name: "Health", bundle: nil).instantiateViewController(withIdentifier: "WeightAddSecondViewController") as! WeightAddSecondViewController
            viewController.dateString = self.dateLabel.text ?? ""
            viewController.date = self.date
            viewController.modalPresentationStyle = .overFullScreen
            pvc?.present(viewController, animated: false, completion: nil)
        })
    }
    
    
    @IBAction func closeButtonClick(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Global_ShowFrostGlass(self.view)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Global_HideFrostGlass()
    }
}


extension WeightAddFirstViewController: CalendarViewDataSource {
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

extension WeightAddFirstViewController: CalendarViewDelegate {
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yy"
        
        let dateString = formatter.string(from: date) // string purpose I add here
        
        self.date = date
        self.dateLabel.text = dateString
    }
    func calendar(_ calendar : CalendarView, didScrollToMonth date : Date) {
        
    }
}
