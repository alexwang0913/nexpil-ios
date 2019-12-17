//
//  SummaryScreenViewController.swift
//  Nexpil
//
//  Created by Cagri Sahan on 9/5/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import UserNotifications
class SummaryScreenViewController: InformationCardEditViewController {
    
    var prescription: NPPrescription?
    
    @IBOutlet weak var fullNameCard: InformationCard!
    @IBOutlet weak var pharmacyCard: InformationCard!
    @IBOutlet weak var medicationCard: InformationCard!
    @IBOutlet weak var strengthCard: InformationCard!
    @IBOutlet weak var doctorCard: InformationCard!
    @IBOutlet weak var quantityCard: InformationCard!
    @IBOutlet weak var directionsCard: InformationCard!
    
    @IBOutlet weak var newDirectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var newDirectionLabel: UILabel!
    @IBOutlet weak var newDirectionView: UIView!
    @IBOutlet weak var cardHeight: NSLayoutConstraint!
    
    var asNeeded = 0
    var frequency = ""
    var amount = ""
    var timings = ""
    var quantity: Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
//        newDirectionView.layer.cornerRadius = 15
//        newDirectionView.addShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.16, x: 0, y: 3, blur: 6.0)
//        newDirectionViewHeight.constant = 73 + height(constraintedWidth: newDirectionLabel.frame.size.width, font: newDirectionLabel.font, str: DataUtils.getMedicationFrequency()!) - 15
        newDirectionLabel.numberOfLines = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.medicationCard.valueText = DataUtils.getMedicationName()!
        self.strengthCard.valueText = DataUtils.getMedicationStrength()!
        self.directionsCard.valueText = DataUtils.getMedicationFrequency()!
        self.newDirectionLabel.text = DataUtils.getMedicationFrequency()!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let h1 = self.strengthCard.containerView.frame.height
        let h2 = self.medicationCard.containerView.frame.height
        if cardHeight.constant < h1 {
            cardHeight.constant = h1
        }
        if cardHeight.constant < h2 {
            cardHeight.constant = h2
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? InformationCardEditViewController {
            vc.summaryPage = self
            super.prepare(for: segue, sender: sender)
        }
        else if let vc = segue.destination as? InformationCardEditDosageViewController {
            vc.summaryPage = self
            super.prepare(for: segue, sender: sender)
        }
    }
    
    @IBAction func gotoMedicationAddResult(_ sender: Any) {
        if self.medicationCard.valueText.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input medication name", title: "")
            return
        }
        if self.strengthCard.valueText.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input medication strength", title: "")
            return
        }
        if self.directionsCard.valueText.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input medication direction", title: "")
            return
        }
        var datas:[MyMedication] = []
        let currentDateTime = Date()
        let formatter = DateFormatter()
        var currentDate1 = ""
        formatter.timeZone = TimeZone.current
        let locale = NSLocale.current
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDate = formatter.string(from: currentDateTime)
        let formatter1 : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
        if formatter1.contains("a") {
            
            //phone is set to 12 hours
            formatter.dateFormat = "h:mm a"
            let time1 = formatter.string(from: currentDateTime)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            let date = formatter.date(from: time1)
            formatter.dateFormat = "HH:mm"
            currentDate1 = formatter.string(from: date!)
        } else {
            //phone is set to 24 hours
            formatter.dateFormat = "HH:mm"
            currentDate1 = formatter.string(from: currentDateTime)
        }
 
        let hour = currentDate1.components(separatedBy: ":")[0]
        let min = currentDate1.components(separatedBy: ":")[1]
        var min1 = Int(min)!/5
        min1 = min1 * 5
        let data = MyMedication.init(prescribe: "", directions: directionsCard.valueText, dose: "", image: "", quantity: self.quantity, type: "", taketime: self.timings, medicationname: medicationCard.valueText, filedDate: "", warning: "", frequency: self.frequency, strength: strengthCard.valueText, pharmacy: "", patientname: "", lefttablet: "", prescription: 0, createat: currentDate + " \(hour):\(min1)", endat:"", id:0, amount: self.amount, asneeded: self.asNeeded)
        datas.append(data)
        validateText(directionsCard.valueText,datas:datas)
    }
    var tablet = ""
    var times = ""
    func validateText(_ text : String,datas:[MyMedication]){
        addScheduling(ForText:directionsCard.valueText)
        DBManager.getObject().insetMedicationHistoryData1(datas: datas)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let medicationController = storyBoard.instantiateViewController(withIdentifier: "AddMedicationListViewController") as! AddMedicationListViewController
        self.navigationController?.pushViewController(medicationController, animated: true)
    }
    //take 1 Tablet by mouth 3 times a day
    
    let arrayOfTiming = [[9],[9,21],[9,14,21],[9,13,17,21],[5,9,14,17,21],[0,3,6,9,12,15,18,21],[1,5,9,13,17,21],[6,12,18,24],[8,16,24],[9,21],[21],[8,12,17],[8,12,17,21]]
    
    let arrayOfScheduling = ["Daily",
                             "2 times a day",
                             "3 times a day",
                             "4 times a day",
                             "5 times a day",
                             "Every 3 hours",
                             "Every 4 hours",
                             "Every 6 hours",
                             "Every 8 hours",
                             "Every 12 hours",
                             "Every 24 hours Bedtime",
                             "With meals",
                             "With meals and at bedtime"]
    
    func addScheduling(ForText:String){
        for i in 0..<arrayOfScheduling.count{
            if arrayOfScheduling[i] == ForText{
                for j in 0..<arrayOfTiming[i].count{
                    let date  = createDate(hour: arrayOfTiming[i][j], minute: 0)
                    scheduleNotification(at: date, body: "Time To Take Medicine \(medicationCard.valueText)", titles: "Remainder",id:"\(i)\(j)")
                }
                return
            }
        }
    }
    

    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Success"
        content.body = "Your new medication has been Added Successfully"
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func createDate(hour: Int, minute: Int)->Date{
        
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        components.timeZone = .current
        
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(from: components)!
    }
    
    //Schedule Notification with weekly bases.
    func scheduleNotification(at date: Date, body: String, titles:String,id:String) {
        let triggerWeekly = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
        let content = UNMutableNotificationContent()
        content.title = titles
        content.body = body
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "alarm"
        content.userInfo = ["id":id]
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        
        //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
            }
        }
    }
    
    func height(constraintedWidth width: CGFloat, font: UIFont, str: String) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = str
        label.font = font
        label.sizeToFit()
        
        return label.frame.height
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func crossAction(_ sender: UIButton) {
        self.view.addSubview(visualEffectView!)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CloseAddMedicationViewController") as! CloseAddMedicationViewController
        //viewController.tabBar.roundCorners([.topLeft, .topRight], radius: 10)
        viewController.delegate = self
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: false, completion: nil)
    }
    
    
}
//func addLogic(gap:Float){
    //
    //        let seconds = Date().timeIntervalSince1970
    //        let timestampDate = Date(timeIntervalSince1970: seconds)
    //        let dateFormatter1 = DateFormatter()
    //        dateFormatter1.dateFormat = "hh"
    //        let hr = Int(dateFormatter1.string(from: timestampDate))!
    //
    //        let dateFormatter2 = DateFormatter()
    //        dateFormatter2.dateFormat = "mm"
    //        let mm = Int(dateFormatter2.string(from: timestampDate))!
    //
    //        let dateFormatter3 = DateFormatter()
    //        dateFormatter3.dateFormat = "a"
    //        var a = dateFormatter3.string(from: timestampDate)
    //
    //        var timingToAdd = 0
    //        var some = 0
    //        let min = 60 - mm
    //        var cal2 = 9 - (hr - 1)
    //        if cal2 < 0 {
    //            some = 12 - (hr+1)
    //            a = "PM"
    //            cal2 = 8
    //        }
    //
    //        if a == "PM"{
    //            timingToAdd = 12
    //        }
    //
    //
    //        let cal  = cal2*60*60 + min*60 + timingToAdd*60*60 + some*60*60
    //
    //        startSchedulingWithGap(valueForTimer: cal, gap: gap)
    
//}

//    func startSchedulingWithGap(valueForTimer:Int,gap:Float){
//        Timer.scheduledTimer(withTimeInterval: TimeInterval(1*60), repeats: false) { _ in
//
//            let content = UNMutableNotificationContent()
//            content.title = "Reminder"
//            content.body = "Time To Take Medicine"
//            content.sound = UNNotificationSound.default()
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(2*60), repeats: true)
//            let request = UNNotificationRequest(identifier: "Reminder", content: content, trigger: trigger)
//            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//        }
//    }
//    func ScheduleNotification(withTime:Date){
//
//    }
