//
//  MorningViewController1.swift
//  Nexpil
//
//  Created by Admin on 4/12/18.
//  Updated by Guang on 19/10/19
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Alamofire
import XLPagerTabStrip

enum CellType: Int {
    case time = 0
    case asneeded
    case taken
    case untaken
    case item
    case takeall
    case take
    case alltakenexpand
    case alltakencollapse
    case addcell
    case asneedRemember
    case asneedHistory
    case divider
    case prevDay
    case empty
    case futureDay
}

protocol MorningVCDelegate {
    func updateDate(date: Date)
}

class MorningViewController1: UITableViewController {

    var delegate: HomeSubMenuDelegate?
    var patientmedications : [MyMedication] = []
    var medicationTimes : [MedicationTime] = []
    var cellTypes : [ItemType] = []
    var patientindexies:[Int] = []
    var m_takenTimes = [[String: Any]]()
    
    var currentDate : String = ""   
    var m_takeTimesType = [String]()
    var m_curTimeDuration = 0
    var selectedDate: Date = GlobalManager.GetToday()
    
    var taketime = "Morning"
    
    var m_DicAllItemTakenCollapsed = [String: Bool]()
    
    public var ShowTasks: Bool = false
    var m_tasks = ["Check Blood Pressure", "Go for a walk", "Refill Metformin"]
    var asneededHistories: [NSDictionary] = []
    public var m_currentColor: UIColor!
    
    private var drugInfo: [[String: Any]] = []
    private var tableDatas: [[String: Any]] = []
    private var asneededDrugs: [[String: Any]] = []
    
    let numberWords = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.allowsSelection = false
        self.tableView.alwaysBounceVertical = false
        
        selectedDate = GlobalManager.GetToday()
        
        NotificationCenter.default.addObserver(self, selector: #selector(eventForAddMedications(noti:)), name: Notification.Name.Action.FinishAddDrug, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        currentDate = self.delegate!.selectDay(value: 0)
        
        if DataUtils.isConnectedToNetwork() == false
        {
            DataUtils.messageShow(view: self, message: "Please check your internet connection.", title: "")
            return
        }
        
        selectedDate = GlobalManager.GetToday()
        getPatientMedications(m_curTimeDuration)        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func eventForAddMedications(noti: Notification) {
        getPatientMedications(m_curTimeDuration)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableDatas = []
        
        // Check PrevDay
        if !GlobalManager.compareDate(GlobalManager.GetToday(), self.selectedDate) && self.selectedDate < GlobalManager.GetToday() {
            self.tableDatas.append(["type": CellType.prevDay])
        }
        
        // Check FutureDay
        if !GlobalManager.compareDate(GlobalManager.GetToday(), self.selectedDate) && self.selectedDate > GlobalManager.GetToday() {
            self.tableDatas.append(["type": CellType.futureDay])
        }
        
        for (idx, drugInfo) in self.drugInfo.enumerated() {
            let timing = drugInfo["timing"] as! String
            let untaken_drugs = drugInfo["untake_drugs"] as! [[String: Any]]
            let taken_drugs = drugInfo["take_drugs"] as! [[String: Any]]
            
            self.tableDatas.append(["type": CellType.time, "data" : timing])
            
            if (!m_DicAllItemTakenCollapsed.keys.contains(timing)) {
                m_DicAllItemTakenCollapsed[timing] = true
            } else {
                if m_DicAllItemTakenCollapsed[timing] == true && untaken_drugs.count == 0 && taken_drugs.count > 1 {
                    self.tableDatas.append([
                        "type": CellType.alltakencollapse,
                        "data": taken_drugs[0]["taken_time"] as! String,
                        "index": idx,
                        "count": taken_drugs.count
                    ])
                } else {
                    if untaken_drugs.count == 0 && taken_drugs.count > 1 {
                        self.tableDatas.append([
                            "type": CellType.alltakenexpand,
                            "data": taken_drugs[0]["taken_time"] as! String,
                            "index": idx,
                            "count": taken_drugs.count
                        ])
                    }
                    for untaken_drug in untaken_drugs {
                        self.tableDatas.append(["type": CellType.untaken, "data": untaken_drug])
                    }
                    
                    for taken_drug in taken_drugs {
                        self.tableDatas.append(["type": CellType.taken, "data": taken_drug])
                    }
                    
                    // Hide <Take> and <Take All> button for prev and future dates.
                    if GlobalManager.compareDate(GlobalManager.GetToday(), self.selectedDate) {
                        if untaken_drugs.count > 1 {
                            self.tableDatas.append(["type": CellType.takeall, "data": timing])
                        } else if untaken_drugs.count == 1 {
                            self.tableDatas.append(["type": CellType.take, "data": timing])
                        }
                    }
                }
            }
            
            self.tableDatas.append(["type": CellType.divider])
        }
        
        // Add asneeded
        if self.asneededDrugs.count > 0 {
            self.tableDatas.append(["type": CellType.asneeded])
        }
        for (idx, item) in self.asneededDrugs.enumerated() {
            let histories = item["history"] as! [[String: Any]]
            if histories.count > 0 {
                self.tableDatas.append(["type": CellType.asneedRemember])
                
                self.tableDatas.append(["type": CellType.asneedHistory, "data": histories])
                
            }
            self.tableDatas.append([
                "type": CellType.item,
                "data": item,
                "index": idx
            ])
        }
        
        if tableDatas.count > 0 {
            tableDatas.append(["type": CellType.empty])
        }
        return tableDatas.count
    }
    
    public func getPatientMedications(_ type: Int) {
        m_curTimeDuration = type
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let selectedDateString = dateFormatter.string(from: self.selectedDate)
        
        let preference = PreferenceHelper()
        let params = [
            "userid" : preference.getId(),
            "choice" : "5",
            "date": selectedDateString,
            "time": "\(type)"
            ] as [String : Any]
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        
        Alamofire.request(DataUtils.APIURL + DataUtils.MYDRUG_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                if let data = response.result.value {
                    let json = data as! [String: Any]
                    self.drugInfo = json["drug_info"] as! [[String: Any]]
                    self.asneededDrugs = json["asneeded"] as! [[String: Any]]
                    self.tableView.reloadData()
                }
            })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowIdx = indexPath.row
        
        let cellData = self.tableDatas[rowIdx]
        let type = cellData["type"] as! CellType
        switch type {
        case .time:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationTimeCell", for: indexPath) as? MedicationTimeCell
            cell?.time.text = cellData["data"] as? String
            return cell!
        case .asneeded:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationTimeCell", for: indexPath) as? MedicationTimeCell
            cell?.time.textColor = UIColor.init(hex: "333333")
            cell?.time.text = "As Needed"
            self.tableView.rowHeight = (cell?.frame.height)!
            return cell!
        case .taken:
            let data = cellData["data"] as? [String: Any]
            let drugId = Int(data?["id"] as! String)!
            let takenId = Int(data?["historyId"] as! String)!
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationTakenCell", for: indexPath) as? MedicationTakenCell
            cell?.setColor(m_currentColor)
            cell?.medicationname.text = data?["medicationname"] as? String
            cell?.medicationname.isUserInteractionEnabled = true
            
            let amount = getNumerialAmount(data?["amount"] as! String)
            
            cell?.content.text = "\(GlobalManager.capitalizeFirstLetters(amount)) - Taken at " + GetTakeTime(data?["taken_time"] as! String)

            cell?.checkbtn.removeTarget(nil, action: nil, for: .allEvents)
            cell?.checkbtn.tag = takenId
            cell?.checkbtn.addTarget(self, action: #selector(openConfirmUntakDialog(_:)), for: .touchUpInside)

//            let gesture = UITapGestureRecognizer(target: self, action:  #selector(untakeDrug(sender:)))
//            cell?.tag = takenId
//            cell?.addGestureRecognizer(gesture)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openDrugInfoDialog(sender: )))
            cell?.tag = drugId
            cell?.addGestureRecognizer(tapGesture)

            return cell!
        case .untaken:
            let data = cellData["data"] as? [String: Any]
            let drugId = Int(data?["id"] as! String)!
            let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationUntakenCell", for: indexPath) as? MedicationUntakenCell
            cell?.setColor(m_currentColor)

            let remainDays = GetRemainDays(data?["createat"] as! String)
            if remainDays > 7 {
                cell?.vwNotification.isHidden = true
            } else {
                cell?.vwNotification.isHidden = false
            }
            cell?.medicationname.text = data?["medicationname"] as? String
            cell?.medicationname.isUserInteractionEnabled = true
            cell?.backgroundview.tag = drugId
            
            // Detail dialog
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openDrugInfoDialog(sender: )))
            cell?.backgroundview.addGestureRecognizer(tapGesture)
//            let gesture = UITapGestureRecognizer(target: self, action:  #selector(getPrescriptionMedication(sender:)))
//            cell?.backgroundview.tag = drugId
//            cell?.backgroundview.addGestureRecognizer(gesture)

            cell?.checkbtn.removeTarget(nil, action: nil, for: .allEvents)

            let amount = getNumerialAmount(data?["amount"] as! String)
            
            cell?.content.text = GlobalManager.capitalizeFirstLetters("Take " + amount)
            cell?.checkbtn.tag = drugId
            cell?.checkbtn.addTarget(self, action: #selector(takeEatPress(_:)), for: .touchUpInside)

            cell?.remainDayLabel.text = "\(remainDays) days of medication left!"

            // add test modal dialog for notification
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(openTestNotificationDialog(sender:)))
            cell?.backgroundview.addGestureRecognizer(longPressGesture)
            
            

            return cell!
        case .item:
            let data = cellData["data"] as? [String: Any]
            let index = cellData["index"] as! Int
            let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationItemCell", for: indexPath) as? MedicationItemCell
            let amount = data?["amount"] as? String
            let frequency = data?["frequency"] as? String
            let gesture = UITapGestureRecognizer(target: self, action:  #selector(addNeededSelect(sender:)))
            
            cell?.setColor(m_currentColor)
            cell?.title.text = data?["medicationname"] as? String
            cell?.content.text = GlobalManager.capitalizeFirstLetters("Take \(amount!) \(frequency!)")
            cell?.checkbtn.tag = index
            cell?.checkbtn.addGestureRecognizer(gesture)
            
            return cell!
        case .takeall:
            let data = cellData["data"] as! String
            let cell = tableView.dequeueReusableCell(withIdentifier: "MadicationTakeAllCell", for: indexPath) as? MadicationTakeAllCell
            cell?.setTitle("Take All")
            cell?.setColor(m_currentColor)
            
            var index = 0
            for (i, item) in self.drugInfo.enumerated() {
                if item["timing"] as! String == data {
                    index = i
                }
            }
            cell?.takeall.tag = index
            let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.takeAllEatPress))
            cell?.takeall.addGestureRecognizer(gesture)
            
            return cell!
        case .take:
            let data = cellData["data"] as! String
            let cell = tableView.dequeueReusableCell(withIdentifier: "MadicationTakeAllCell", for: indexPath) as? MadicationTakeAllCell
            cell?.setColor(m_currentColor)
            cell?.setTitle("Take")
            
            var index = 0
            for (i, item) in self.drugInfo.enumerated() {
                if item["timing"] as! String == data {
                    index = i
                }
            }
            cell?.takeall.tag = index
            let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.takeAllEatPress))
            cell?.takeall.addGestureRecognizer(gesture)
            
            return cell!
        case .alltakenexpand:
            let data = cellData["data"] as! String
            let id = cellData["index"] as! Int
            let count = cellData["count"] as! Int
            let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationAllItemTakenExpandCell", for: indexPath) as? MedicationAllItemTakenExpandCell
            let gesture = UITapGestureRecognizer(target: self, action:  #selector(collapseItems(sender:)))
            
            cell?.setColor(m_currentColor)
            cell?.vwArrowDown.isUserInteractionEnabled = true
            cell?.tag = id
            cell?.addGestureRecognizer(gesture)
            cell?.content.text = "Taken at \(GetTakeTime(data))"
            cell?.medicationname.text = "All \(count) Medications"
            return cell!
        case .alltakencollapse:
            let data = cellData["data"] as! String
            let id = cellData["index"] as! Int
            let count = cellData["count"] as! Int
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationAllItemTakenCollapseCell", for: indexPath) as? MedicationAllItemTakenCollapseCell
            let gesture = UITapGestureRecognizer(target: self, action:  #selector(expandItems(sender:)))
            
            cell?.setColor(m_currentColor)
            cell?.vwArrowRight.isUserInteractionEnabled = true
            cell?.tag = id
            cell?.addGestureRecognizer(gesture)
            cell?.content.text = "Taken at \(GetTakeTime(data))"
            cell?.medicationname.text = "All \(count) Medications"
            return cell!
        case .addcell:
            break
        case .asneedRemember:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AsNeededRememberTableViewCell", for: indexPath) as? AsNeededRememberTableViewCell
            cell?.setColor(m_currentColor)
            cell?.content.text = "Remember to wait at least 4 hours before taking another dose."
            return cell!
        case .asneedHistory:
            let data = cellData["data"] as! [[String: Any]]
            let cell = tableView.dequeueReusableCell(withIdentifier: "AsNeededHistoryTableViewCell", for: indexPath) as! AsNeededHistoryTableViewCell
            
            cell.setColor(m_currentColor)
            cell.histories = data
            cell.commonInit()
            return cell
        case .divider:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationDividerCell") as! MedicationDividerCell
            return cell
        case .prevDay:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationPrevDayCell") as! MedicationPrevDayCell
            cell.message.text = "This day has already passed"
            return cell
        case .futureDay:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationPrevDayCell") as! MedicationPrevDayCell
            cell.message.text = "Hasn't come yet"
            return cell
        case .empty:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell", for: indexPath) as? EmptyTableViewCell
            return cell!
        }
        
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellData = self.tableDatas[indexPath.row] as [String: Any]
        let type = cellData["type"] as! CellType
        switch type {
        case .time:
            return 70
        case .asneeded:
            return 70
        case .taken:
            return 83
        case .untaken:
            let data = cellData["data"] as! [String: Any]
            let remainDays = GetRemainDays(data["createat"] as! String)
            
            if remainDays <= 7{
                return 130
            } else {
                return 90
            }
        case .item:
            return 84
        case .takeall:
            return 60
        case .take:
            return 50
        case .alltakenexpand:
            return 83
        case .alltakencollapse:
            return 100
        case .addcell:
            break
        case .asneedRemember:
            return 90
        case .asneedHistory:
            let data = cellData["data"] as! [[String: Any]]
            let height = CGFloat(100 + 30 * (data.count - 1))

            return height
        case .divider:
            return 30
        case .prevDay:
            break
        case .futureDay:
            break
        case .empty:
            return 70
        }

        return 70
    }
    
    @objc func getPrescriptionMedication(sender : UITapGestureRecognizer) {
        let drugId = sender.view!.tag
        let viewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "MedicationInfoMainViewController") as! MedicationInfoMainViewController
        viewController.delegate = self
        for tk in self.m_takenTimes {
            if drugId == Int(tk["drug_id"] as! String)
            {
                viewController.m_takenInfo = tk
                break
            }
        }
        
        for drug in self.patientmedications {
            if drugId == drug.id
            {
                viewController.m_drugInfo = drug
                viewController.m_drugInfo?.taketime = "Morning"
                break
            }
        }
        viewController.modalPresentationStyle = .overFullScreen

        present(viewController, animated: false, completion: nil)
    }
    

    func getDrugsByTakeTime(_ time:String) ->[MyMedication] {
        var ret = [MyMedication]()
        for item in patientmedications {
            if item.taketime == time {
                ret.append(item)
            }
        }
        return ret
    }
    
    @objc func takeAllEatPress(sender : UITapGestureRecognizer) {
        let idx = sender.view!.tag
        var processedCnt = 0
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm"
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        let currentDateTime = GlobalManager.GetToday()
        let time = formatter.string(from: currentDateTime)
        
        let preference = PreferenceHelper()
        let untaken_drugs = self.drugInfo[idx]["untake_drugs"] as! [[String: Any]]
        
        for drug in untaken_drugs {
            let params = [
                "user_id" : preference.getId(),
                "choice" : "9",
                "drug_id" : drug["id"] as! String,
                "date": time
                ] as [String : Any]
            Alamofire.request(DataUtils.APIURL + DataUtils.MYDRUG_URL, method: .post, parameters: params)
                .responseJSON(completionHandler: { response in
                    if let data = response.result.value {
                        let json : [String:Any] = data as! [String : Any]
                        let result = json["status"] as? String
                        if result == "true"
                        {
                            processedCnt += 1
                            if processedCnt == untaken_drugs.count {
                                self.getPatientMedications(self.m_curTimeDuration)
                            }
                        }
                        else
                        {
                            let message = json["message"] as! String
                            DataUtils.messageShow(view: self, message: message, title: "")
                        }
                    }
                })
        }
    }
    
    @objc private func takeEatPress(_ sender: UIButton?) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm"
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        let currentDateTime = GlobalManager.GetToday()
        let time = formatter.string(from: currentDateTime)
        let drug_id = sender!.tag
        
        let preference = PreferenceHelper()
        let params = [
            "user_id" : preference.getId(),
            "choice" : "9",
            "drug_id" : drug_id,
            "date": time
            ] as [String : Any]
        Alamofire.request(DataUtils.APIURL + DataUtils.MYDRUG_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                if let data = response.result.value {                    
                    let json : [String:Any] = data as! [String : Any]
                    let result = json["status"] as? String
                    if result == "true"
                    {
                        self.getPatientMedications(self.m_curTimeDuration)
                    }
                    else
                    {
                        let message = json["message"] as! String
                        DataUtils.messageShow(view: self, message: message, title: "")
                    }
                }
            })
    }
    
    @objc private func openConfirmUntakDialog(_ sender: UIButton?) {
        let takenId = sender?.tag
        
        let viewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "UntakeConfirmViewController") as! UntakeConfirmViewController
        viewController.takenId = takenId!
        viewController.delegate = self
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: false, completion: nil)
        
//        let viewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "MedicationInfoMainViewController") as! MedicationInfoMainViewController
//        for tk in self.m_takenTimes {
//            if drugId == Int(tk["drug_id"] as! String)
//            {
//                viewController.m_takenInfo = tk
//                break
//            }
//        }
//
//        for drug in self.patientmedications {
//            if drugId == drug.id
//            {
//                viewController.m_drugInfo = drug
//                viewController.m_drugInfo?.taketime = "Morning"
//                break
//            }
//        }
//        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    @objc func collapseItems( sender: UITapGestureRecognizer?) {
        let index = sender?.view?.tag
        let medicationTime = self.drugInfo[index!]["timing"] as! String
        
        m_DicAllItemTakenCollapsed[medicationTime] = true
        self.tableView.reloadData()
    }
    
    @objc func expandItems( sender: UITapGestureRecognizer?) {
        let index = sender?.view?.tag
        let medicationTime = self.drugInfo[index!]["timing"] as! String

        m_DicAllItemTakenCollapsed[medicationTime] = false
        self.tableView.reloadData()
    }
    
    @objc func addNeededSelect(sender : UITapGestureRecognizer) {
        let index = sender.view!.tag
        
        if asneededHistories.count > 0 {
            // Check before 4 hours
            let asneededHistories = asneededDrugs[index]["history"] as! [[String: Any]]
            let lastHistory = asneededHistories[asneededHistories.count - 1]
            let diffHour = (lastHistory["timediff"] as! String).components(separatedBy: ":")[0]
            
            if Int(diffHour)! < 4 {
                let viewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "AsNeedWarningViewController") as! AsNeedWarningViewController
                viewController.medicationname = asneededDrugs[index]["medicationname"] as! String
                viewController.index = index
                viewController.delegate = self
                viewController.modalPresentationStyle = .overCurrentContext
                present(viewController, animated: false, completion: nil)
            } else {
                openSelectPainDialog(index)
            }
        } else {
            openSelectPainDialog(index)
        }
    }
    
    func openSelectPainDialog(_ index: Int) {
        let viewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "SelectPainViewController") as! SelectPainViewController
        
        var medication = MyMedication()
        medication.medicationname = asneededDrugs[index]["medicationname"] as! String
        medication.strength = asneededDrugs[index]["strength"] as! String
        medication.directions = asneededDrugs[index]["directions"] as! String
        medication.createat = asneededDrugs[index]["createat"] as! String
        medication.taketime = self.taketime
        medication.id = Int(asneededDrugs[index]["id"] as! String)!
        
        viewController.mymedication = medication
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.delegate = self
        present(viewController, animated: false, completion: nil)
    }
    
    @objc func addNewMedication(sender : UITapGestureRecognizer) {
         let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddMedicationDialogViewController") as! AddMedicationDialogViewController
         present(viewController, animated: false, completion: nil)
    }
    
    func GetRemainDays(_ createat: String) -> Int{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dt = formatter.date(from: createat)
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: dt!, to: self.selectedDate)
        return 30 - (components.day ?? 0)
    }
    
    func GetTakeTime(_ time: String) -> String {
        let timePart = time.components(separatedBy: " ")[1]
        let hour = timePart.components(separatedBy: ":")[0]
        let min = timePart.components(separatedBy: ":")[1]
        
        if Int(hour) ?? 0 > 12 {
            return String(Int(hour) ?? 0 - 12) + ":" + min + "pm"
        } else {
            return hour + ":" + min + "am"
        }
    }
    
    @objc func openTestNotificationDialog(sender: UILongPressGestureRecognizer) {
        let viewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "NotificationTestDialogViewController") as! NotificationTestDialogViewController
        viewController.modalPresentationStyle = .overFullScreen
        
        let drugId = sender.view?.tag
        
        for drug in self.patientmedications {
            if drugId == drug.id
            {
                viewController.drugName = drug.medicationname
                break
            }
        }
        
        self.present(viewController, animated: false, completion: nil)
    }
    
    func setTableViewScrollTop() {
        self.tableView.scroll(to: .top, animated: true)
    }
    
    @objc func untakeDrug(sender: UITapGestureRecognizer) {
        let index = sender.view?.tag
        
        let params = [
            "taken_id" : index!,
            "choice" : "10"
            ] as [String : Any]
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        
        Alamofire.request(DataUtils.APIURL + DataUtils.MYDRUG_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                self.getPatientMedications(self.m_curTimeDuration)
            })
    }
    
    @objc func openDrugInfoDialog(sender: UITapGestureRecognizer) {
        let index = sender.view?.tag
        
        let viewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "MedicationInfoMainViewController") as! MedicationInfoMainViewController
        viewController.id = index
        viewController.modalPresentationStyle = .overFullScreen
        viewController.delegate = self
        
        self.present(viewController, animated: false, completion: nil)
    }
    
    private func getNumerialAmount(_ amount: String) -> String {
        var dose = amount.components(separatedBy: " ")[0]
        for (i, word) in numberWords.enumerated() {
            if dose == word {
                dose = "\(i + 1)"
            }
        }
        let type = amount.components(separatedBy: " ")[1]
        return dose + " " + type
    }
}

extension MorningViewController1 : IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: taketime)
    }
}

extension MorningViewController1 : AsNeedWarningDelegate {
    
    func accpetWarning(_ index: Int) {
        self.openSelectPainDialog(index)
    }
}

extension MorningViewController1 : DialogClose {
    func closeDialog() {
        getPatientMedications(m_curTimeDuration)
    }
    
    func closeDialog1() {
    }
    
}

extension MorningViewController1: MedicationInfoDelegate {
    func closeMedicationInfoDialog() {
        getPatientMedications(m_curTimeDuration)
    }
}

extension MorningViewController1: MorningVCDelegate {
    func updateDate(date: Date)  {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        print("year: \(components.year!), month: \(components.month!), day: \(components.day!)")
    }
}

extension MorningViewController1: UntakConfirmDelegate {
    func closeUntakeConfirmDialog() {
        getPatientMedications(m_curTimeDuration)
    }
}
