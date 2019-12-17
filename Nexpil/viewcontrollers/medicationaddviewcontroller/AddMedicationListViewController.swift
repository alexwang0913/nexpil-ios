//
//  AddMedicationListViewController.swift
//  Nexpil
//
//  Created by Admin on 5/8/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

import Alamofire
import UserNotifications

class AddMedicationListViewController: InformationCardEditViewController,UITableViewDataSource,UITableViewDelegate,ShadowDelegate2 {
    
    @IBOutlet weak var drugList: UITableView!
    var cellTypes : [ItemType] = []
    var datas:[MyMedication] = []
    
    @IBOutlet weak var nextBtn: NPButton!
    var visualEffectView1:VisualEffectView?
    @IBOutlet weak var m_fabadd: FAButton!
    @IBOutlet weak var addRemoveLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.showHide), name:NSNotification.Name(rawValue: "showHide"), object: nil)
        if cellTypes.count > 1
        {
            sendNotification()
        }
        self.drugList.separatorStyle = UITableViewCellSeparatorStyle.none
        self.drugList.allowsSelection = false
        self.drugList.alwaysBounceVertical = false
        self.drugList.tableFooterView = UIView()
        self.drugList.rowHeight = UITableViewAutomaticDimension
        self.drugList.estimatedRowHeight = 84
    }
    
    @objc func showHide()
    {
        m_fabadd.isHidden = false
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
    override func removeShadow(root: Bool) {
        if root{
                    if DataUtils.getSkipButton() == false
                    {
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let medicationController = storyBoard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
                        self.navigationController?.pushViewController(medicationController, animated: true)
                    }
                    else {
                        sendData()
                    }
        }else{
            DBManager.getObject().deleteTmpDrug()
            self.removeShadow1(root: true)
        }
    }
    func removeShadow1(root: Bool) {
        visualEffectView1?.removeFromSuperview()
        if root == true
        {
            visualEffectView1 = self.view.backgroundBlur(view: self.view)
            m_fabadd.buttonImage = UIImage.init(named: "icon_add_more_night")
            addRemoveLabel.textColor = UIColor.init(hex: "4939E3")
            addRemoveLabel.text = "Add More"
            if DataUtils.getSkipButton() == true
            {
                //nextBtn.setTitle("Done", for: .normal)
                nextBtn.setTitle("Done", for: .normal)
            }
            else {
                //nextBtn.setTitle("Next", for: .normal)
                nextBtn.setTitle("Next", for: .normal)
            }
            
            datas = DBManager.getObject().getMedications()
            
            getConfigureCells()
            
            self.drugList.reloadData()
        }
    }
    
    @objc func gotoBack1(sender : UITapGestureRecognizer) {
        if DataUtils.getPrescription() == 1
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.vitaminPageViewController?.pageControl.currentPage = appDelegate.vitaminPageViewController!.pageControl.currentPage - 1
            appDelegate.vitaminPageViewController?.gotoPage()
        }
        else
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.pageViewController?.pageControl.currentPage = appDelegate.pageViewController!.pageControl.currentPage - 1
            appDelegate.pageViewController?.gotoPage()
        }
    }
    
    @objc func gotoNext1(sender : UITapGestureRecognizer) {
        if DataUtils.getSkipButton() == false
        {
            if DataUtils.getPrescription() == 1
            {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.vitaminPageViewController?.pageControl.currentPage = appDelegate.vitaminPageViewController!.pageControl.currentPage + 1
                appDelegate.vitaminPageViewController?.gotoPage()
            }
            else
            {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.pageViewController?.pageControl.currentPage = appDelegate.pageViewController!.pageControl.currentPage + 1
                appDelegate.pageViewController?.gotoPage()
            }
        }
        else {
            sendData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        visualEffectView1 = self.view.backgroundBlur(view: self.view)
        m_fabadd.buttonImage = UIImage.init(named: "icon_add_more_night")
        addRemoveLabel.textColor = UIColor.init(hex: "4939E3")
        addRemoveLabel.text = "Add More"
        if DataUtils.getSkipButton() == true
        {
            //nextBtn.setTitle("Done", for: .normal)            
            nextBtn.setTitle("Done", for: .normal)
        }
        else {
            //nextBtn.setTitle("Next", for: .normal)
            nextBtn.setTitle("Next", for: .normal)
        }
        
        datas = DBManager.getObject().getMedications()
        getConfigureCells()
        self.drugList.reloadData()
    }
    
    func getConfigureCells() {
        
        //let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.addNewMedication))
        cellTypes.removeAll()
        for data in datas
        {
            if data.prescription == 0
            {
                let item = ItemType.init(celltype: .asneeded, medicationtimeIndex: 0, patientMedicationIndex: 0, labelName: "Prescription")
                cellTypes.append(item)
                break
            }
        }
        for (index,data) in datas.enumerated()
        {
            if data.prescription == 0
            {
                let item = ItemType.init(celltype: .untaken, medicationtimeIndex: index, patientMedicationIndex: 0, labelName: "Prescription")
                cellTypes.append(item)
            }
        }
        for data in datas
        {
            if data.prescription == 1
            {
                let item = ItemType.init(celltype: .asneeded, medicationtimeIndex: 0, patientMedicationIndex: 0, labelName: "Vitamins")
                cellTypes.append(item)
                break
            }
        }
        for (index,data) in datas.enumerated()
        {
            if data.prescription == 1
            {
                let item = ItemType.init(celltype: .untaken, medicationtimeIndex: index, patientMedicationIndex: 0, labelName: "Prescription")
                cellTypes.append(item)
            }
        }
    }
   
    @IBAction func gotoNext(_ sender: Any) {
        
        if DataUtils.getSkipButton() == false
        {
            if DataUtils.getPrescription() == 1
            {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.vitaminPageViewController?.pageControl.currentPage = appDelegate.vitaminPageViewController!.pageControl.currentPage + 1
                appDelegate.vitaminPageViewController?.gotoPage()
            }
            else
            {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.pageViewController?.pageControl.currentPage = appDelegate.pageViewController!.pageControl.currentPage + 1
                appDelegate.pageViewController?.gotoPage()
            }
        }
        else {
            sendData()
        }
    }
    
    @IBAction func gotoBack(_ sender: Any) {
        
        if DataUtils.getPrescription() == 1
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.vitaminPageViewController?.pageControl.currentPage = appDelegate.vitaminPageViewController!.pageControl.currentPage - 1
            appDelegate.vitaminPageViewController?.gotoPage()
        }
        else
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.pageViewController?.pageControl.currentPage = appDelegate.pageViewController!.pageControl.currentPage - 1
            appDelegate.pageViewController?.gotoPage()
        }
    }
    
    func convertToDictionary(datas:[MyMedication]) -> [[String : Any]] {
        var dics = [[String : Any]]()
        for data in datas
        {
            if data.asneeded == 1 {
                let dic: [String: Any] = ["direction":data.directions, "dose":data.dose, "quantity":data.quantity, "prescribe":data.prescribe, "taketime":data.taketime, "patientname":data.patientname, "pharmacy":data.pharmacy,"medicationname":data.medicationname,"strength":data.strength,"filed_date":data.filedDate,"warnings":data.warnings,"frequency":data.frequency,"lefttablet":data.lefttablet,"prescription":data.prescription,"createat":data.createat, "endat":data.endat, "amount": data.amount, "asneeded": 1]
                dics.append(dic)
            } else {
                let timings = data.taketime.components(separatedBy: ",") as [String]
                for time in timings {
                    let dic: [String: Any] = ["direction":data.directions, "dose":data.dose, "quantity":data.quantity, "prescribe":data.prescribe, "taketime":time.trimmingCharacters(in: .whitespaces), "patientname":data.patientname, "pharmacy":data.pharmacy,"medicationname":data.medicationname,"strength":data.strength,"filed_date":data.filedDate,"warnings":data.warnings,"frequency":data.frequency,"lefttablet":data.lefttablet,"prescription":data.prescription,"createat":data.createat, "endat":data.endat, "amount": data.amount]
                    dics.append(dic)
                }
            }
        }
        return dics
    }
 
    func sendData()
    {
        do {
            var datas:[MyMedication] = DBManager.getObject().getMedications()
            for i in 0..<datas.count {
                let endDate = Date().addingTimeInterval(TimeInterval(3600 * 24 * 7))
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd hh:mm"
                datas[i].endat = formatter.string(from: endDate)
            }

            let dicArray = convertToDictionary(datas:datas)
            let jsonData = try JSONSerialization.data(withJSONObject: dicArray, options: [])
            let JSONString = String(data: jsonData, encoding: String.Encoding.utf8)!

            print(JSONString)
            let params = [
                "userid" : PreferenceHelper().getId(),
                "datas" : JSONString,
                "choice" : 0
                ] as [String : Any]

            DataUtils.customActivityIndicatory(self.view,startAnimate: true)
            Alamofire.request(DataUtils.APIURL + DataUtils.MYDRUG_URL, method: .post, parameters: params)
                .responseJSON(completionHandler: { response in
                    
                    DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                    if let data = response.result.value {
                        
                        let json : [String:Any] = data as! [String : Any]
                        let result = json["status"] as? String
                        if result == "true"
                        {
                            DataUtils.setCameraStatus(name: true)
                            DBManager.getObject().deleteTmpDrug()
                            NotificationCenter.default.post(name: Notification.Name.Action.FinishAddDrug, object: [])
                            self.navigationController?.popToRootViewController(animated: false)
                        }
                        else
                        {
                            let message = json["message"] as! String
                            DataUtils.messageShow(view: self, message: message, title: "")
                        }
                    } else {
                        DataUtils.messageShow(view: self, message: response.error!.localizedDescription, title: "")
                    }
                })
        }
        catch {
        }
    }
    
    func addUserDrug(_ drug: MyMedication){
        var hasDrug = false
        for item in UserDrugs {
            if item.medicationname == drug.medicationname && drug.strength == item.strength && drug.directions == item.directions {
                hasDrug = true
                break
            }
        }
        if hasDrug == false {
            UserDrugs.append(drug)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cellTypes[indexPath.row].celltype == CellType.asneeded //label for adding medication time
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationAddLabelTableViewCell", for: indexPath) as? MedicationAddLabelTableViewCell
            //cell?.time.font = UIFont(name: "Montserrat-Medium", size: 30)!
            //cell?.time.textColor = UIColor.init(hex: "333333")
            cell?.backgroundColor = UIColor.init(hex: "f7f7fa")
            cell?.labelName.text = cellTypes[indexPath.row].labelName
            return cell!
        }
        else if cellTypes[indexPath.row].celltype == CellType.untaken //table view cells for medication times(prescription)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationAddItemTableViewCell", for: indexPath) as? MedicationAddItemTableViewCell
            let index = cellTypes[indexPath.row].medicationtimeIndex
            
//            cell?.name.setTitle(datas[index].medicationname, for: .normal)
            cell?.drugName.text = datas[index].medicationname
            cell?.amount.text = datas[index].amount
            cell?.checkimage.tag = indexPath.row
            cell?.checkimage.addTarget(self, action: #selector(removeMedication(_:)), for: .touchUpInside)
            if cellTypes[indexPath.row].patientMedicationIndex == 0
            {
                cell?.checkimage.setImage(UIImage(named: "Drkpurple_Take Medication"), for: .normal)
                cell?.drugName.textColor = UIColor(hex: "333333")
                cell?.amount.isHidden = false
//                cell?.itemView.backgroundColor = UIColor.init(hex: "ffffff")
//                cell?.itemView.viewShadow()
                
            }
            else {
                cell?.checkimage.setImage(UIImage(named: "check_white"), for: .normal)
                cell?.drugName.textColor = UIColor(hex: "E34939")
                cell?.amount.isHidden = true
//                cell?.itemView.backgroundColor = UIColor.init(hex: "E34939")
//                cell?.name.setTitleColor(UIColor.init(hex: "ffffff"), for: .normal)
            }
//            cell?.itemView.layer.cornerRadius = 15
//            cell?.itemView.addShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.16, x: 0, y: 3, blur: 6.0)
            return cell!
        }
        else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if cellTypes[indexPath.row].celltype == CellType.asneeded //label for adding medication time
//        {
//            return 65
//        }
//        else
//        {
//            return 64
//        }
//        return 84
        return UITableViewAutomaticDimension
    }
    
    @objc private func removeMedication(_ sender: UIButton?) {
        
        let index = sender!.tag
        cellTypes[index].patientMedicationIndex = cellTypes[index].patientMedicationIndex == 0 ? 1:0
        
        var deleted = false
        for i in 0 ..< cellTypes.count
        {
            if cellTypes[i].patientMedicationIndex == 1
            {
                m_fabadd.buttonImage = UIImage.init(named: "Closebutton")
                addRemoveLabel.textColor = UIColor.init(hex: "E34939")
                addRemoveLabel.text = "Remove Selected"
                deleted = true
                break
            }
        }
        if deleted == false
        {
            visualEffectView1 = self.view.backgroundBlur(view: self.view)
            m_fabadd.buttonImage = UIImage.init(named: "icon_add_more_night")
            addRemoveLabel.textColor = UIColor.init(hex: "4939E3")
            addRemoveLabel.text = "Add More"
        }
        self.drugList.reloadData()
        
    }
    
    @objc func removeMedications(sender : UITapGestureRecognizer) {
        for data in cellTypes
        {
            if data.patientMedicationIndex == 1
            {
                let _ = DBManager.getObject().deleteMedicationDrug1(name: datas[data.medicationtimeIndex].medicationname)
            }
        }
        datas = DBManager.getObject().getMedications()
        
        getConfigureCells()
        
        self.drugList.reloadData()
    }
    
    @objc func addNewMedication(sender : UITapGestureRecognizer) {
        self.view.addSubview(visualEffectView!)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddMedicationDialogViewController") as! AddMedicationDialogViewController
        viewController.modalPresentationStyle = .overCurrentContext
        //viewController.delegate = self
        present(viewController, animated: false, completion: nil)
        
    }
    
    @IBAction func addRemoveMedication(_ sender: Any) {
        if addRemoveLabel.text?.contains("Add") == true
        {
            self.navigationController?.popToRootViewController(animated: false)
        }
        else {
            m_fabadd.isHidden = true
            //visualEffectView1?.backgroundColor = UIColor.lightGray
            self.view.addSubview(visualEffectView1!)
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MedicationRemoveViewController") as! MedicationRemoveViewController
            viewController.modalPresentationStyle = .overCurrentContext
            viewController.cellTypes = cellTypes
            viewController.datas = datas
            viewController.delegate = self
            present(viewController, animated: false, completion: nil)
        }
    }
    
    @IBAction func nextDoneScreen(_ sender: Any) {
        if UserDefaults.standard.value(forKey: "id") != nil{
            sendData()
        } else {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let medicationController = storyBoard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            self.navigationController?.pushViewController(medicationController, animated: true)
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
