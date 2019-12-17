//
//  NewBloodPressureAddManuallyViewController.swift
//  Nexpil
//
//  Created by mac on 11/21/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class NewBloodPressureAddManuallyViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var modalTitle: UILabel!
    @IBOutlet weak var modalView: GradientView!
    @IBOutlet weak var modalHeight: NSLayoutConstraint!
    
    @IBOutlet weak var measurementLabel: UITextField!
    
    @IBOutlet weak var whenTitleView: GradientView!
    @IBOutlet weak var whenTitleHeight: NSLayoutConstraint!
    @IBOutlet weak var titleTimeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var whenDetailView: UIView!
    @IBOutlet weak var whenDetailHeight: NSLayoutConstraint!
    @IBOutlet weak var amButton: UIButton!
    @IBOutlet weak var pmButton: UIButton!
    @IBOutlet var hourViews: [GradientView]!
    @IBOutlet var minViews: [GradientView]!
    @IBOutlet var hourLabels: [UILabel]!
    @IBOutlet var minLabels: [UILabel]!
    
    @IBOutlet weak var dateTitleView: GradientView!
    @IBOutlet weak var dateTitleHeight: NSLayoutConstraint!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateDetailView: UIView!
    @IBOutlet weak var dateDetailHeight: NSLayoutConstraint!
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var doneButton: NPButton!
    
    public var colorTheme = 1 // 1: BloodPressure, 2: OxygenLevel
    
    private var date: Date!
    private var hour = 1
    private var min = 5
    private var identifyAmPm = 0 // 0: AM 1: PM
    private var backspacePressed = false
    
    
    // MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize height
        modalHeight.constant = 420
        whenDetailHeight.constant = 0
        whenDetailView.isHidden = true
        dateDetailHeight.constant = 0
        dateDetailView.isHidden = true
        
        // Add TapGesture to the UIViews
        whenTitleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickWhenTitleView)))
        dateTitleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickDateTitleView)))
        
        initWhenDetailView()
        
        date = GlobalManager.GetToday()
        dateLabel.text = getDate()
        CalendarView.Style.cellShape                = .round
        CalendarView.Style.cellColorDefault         = UIColor.clear
        
        CalendarView.Style.cellTextColorDefault     = UIColor.darkText
        CalendarView.Style.cellTextColorToday       = UIColor.white
        CalendarView.Style.firstWeekday             = .sunday
        
        CalendarView.Style.locale                   = Locale(identifier: "en_US")
        CalendarView.Style.timeZone                 = TimeZone(abbreviation: "UTC")!
        
        CalendarView.Style.headerFontName = "Montserrat"
        
        CalendarView.Style.hideCellsOutsideDateRange = false
        CalendarView.Style.changeCellColorOutsideRange = false
        
        
        if colorTheme == 1 { //Blood Pressue
            modalTitle.text = "Blood Pressure"
            modalTitle.textColor = NPColorScheme(rawValue: 3)!.color
            
            CalendarView.Style.headerTextColor = NPColorScheme(rawValue: 3)!.color
            CalendarView.Style.cellTextColorWeekend = NPColorScheme(rawValue: 3)!.color
            CalendarView.Style.cellColorToday = NPColorScheme(rawValue: 3)!.color
            CalendarView.Style.cellSelectedBorderColor = NPColorScheme(rawValue: 3)!.color
            CalendarView.Style.colorTheme = 3
            
            whenTitleView.topColor = UIColor(cgColor: NPColorScheme(rawValue: 3)!.gradient[0])
            whenTitleView.bottomColor = UIColor(cgColor: NPColorScheme(rawValue: 3)!.gradient[0])
            dateTitleView.topColor = UIColor(cgColor: NPColorScheme(rawValue: 3)!.gradient[0])
            dateTitleView.bottomColor = UIColor(cgColor: NPColorScheme(rawValue: 3)!.gradient[0])
            
            doneButton.colorScheme = 3
        } else { //Oxygen Level
            modalTitle.text = "Oxygen Level"
            modalTitle.textColor = NPColorScheme(rawValue: 0)!.color
            
            CalendarView.Style.headerTextColor = NPColorScheme(rawValue: 0)!.color
            CalendarView.Style.cellTextColorWeekend = NPColorScheme(rawValue: 0)!.color
            CalendarView.Style.cellColorToday = NPColorScheme(rawValue: 0)!.color
            CalendarView.Style.cellSelectedBorderColor = NPColorScheme(rawValue: 0)!.color
            CalendarView.Style.colorTheme = 0
            
            whenTitleView.topColor = UIColor(cgColor: NPColorScheme(rawValue: 0)!.gradient[0])
            whenTitleView.bottomColor = UIColor(cgColor: NPColorScheme(rawValue: 0)!.gradient[0])
            dateTitleView.topColor = UIColor(cgColor: NPColorScheme(rawValue: 0)!.gradient[0])
            dateTitleView.bottomColor = UIColor(cgColor: NPColorScheme(rawValue: 0)!.gradient[0])
            
            doneButton.colorScheme = 0
        }
        
        calendarView.backgroundColor = UIColor.clear
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.reloadData()
        
        self.hideKeyboardWhenTappedAround()
        measurementLabel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Global_ShowFrostGlass(self.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Global_HideFrostGlass()
    }
    
    // MARK: - Normal functions
    func getDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        return formatter.string(from: date!)
    }
    
    func hideWhenTitleView() {
        whenTitleHeight.constant = 0
        whenTitleView.isHidden = true
    }
    
    func showWhenTitleView() {
        whenTitleHeight.constant = 73
        whenTitleView.isHidden = false
    }
    
    func showWhenDetailView() {
        whenDetailView.isHidden = false
        whenDetailHeight.constant = 320
    }
    
    func hideWhenDetailView() {
        whenDetailView.isHidden = true
        whenDetailHeight.constant = 0
    }
    
    func showDateTitleView() {
        dateTitleView.isHidden = false
        dateTitleHeight.constant = 73
    }
    
    func hideDateTitleView() {
        dateTitleView.isHidden = true
        dateTitleHeight.constant = 0
    }
    
    func showDateDetailView() {
        dateDetailView.isHidden = false
        dateDetailHeight.constant = 300
    }
    
    func hideDateDetailView() {
        dateDetailView.isHidden = true
        dateDetailHeight.constant = 0
    }
    
    func initWhenDetailView() {
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
    }
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
        
        if ((firstDigit < 3 && text?.count == 3) || (firstDigit > 2 && text?.count == 2)) && !backspacePressed && colorTheme == 1 {
            textField.text! += "/"
        }
        
        if text!.contains("/") {
            let secondValue = text?.components(separatedBy: "/")[1]
            if (firstDigit == 1 && secondValue?.count == 3) || (firstDigit != 1 && secondValue?.count == 2) {
                self.view.endEditing(true)
            }
        }
    }
    
    func GetTiming() -> String {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "GMT")!
        var hour = calendar.component(.hour, from: date)
        var min = calendar.component(.minute, from: date)
        min = (min/5) * 5
        if hour > 12 {
            hour -= 12
            return "\(hour):\(min)pm"
        } else {
            return "\(hour):\(min)am"
        }
    }
    
    func GetTimeIndex() -> String {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "GMT")!
        let hour = calendar.component(.hour, from: date)
        
        if hour >= 1 && hour <= 11 {
            return "0"
        } else if hour == 0 || (hour >= 12 && hour <= 14) {
            return "1"
        } else if hour >= 15 && hour <= 23 {
            return "2"
        }
        return "0"
    }
    // MARK: - Event functions
    @objc func onClickWhenTitleView() {
        modalHeight.constant = 650
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.hideWhenTitleView()
            self.showWhenDetailView()
            self.showDateTitleView()
            self.hideDateDetailView()
        })
    }
    
    @objc func onClickDateTitleView() {
        modalHeight.constant = 620
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.showWhenTitleView()
            self.hideWhenDetailView()
            self.hideDateTitleView()
            self.showDateDetailView()
        })
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
        if colorTheme == 1 { // Blood Pressure
            view.topColor = UIColor(cgColor: NPColorScheme(rawValue: 3)!.gradient[0])
            view.bottomColor = UIColor(cgColor: NPColorScheme(rawValue: 3)!.gradient[1])
        } else { // Oxygen Level
            view.topColor = UIColor(cgColor: NPColorScheme(rawValue: 0)!.gradient[0])
            view.bottomColor = UIColor(cgColor: NPColorScheme(rawValue: 0)!.gradient[1])
        }
        
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
    
    // MARK: - IBAction functions
    @IBAction func amButtonClick(_ sender: Any) {
        setAmButtonActive()
        
    }
    
    @IBAction func pmButtonClick(_ sender: Any) {
        setPmButtonActive()
    }
    
    @IBAction func onClickCloseButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func onClickDoneButton(_ sender: Any) {
        let measurement = measurementLabel.text
        
        if colorTheme == 1 { // Blood Presure
            let value1 = (measurement!.components(separatedBy: "/")[0] as NSString).integerValue
            let value2 = (measurement!.components(separatedBy: "/")[1] as NSString).integerValue
            DataManager().insertBloodPressure(date: date, time: GetTiming(), timeIndex: GetTimeIndex(), value1: value1, value2: value2)
            let pvc = self.presentingViewController
            self.dismiss(animated: false, completion: {
                let viewController = (self.storyboard?.instantiateViewController(withIdentifier: "BloodPressureAddManuallyFinalViewController") as? BloodPressureAddManuallyFinalViewController)!
                viewController.modalPresentationStyle = .overFullScreen
                pvc?.present(viewController, animated: false, completion: nil)
            })
        } else { // Oxygen Level
            let value = (measurement as! NSString).integerValue
            
            DataManager().insertOxygenLevel(date: date, time: GetTiming(), timeIndex: GetTimeIndex(), value: value)
            
            let pvc = self.presentingViewController
            self.dismiss(animated: false, completion: {
                let finalVC = self.storyboard?.instantiateViewController(withIdentifier: "OxygenLevelAddManuallyFinalViewController") as? OxygenLevelAddManuallyFinalViewController
                finalVC?.modalPresentationStyle = .overFullScreen
                pvc?.present(finalVC!, animated: false, completion: nil)
            })
        }
    }
}
    // MARK: - Extensions
extension NewBloodPressureAddManuallyViewController: CalendarViewDataSource {
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

extension NewBloodPressureAddManuallyViewController: CalendarViewDelegate {
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        self.date = date
        self.dateLabel.text = self.getDate()
    }
    func calendar(_ calendar : CalendarView, didScrollToMonth date : Date) {
        
    }
}
