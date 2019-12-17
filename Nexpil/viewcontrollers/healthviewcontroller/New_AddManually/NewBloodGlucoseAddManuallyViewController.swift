//
//  NewBloodGlucoseAddManuallyViewController.swift
//  Nexpil
//
//  Created by Guang on 11/21/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class NewBloodGlucoseAddManuallyViewController: UIViewController {

    @IBOutlet weak var modalView: GradientView!
    @IBOutlet weak var modalHeight: NSLayoutConstraint!
    
    @IBOutlet weak var measurementLabel: UITextField!
    
    @IBOutlet weak var whenTitleView: GradientView!
    @IBOutlet weak var whenTitleViewHeight: NSLayoutConstraint!
    @IBOutlet weak var timingLabel: UILabel!
    
    @IBOutlet weak var whenDetailView: UIView!
    @IBOutlet weak var whenDetailHeight: NSLayoutConstraint!
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
    
    @IBOutlet weak var dateTitleView: GradientView!
    @IBOutlet weak var dateTitleViewHeight: NSLayoutConstraint!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var dateDetailView: UIView!
    @IBOutlet weak var dateDetailViewHeight: NSLayoutConstraint!
    @IBOutlet weak var calendarView: CalendarView!
    
    private var date: Date!
    private var beforeString = "Before" // "Before" or "After"
    private var afterString = "Breakfast" // "Breakfast", "Lunch", and "Dinner"
    
    // MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize height
        modalHeight.constant = 420
        whenDetailHeight.constant = 0
        whenDetailView.isHidden = true
        dateDetailViewHeight.constant = 0
        dateDetailView.isHidden = true
        
        // Add TapGesture to the UIViews
        whenTitleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickWhenTitleView)))
        dateTitleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickDateTitleView)))
        
        initWhenDetailView()
        
        date = GlobalManager.GetToday()
        dateLabel.text = getDate()
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
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Global_ShowFrostGlass(self.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Global_HideFrostGlass()
    }
    
//     MARK: - Normal functions
    func getDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        return formatter.string(from: date!)
    }
    
    func hideWhenTitleView() {
        whenTitleViewHeight.constant = 0
        whenTitleView.isHidden = true
    }
    
    func showWhenTitleView() {
        whenTitleViewHeight.constant = 73
        whenTitleView.isHidden = false
    }
    
    func showWhenDetailView() {
        whenDetailView.isHidden = false
        whenDetailHeight.constant = 200
    }
    
    func hideWhenDetailView() {
        whenDetailView.isHidden = true
        whenDetailHeight.constant = 0
    }
    
    func showDateTitleView() {
        dateTitleView.isHidden = false
        dateTitleViewHeight.constant = 73
    }
    
    func hideDateTitleView() {
        dateTitleView.isHidden = true
        dateTitleViewHeight.constant = 0
    }
    
    func showDateDetailView() {
        dateDetailView.isHidden = false
        dateDetailViewHeight.constant = 300
    }
    
    func hideDateDetailView() {
        dateDetailView.isHidden = true
        dateDetailViewHeight.constant = 0
    }
    
    func initWhenDetailView() {
        beforeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleBeforeViewTap(_:))))
        afterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleAfterViewTap(_:))))
        breakfastView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleBreakfastViewTap(_:))))
        launchView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleLanuchViewTap(_:))))
        dinnerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleDinnerViewTap(_:))))
    }
    
    func checkTimingType() -> Int {
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
    
    // MARK: - Event functions
    @objc func onClickWhenTitleView() {
        modalHeight.constant = 530
        
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

    
    @IBAction func onClickDoneButton(_ sender: Any) {
        let measurement = measurementLabel.text
        
        if measurement == "" {
            DataUtils.messageShow(view: self, message: "Enter measurement", title: "Confirm")
        } else {
            let timing = checkTimingType()
            let measurement = measurementLabel.text
            DataManager().insertBloodGlucose(date: date!, whenIndex: "\(timing)", value: (measurement as! NSString).integerValue)
            
            weak var pvc = self.presentingViewController
            self.dismiss(animated: false, completion: {
                let viewController = (self.storyboard?.instantiateViewController(withIdentifier: "BloodGlucoseAddManuallyFinalViewController") as? BloodGlucoseAddManuallyFinalViewController)!
                viewController.modalPresentationStyle = .overFullScreen
                pvc?.present(viewController, animated: false, completion: nil)
            })
        }
    }
    
    @IBAction func onClickCloseButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}

// MARK: - Extensions
extension NewBloodGlucoseAddManuallyViewController: CalendarViewDataSource {
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

extension NewBloodGlucoseAddManuallyViewController: CalendarViewDelegate {
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        self.date = date
        self.dateLabel.text = self.getDate()
    }
    func calendar(_ calendar : CalendarView, didScrollToMonth date : Date) {
        
    }
}
