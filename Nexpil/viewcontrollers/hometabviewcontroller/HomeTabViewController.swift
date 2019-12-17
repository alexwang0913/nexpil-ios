//
//  HomeTabViewController.swift
//  Nexpil
//
//  Created by Admin on 4/6/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

import XLPagerTabStrip
import CVCalendar
import Alamofire
import UserNotifications

protocol HomeSubMenuDelegate {
    func selectDay(value:Int) -> String
    func navColorChange(value:Int)
}

class HomeTabViewController: ButtonBarPagerTabStripViewController,HomeSubMenuDelegate,UITabBarControllerDelegate  {
    
    @IBOutlet weak var m_vwTopNavBar: UIView!
    @IBOutlet weak var m_vwTopContainer: UIView!
    
    @IBOutlet weak var m_vwRadialRight: UIView!
    @IBOutlet weak var m_vwRadialLeft: UIView!
    
    @IBOutlet var vwTodayFooters: [GradientView]!
    @IBOutlet var vwDays: [UIView]!
    
    @IBOutlet weak var m_fabAdd: FAButton!
    
    @IBOutlet weak var m_vwSeperate: UIView!
    @IBOutlet weak var m_stvwCalender: UIStackView!
    @IBOutlet weak var vwAgoDays: UIView!
    
    @IBOutlet var lblOverlayDays: [UILabel]!
    @IBOutlet var lblDays: [UILabel]!
    @IBOutlet var lblDates: [UILabel]!
    
    @IBOutlet var imgTaskIndicators: [UIImageView]!
    
    @IBOutlet weak var lcAgoDay: NSLayoutConstraint!
    
    @IBOutlet weak var m_vwMorning: UIView!
    @IBOutlet weak var m_ivMorning: UIImageView!
    @IBOutlet weak var m_cnstvwMorning: NSLayoutConstraint!
    
    @IBOutlet weak var m_vwMidDay: UIView!
    @IBOutlet weak var m_ivMidDay: UIImageView!
    @IBOutlet weak var m_cnstvwMidDay: NSLayoutConstraint!
    
    @IBOutlet weak var m_vwEvening: UIView!
    @IBOutlet weak var m_ivEvening: UIImageView!
    @IBOutlet weak var m_cnstvwEvening: NSLayoutConstraint!
    
    @IBOutlet weak var m_vwNight: UIView!
    @IBOutlet weak var m_ivNight: UIImageView!
    @IBOutlet weak var m_cnstvwNight: NSLayoutConstraint!
    
    @IBOutlet weak var m_cnstTopContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var vwGrey: GradientView!
    
    @IBOutlet weak var currentDate: UILabel!
    var oldCell:ButtonBarViewCell?
    var newCell:ButtonBarViewCell?
    
    var dateShow:Bool = false
    
    var child_1:MorningViewController1?
    
    var selectedDay = 0
    var dateColor:UIColor?
    
    var colorMorningActive = UIColor.init(hexString: "#39D3E3")
    var colorMidDayActive = UIColor.init(hexString: "#397EE3")
    var colorEveningActive = UIColor.init(hexString: "#415CE3")
    var colorNightActive = UIColor.init(hexString: "#4939E3")
    var colorDeactive = UIColor.init(hexString: "#707070")
    
    var m_fltNavLbHeight = 10
    
    var navIVArray: [UIImageView] = []
    var navVWArray: [UIView] = []
    var navColorActiveArray: [UIColor] = []
    var addBtnImagePathArray: [String] = []
    var topNavActiveArray: [String] = []
    var topNavDeactiveArray: [String] = []
    var firstDrugUsageDate: Date!
    
    @IBOutlet weak var dayofWeek: UIButton!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var currentDateLabel: UILabel!
    
    var m_selectedDate: Date!
    var m_showDate: Date!
    var m_taskDate: Date!
    var m_curtabPos = 0
    
    var medicationCreateList: [Date] = []
    @IBOutlet weak var todayBackgroundView: GradientView!
    @IBOutlet weak var rightBubble: NSLayoutConstraint!
    @IBOutlet weak var wendesdayBubble: UIView!
    
    override func viewDidLoad() {
        navColorActiveArray = [colorMorningActive, colorMidDayActive, colorEveningActive, colorNightActive] as! [UIColor]
        super.viewDidLoad()
        dateColor = UIColor.init(hex: "39d3e3")
        initNavBar()
        self.tabBarController?.delegate = self
        
//        self.view.backgroundColor = UIColor.white//UIColor.init(hexString: "#F7F7F7")
        containerView.isScrollEnabled = false
        barSettings()
        
        showCalendar(bShow: false)
        
        self.buttonBarView.backgroundColor = nil
        
        m_selectedDate = GlobalManager.GetToday()
        m_showDate = GlobalManager.GetToday()
        
//        m_taskDate = m_selectedDate.addingTimeInterval((TimeInterval)(3600 * 24))
        initCalenderLabels(m_selectedDate)

        for index in 0 ..< 7
        {
//            let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(timeSelect(sender:)))
            vwDays![index].tag = index
            vwDays![index].layer.cornerRadius = 10
            vwDays![index].layer.masksToBounds = true
//            vwDays![index].addGestureRecognizer(gesture2)
            vwTodayFooters[index].isHidden = true
        }
        vwTodayFooters[3].isHidden = false
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if type(of: appDelegate.window?.rootViewController) == UITabBarController.self {
            let vc = appDelegate.window?.rootViewController as! UITabBarController
            let vc_community = vc.viewControllers![2] as! CommunityMainViewController
            if vc_community.showCongPopup == true {
                mTabView.setSelectedIndex(2)
            }
        }
        
//        checkWendsdayBubble()
        
        // Event for double tap Home Tab Item
        NotificationCenter.default.addObserver(self, selector: #selector(onDoubleTapHomeTab(noti:)), name: Notification.Name.Action.DoubleTapHomeTab, object: nil)
        
        // Event for Top current date
        let currentDateTapGesture = UITapGestureRecognizer(target: self, action: #selector(dateShow(_:)))
   
    currentDateLabel.addGestureRecognizer(currentDateTapGesture)
        currentDateLabel.isUserInteractionEnabled = true
    }
    
    func initCalenderLabels(_ date: Date){
        let fmtDate = DateFormatter()
        fmtDate.dateFormat = "dd"
        fmtDate.timeZone = TimeZone(abbreviation: "GMT")
        
        let fmtDay = DateFormatter()
        fmtDay.dateFormat = "E"
        fmtDay.timeZone = TimeZone(abbreviation: "GMT")
        
        let fmtFull = DateFormatter()
        fmtFull.dateFormat = "yyyy-MM-dd"
        fmtFull.timeZone = TimeZone(abbreviation: "GMT")
        var fromGrey: Int?
        var toGrey: Int?
        
        // Get first medication date
        let params = [
            "userid": PreferenceHelper().getId(),
            "choice": "12"
            ] as [String : Any]
        Alamofire.request(DataUtils.APIURL + DataUtils.MYDRUG_URL, method: .post, parameters: params).responseJSON { response in
            if let data = response.result.value {
                let json : [String:Any] = data as! [String : Any]
                let result = json["status"] as? String
                if result == "true" {
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    
                    let firstDate_str = json["first_date"] as? String
                    let medication_createList = json["medication_createList"] as? [NSDictionary]
                    self.medicationCreateList = []
                    for item in medication_createList ?? []{
                        self.medicationCreateList.append(dateFormatter.date(from: item["createat"] as! String)!)
                    }
                    
                    var firstDate = GlobalManager.GetToday()
                    if firstDate_str != "" {
                        firstDate = dateFormatter.date(from: firstDate_str!)!
                    }
                    
                    
                    for i in 0..<7 {
                        if i < 3 {
                            let pickedDate = date.addingTimeInterval(TimeInterval(3600 * 24 * (i - 3)))
                            self.lblOverlayDays[i].text = fmtDate.string(from: pickedDate)
                            if self.firstDrugUsageDate != nil {
                                if pickedDate >= self.firstDrugUsageDate && pickedDate <= GlobalManager.GetToday() {
                                    if fromGrey == nil {
                                        fromGrey = i
                                    }
                                    if toGrey == nil && fromGrey != nil {
                                        toGrey = i
                                    }
                                    if toGrey != nil {
                                        if i > toGrey! {
                                            toGrey = i
                                        }
                                    }
                                }
                            }
                        }
                        let weekLabel = String((fmtDay.string(from: date.addingTimeInterval(TimeInterval(3600 * 24 * (i - 3)))) ).prefix(1))
                        self.lblDays[i].text = weekLabel
                        self.lblDates[i].text = fmtDate.string(from: date.addingTimeInterval(TimeInterval(3600 * 24 * (i - 3))))

                        let calendarDate = date.addingTimeInterval(TimeInterval(3600 * 24 * (i-3)))
                        if (calendarDate < firstDate) {
                            for recognizer in self.vwDays[i].gestureRecognizers ?? [] {
                                self.vwDays[i].removeGestureRecognizer(recognizer)
                            }
                        } else {
                            let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(self.timeSelect(sender:)))
                            self.vwDays[i].tag = i
                            self.vwDays![i].addGestureRecognizer(gesture2)
                        }
                        //            if (fmtFull.string(from:date.addingTimeInterval(TimeInterval(3600 * 24 * (i - 3)))) == fmtFull.string(from: m_taskDate)) {
                        //                imgTaskIndicators[i].isHidden = false
                        //            }
                        //            else
                        //            {
                        self.imgTaskIndicators[i].isHidden = true
                        //            }

                    }
                    
                    //        vwGrey.isHidden = true
                    //        if toGrey != nil && fromGrey != nil {
                    //            let itemWidth = CGFloat(vwAgoDays.frame.size.width / 3)
                    //            let width = itemWidth * CGFloat(toGrey! - fromGrey! + 1) - CGFloat(10)
                    //            vwGrey.frame = CGRect(x: CGFloat(itemWidth * CGFloat(fromGrey!) + 5), y: vwGrey.frame.origin.y, width: width, height: vwGrey.frame.size.height)
                    //            vwGrey.isHidden = false
                    //        }
                    fmtDate.dateFormat = "MMMM dd"
                    fmtDate.timeZone = TimeZone(abbreviation: "GMT")
                    self.currentDate.text = fmtDate.string(from: self.m_selectedDate).uppercased()
                    
                    self.showSelectedDate()
                }
            }
        }
    }
    
    func initNavBar() {
        
        navIVArray = [m_ivMorning, m_ivMidDay, m_ivEvening, m_ivNight]
        navVWArray = [m_vwMorning, m_vwMidDay, m_vwEvening, m_vwNight]
        
        addBtnImagePathArray = ["icon_add_more_morning", "icon_add_more_midday", "icon_add_more_evening", "icon_add_more_night"]
        topNavActiveArray = ["morn_on", "midday_on", "even_on", "night_on"]
        topNavDeactiveArray = ["morn_off", "midday_off", "even_off", "night_off"]
        
        selectNavItem(position: 0)
        navColorChange(value: 0)
    }

    func selectNavItem(position: Int) {
        for i in 0...3 {
        
            if (i != position) {
                navIVArray[i].tintColor = colorDeactive
                navIVArray[i].image = UIImage.init(named: topNavDeactiveArray[i])
            }
        }
        selectedDay = position
        navIVArray[position].image = UIImage.init(named: topNavActiveArray[position])
        m_curtabPos = position
        child_1!.m_currentColor = navColorActiveArray[position]
        child_1!.getPatientMedications(position)
        navColorChange(value: position)

        pointLabel.textColor = navColorActiveArray[position]
        
        todayBackgroundView.topColor = UIColor(cgColor: NPColorScheme(rawValue: position)!.gradient[0])
        todayBackgroundView.bottomColor = UIColor(cgColor: NPColorScheme(rawValue: position)!.gradient[1])
        
        for i in 0...6 {
            vwTodayFooters[i].topColor = UIColor(cgColor: NPColorScheme(rawValue: position)!.gradient[0])
            vwTodayFooters[i].bottomColor = UIColor(cgColor: NPColorScheme(rawValue: position)!.gradient[1])
            if i != 3 {
                lblDays[i].textColor = NPColorScheme(rawValue: position)!.color
            }
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

    }
    
    @objc func timeSelect(sender : UITapGestureRecognizer) {
        let tag = sender.view!.tag
        let fmtDate = DateFormatter()
        fmtDate.dateFormat = "MMMM dd"
        fmtDate.timeZone = TimeZone(abbreviation: "GMT")
        
        let today = GlobalManager.GetToday()
        let date = today.addingTimeInterval(TimeInterval(3600 * 24 * (tag - 3)))
        if GlobalManager.compareDate(date, m_selectedDate) {
            popupCalendar()
        }
        for i in 0...6 {
            if (i == tag) {
                self.vwTodayFooters[i].isHidden = false
            } else {
                self.vwTodayFooters[i].isHidden = true
            }
        }
        
        m_selectedDate = today.addingTimeInterval(TimeInterval(3600 * 24 * (tag - 3)))
        self.currentDate.text = fmtDate.string(from: self.m_selectedDate).uppercased()
        
        
        self.showSelectedDate()
//        checkWendsdayBubble()
    }
    
    
    
    func checkWendsdayBubble(_ show: Bool) {
//        var calendar = Calendar.current
//        calendar.timeZone = TimeZone(abbreviation: "GMT")!
//        let weekday = calendar.component(.weekday, from: m_selectedDate)
//        let todayWeekday = calendar.component(.weekday, from: GlobalManager.GetToday())
//        let weekday = Calendar.current.component(.weekday, from: m_selectedDate)
//        if weekday == 4 && todayWeekday != 4 { //wendesday
        if show {
            wendesdayBubble.isHidden = false
            m_vwRadialRight.isHidden = true
        } else {
            wendesdayBubble.isHidden = true
            m_vwRadialRight.isHidden = false
        }
    }
    
    func showSelectedDate() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd"
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        
        if formatter.string(from: m_selectedDate) == formatter.string(from: GlobalManager.GetToday())
        {
            currentDateLabel.text = "Today"
//            dayofWeek.setTitle("Today", for: .normal)
        }
        else
        {
            let fmtDay = DateFormatter()
            fmtDay.dateFormat = "EEEE"
            fmtDay.timeZone = TimeZone(abbreviation: "GMT")
            currentDateLabel.text = fmtDay.string(from: m_selectedDate)
//            dayofWeek.setTitle(fmtDay.string(from: m_selectedDate), for: .normal)
        }                
        
        let fmtFull = DateFormatter()
        fmtFull.dateFormat = "yyyy-MM-dd"
        fmtFull.timeZone = TimeZone(abbreviation: "GMT")
//        selectedDay
//        if fmtFull.string(from: m_selectedDate) == fmtFull.string(from: m_taskDate) {
//            child_1?.ShowTasks = true
//        }
//        else {
//            child_1?.ShowTasks = false
//        }
        child_1!.currentDate = formatter.string(from: m_selectedDate)
        child_1!.selectedDate = m_selectedDate
        child_1!.getPatientMedications(m_curtabPos)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        m_vwRadialLeft.layer.cornerRadius = m_vwRadialLeft.frame.width / 2
        m_vwRadialRight.layer.cornerRadius = m_vwRadialRight.frame.width / 2
        wendesdayBubble.layer.cornerRadius = wendesdayBubble.frame.width / 2
        lcAgoDay.constant = 146 * buttonBarView.frame.size.width / 355
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Alamofire.request(DataUtils.APIURL + DataUtils.MYDRUG_URL, method: .post, parameters: ["userid":PreferenceHelper().getId(), "choice":"8"])
            .responseJSON(completionHandler: { response in
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                if let data = response.result.value {
                    let json : [String:Any] = data as! [String : Any]
                    let result = json["status"] as? String
                    if result == "true"
                    {
                        var firstDrugDate = json["createat"] as? String
                        firstDrugDate = firstDrugDate!.components(separatedBy: " ")[0]
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        formatter.timeZone = TimeZone(abbreviation: "GMT")
                        self.firstDrugUsageDate = formatter.date(from: firstDrugDate!)
                        
                        let today = GlobalManager.GetToday()
                        self.initCalenderLabels(today)
                    }
                }
            })
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        child_1 = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "morningviewcontroller1") as? MorningViewController1
        child_1!.m_currentColor = navColorActiveArray[0]
        child_1!.delegate = self
        return [child_1!]
    }
    
    func barSettings()
    {
        buttonBarView.selectedBar.backgroundColor = UIColor.init(hex: "39d3e3")
        settings.style.buttonBarBackgroundColor = UIColor.init(hex: "ffffff")
        settings.style.buttonBarItemBackgroundColor = UIColor.clear//init(hex: "f7f7fa")
        settings.style.selectedBarBackgroundColor = UIColor.init(hex: "ffffff")
        settings.style.buttonBarItemFont = UIFont(name: "Montserrat-Medium", size: 18)!
        settings.style.selectedBarHeight = 0.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = UIColor.init(hex: "333333")
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        m_vwTopContainer.layer.cornerRadius = 15.0
        m_vwTopContainer.addShadow(color: #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1), alpha: 1, x: 0, y: 5, blur: 15.0)
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else {
                return }
            
            oldCell?.isSelected = false
            oldCell?.isHighlighted = false
            oldCell?.label.textColor = UIColor.init(hex: "333333").withAlphaComponent(0.5)
            
            self?.oldCell = oldCell

            newCell?.isHighlighted = true
            newCell?.label.textColor = UIColor.init(hex: "39d3e3")
            self?.newCell = newCell
        }
    }
    
    func selectDay(value: Int) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd"
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        
        switch value{
        case 0:
            dateColor = UIColor.init(hex: "39d3e3")
        case 1:
            dateColor = UIColor.init(hex: "397ee3")
        case 2:
            dateColor = UIColor.init(hex: "415ce3")
        case 3:
            dateColor = UIColor.init(hex: "4939e3")
        default:
            break
        }
        pointLabel.textColor = dateColor
        
        if newCell != nil && oldCell != nil {
            selectedDay = value
            switch value{
            case 0:
                self.newCell?.label.textColor = UIColor.init(hex: "39d3e3")
                self.newCell?.label.font = UIFont(name: "Montserrat-Medium", size: 20)
                self.oldCell?.label.font = UIFont(name: "Montserrat-Medium", size: 18)
                buttonBarView.selectedBar.backgroundColor = UIColor.init(hex: "39d3e3")
            case 1:
                self.newCell?.label.textColor = UIColor.init(hex: "397ee3")
                self.newCell?.label.font = UIFont(name: "Montserrat-Medium", size: 20)
                self.oldCell?.label.font = UIFont(name: "Montserrat-Medium", size: 18)
                buttonBarView.selectedBar.backgroundColor = UIColor.init(hex: "397ee3")
            case 2:
                self.newCell?.label.textColor = UIColor.init(hex: "415ce3")
                self.newCell?.label.font = UIFont(name: "Montserrat-Medium", size: 20)
                self.oldCell?.label.font = UIFont(name: "Montserrat-Medium", size: 18)
                buttonBarView.selectedBar.backgroundColor = UIColor.init(hex: "415ce3")
            case 3:
                self.newCell?.label.textColor = UIColor.init(hex: "4939e3")
                self.newCell?.label.font = UIFont(name: "Montserrat-Medium", size: 20)
                self.oldCell?.label.font = UIFont(name: "Montserrat-Medium", size: 18)
                buttonBarView.selectedBar.backgroundColor = UIColor.init(hex: "4939e3")
            default:
                break
            }
            showSelectedDate()
            return formatter.string(from: m_selectedDate)
        }
        else
        {
            return formatter.string(from: m_selectedDate)
        }
        
    }
    
    func navColorChange(value: Int) {
        
        m_vwRadialLeft.backgroundColor = navColorActiveArray[value]
        m_vwRadialRight.backgroundColor = navColorActiveArray[value]
        wendesdayBubble.backgroundColor = navColorActiveArray[value]
        
        m_fabAdd.buttonImage = UIImage.init(named: addBtnImagePathArray[value])
        
    }
    
    @objc func dateShow(_ sender: Any) {
        dateShow = !dateShow
        showCalendar(bShow: dateShow)
        checkWendsdayBubble(dateShow)
    }
    
    func popupCalendar(){
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "CalenderVC") as! CalenderVC
        vc.modalPresentationStyle = .overFullScreen
        vc.medicationCreateList = self.medicationCreateList
        vc.m_themeIdx = selectedDay
        vc.delegate = self
        self.present(vc, animated: false)
    }
    
    func showCalendar (bShow: Bool) {
        
        if bShow == true
        {
            m_cnstTopContainerHeight.constant = 183
            m_vwSeperate.isHidden = false
            m_stvwCalender.isHidden = false
            vwAgoDays.isHidden = false
        }
        else{
            m_cnstTopContainerHeight.constant = 83
            m_vwSeperate.isHidden = true
            m_stvwCalender.isHidden = true
            vwAgoDays.isHidden = true
        }
    }
    
    @IBAction func tapNavMorning(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name.Action.UpdateTabBarItem, object: ["index": "0"])
        selectNavItem(position: 0)
    }
    
    @IBAction func tapNavMidDay(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name.Action.UpdateTabBarItem, object: ["index": "1"])
        selectNavItem(position: 1)
    }
    
    @IBAction func tapNavEvening(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name.Action.UpdateTabBarItem, object: ["index": "2"])
        selectNavItem(position: 2)
    }
    
    @IBAction func tapNavNight(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name.Action.UpdateTabBarItem, object: ["index": "3"])
        selectNavItem(position: 3)
    }
    @IBAction func addMedication(_ sender: Any) {
        UserDefaults.standard.set("y", forKey: "logged")
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddDrugNavigationVC") as! UINavigationController
        UserDefaults.standard.set("true", forKey: "reloadProfileItems")
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: false, completion: nil)
    }
    
    @objc func onDoubleTapHomeTab(noti: Notification) {
        selectNavItem(position: 0)
        navColorChange(value: 0)
        NotificationCenter.default.post(name: Notification.Name.Action.UpdateTabBarItem, object: ["index": "0"])
        child_1?.setTableViewScrollTop()
    }
}


extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem as Any, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}

public class CellTask: UITableViewCell{
    @IBOutlet weak var lblName: UILabel!
    public func SetData(_ name: String)
    {
        lblName.text = name
    }
}

extension HomeTabViewController: CalenderVCDelegate {
    func closeCalendarDialog(_ date: Date) {
        let fmtDate = DateFormatter()
        fmtDate.dateFormat = "MMMM dd"
        fmtDate.timeZone = TimeZone(abbreviation: "GMT")
        
        self.m_selectedDate = date
        self.currentDate.text = fmtDate.string(from: self.m_selectedDate).uppercased()
        self.showSelectedDate()
        
        let today = GlobalManager.GetToday()
        for i in 0...6 {
            let pickDate = today.addingTimeInterval(TimeInterval(3600 * 24 * (i - 3)))
            if fmtDate.string(from: date) == fmtDate.string(from: pickDate) {
                vwTodayFooters[i].isHidden = false
            } else {
                vwTodayFooters[i].isHidden = true
            }
        }
    }
}
