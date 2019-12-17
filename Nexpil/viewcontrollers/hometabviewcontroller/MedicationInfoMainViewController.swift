//
//  MedicationInfoMainViewController.swift
//  Nexpil
//
//  Created by Yun Lai on 2018/12/5.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Alamofire

protocol MedicationInfoDelegate {
    func closeMedicationInfoDialog()
}

class MedicationInfoMainViewController: UIViewController {

    var id: Int?
    var m_drugInfo:MyMedication?
    var m_takenInfo: [String: Any]?
    
    var mMedicInfo: [String : String] = [String : String]()
    
    @IBOutlet weak var m_lbTakenMedication: UILabel!
    @IBOutlet weak var m_lbTakenMedicationContent: UILabel!
    
    @IBOutlet weak var m_lbInfo1: UILabel!
    @IBOutlet weak var lblPillsLeft: UILabel!
    @IBOutlet weak var vwCard: GradientView!
    @IBOutlet weak var vwNotification: UIView!
    @IBOutlet weak var btnTake: UIButton!
    @IBOutlet weak var m_prescription: UILabel!
    @IBOutlet weak var pharmacyView: GradientView!
    @IBOutlet weak var pharmacyDivider: UIView!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var closeButton: UIImageView!
    
    var delegate: MedicationInfoDelegate?
    var medicationName: String?
    var takeStatus: Bool?
    var takenId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let today = GlobalManager.GetToday()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let todayString = dateFormatter.string(from: today)
        
        let params = [
            "medicationId" : id!,
            "choice" : "7",
            "date": todayString
            ] as [String : Any]
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        
        Alamofire.request(DataUtils.APIURL + DataUtils.MYDRUG_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                if let data = response.result.value {
                    let json = data as! [String : Any]
                    let data = json["data"] as! [String: Any]
                    let amount = data["amount"] as! String
                    let count = GlobalManager.convertStringToNumber(amount.components(separatedBy: " ")[0])
                    let unit = amount.components(separatedBy: " ")[1]
                    let frequency = data["frequency"] as! String
                    
                    self.m_lbInfo1.text = "\(data["medicationname"] as! String) - \(data["strength"] as! String)"
//                    self.m_prescription.text = "\(data["directions"] as! String)"
                    self.m_prescription.text = "Take \(count) \(unit) \(frequency)"
                    self.lblPillsLeft.text = "\(data["quantity"] as! String) \(unit) Left"
                    self.medicationName = data["medicationname"] as? String
                    self.takenId = data["takenId"] as? String
                    
                    
                    let taken_time = data["taken_time"] as? String ?? ""
                    if taken_time == "" {
                        self.vwNotification.isHidden = true
                        self.takeStatus = false
                        self.btnTake.setTitle("Take", for: .normal)
                    } else {
                        self.m_lbTakenMedication.text = "\(data["medicationname"] as! String)"
                        self.m_lbTakenMedicationContent.text = "\(data["amount"] as! String) Taken at \(self.GetTakeTime(data["taken_time"] as! String))"
                        self.takeStatus = true
                        self.btnTake.setTitle("Untake", for: .normal)
                    }
                    
                    let pharmacy = data["pharmacy"] as? String ?? ""
                    if pharmacy == "" {
                        self.pharmacyView.isHidden = true
                        self.pharmacyDivider.isHidden = true
                        self.containerHeight.constant = 450
                    } else {
                        self.pharmacyView.isHidden = false
                        self.pharmacyDivider.isHidden = false
                        self.containerHeight.constant = 650
                    }
                }
            })
        closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeDialog)))
//        if m_takenInfo == nil {
//            vwCard.frame.origin = CGPoint(x: vwCard.frame.origin.x, y: (self.view.frame.size.height - vwCard.frame.size.height) / 2)
//            btnClose.frame.origin = CGPoint(x: btnClose.frame.origin.x, y: vwCard.frame.origin.y - 23)
//            vwNotification.isHidden = true
//        } else {
//            vwCard.frame.origin = CGPoint(x: vwCard.frame.origin.x, y: 135)
//            btnClose.frame.origin = CGPoint(x: btnClose.frame.origin.x, y: 112)
//            btnTake.setTitle("Untake", for: .normal)
//            m_lbTakenMedicationContent.text = "1 Tablet Taken at " + GetTakeTime(m_takenInfo!["taken_time"] as! String)
//        }
//
//        m_lbTakenMedication.text = m_drugInfo?.medicationname
//        m_lbInfo1.text = String.init(format: "%@ - 5mg", m_drugInfo!.medicationname as! String)
//        lblPillsLeft.text = "\(m_drugInfo!.quantity) pills left"
//        initMedicInfo()
//        switchDetailInfo(bDetail: false)
//        m_prescription.text = GlobalManager.capitalizeFirstLetters(m_drugInfo?.directions ?? "")
    }
    
    @objc func closeDialog() {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Global_ShowFrostGlass(self.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Global_HideFrostGlass()
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
    
    func switchDetailInfo(bDetail: Bool) {
        
//        m_vstkDrugInfo.isHidden = bDetail
//        m_vwDrugInfo.isHidden = !bDetail
    }
    
    func initMedicInfo() {
        getMedicationInfo()
    }
    
    func getMedicationInfo()
    {
        let path = "https://api.fda.gov/drug/label.json?search=\(m_drugInfo!.medicationname)"
        let url = URL(string: path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!) {  (data, response, error) in
            
            guard error == nil else { return }
            guard data != nil else { return }
            
            
            let decoder = JSONDecoder()
            let results = try! decoder.decode(Results.self, from: data!)
            
            if let result = results.results {
                
                DispatchQueue.main.async {
                    //self.textView.text = result[0].indications_and_usage?.joined(separator: "\n")
                    var what = result[0].description?[0] ?? ""
                    if what == ""
                    {
                        what = result[0].purpose?[0] ?? ""
                    }
                    
//                    self.mMedicInfo[self.m_titleArray[0] as! String] = what
//                    self.mMedicInfo[self.m_titleArray[1] as! String] = result[0].dosage_and_administration?[0] ?? ""
//                    self.mMedicInfo[self.m_titleArray[2] as! String] = result[0].indications_and_usage?[0] ?? ""
//
//                    self.m_lbActive.text = self.m_titleArray[0]
//                    self.m_tvActive.text = what
                }
            }
            
        }
        task.resume()
    }
    
    //Actions
    

    @IBAction func tapFABClose(_ sender: Any) {
//        if let isPresented = UserDefaults.standard.value(forKey: "presented") as? String{
//            if isPresented == "true"{
//                self.dismiss(animated: false, completion: nil)
//                UserDefaults.standard.set("false", forKey: "presented")
//            }
//            else{
//                self.navigationController?.popViewController(animated: false)
//            }
//            return
//        }
//        self.navigationController?.popViewController(animated: false)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func onTake(){
        if !takeStatus! {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd hh:mm"
            formatter.timeZone = TimeZone(abbreviation: "GMT")
            let currentDateTime = GlobalManager.GetToday()
            let time = formatter.string(from: currentDateTime)
            let drug_id = self.id
            
            let preference = PreferenceHelper()
            let params = [
                "user_id" : preference.getId(),
                "choice" : "9",
                "drug_id" : drug_id!,
                "date": time
                ] as [String : Any]
            Alamofire.request(DataUtils.APIURL + DataUtils.MYDRUG_URL, method: .post, parameters: params)
                .responseJSON(completionHandler: { response in
                    if let data = response.result.value {
                        let json : [String:Any] = data as! [String : Any]
                        let result = json["status"] as? String
                        if result == "true"
                        {
                            self.dismiss(animated: false, completion: {
                                self.delegate?.closeMedicationInfoDialog()
                            })
                        }
                        else
                        {
                            let message = json["message"] as! String
                            DataUtils.messageShow(view: self, message: message, title: "")
                            self.dismiss(animated: false, completion: nil)
                        }
                    }
                })
        } else {
            let params = [
                "taken_id" : self.takenId!,
                "drug_id" : self.id!,
                "choice" : "10"
                ] as [String : Any]
            Alamofire.request(DataUtils.APIURL + DataUtils.MYDRUG_URL, method: .post, parameters: params)
                .responseJSON(completionHandler: { response in
                    if let data = response.result.value {
                        let json : [String:Any] = data as! [String : Any]
                        let result = json["status"] as? String
                        if result == "true"
                        {
                            self.dismiss(animated: false, completion: {
                                self.delegate?.closeMedicationInfoDialog()
                            })
                        }
                        else
                        {
                            let message = json["message"] as! String
                            DataUtils.messageShow(view: self, message: message, title: "")
                            self.dismiss(animated: false, completion: nil)
                        }
                    }
                })
        }
    }
    
    @IBAction func onRemove(){
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VCRemoveDrugConfirm") as! VCRemoveDrugConfirm        
        viewController.delegate = self
        viewController.m_drugName = medicationName
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: false, completion: nil)
    }
    
    public func UntakeDrug(){
        
    }
    
    public func onEditTime(){
        let viewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "VCEditTakeTime") as! VCEditTakeTime
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.mymedication = m_drugInfo!
        viewController.vc_parent = self
        present(viewController, animated: false, completion: nil)
    }
}

extension MedicationInfoMainViewController: ShadowDelegate1 {
    func removeShadow(root: Bool)
    {
        if root == true {
            let params = [
                "choice" : "16",
                "userid": PreferenceHelper().getId(),
                "drugname": medicationName!
                ] as [String : Any]
            DataUtils.customActivityIndicatory(self.view,startAnimate: true)
            Alamofire.request(DataUtils.APIURL + DataUtils.MYDRUG_URL, method: .post, parameters: params)
                .responseJSON(completionHandler: { response in
                    
                    DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                    if let data = response.result.value {
                        let json : [String:Any] = data as! [String : Any]
                        let _ = json["status"] as? String
//                        if result == "true"
//                        {
//                            DBManager.getObject().deleteMedicationDrug(id: self.id!)
//                        }
//                        else
//                        {
//                            let message = json["message"] as! String
//                            DataUtils.messageShow(view: self, message: message, title: "")
//                        }
                    } else {
                        DataUtils.messageShow(view: self, message: response.error!.localizedDescription, title: "")
                    }
                    self.dismiss(animated: false, completion: {
                        self.delegate?.closeMedicationInfoDialog()
                    })
                    
                })
            
        }
    }
}
