//
//  ProfileMedicationsViewController.swift
//  Nexpil
//
//  Created by Guang on 11/6/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Alamofire

class ProfileMedicationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MedicationInfoDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var medicationList: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableViewAutomaticDimension
        
        getMedicationList()
    }

    @IBAction func closeDialog(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func onClickAddMedications(_ sender: Any) { // Goto Add medications dialog
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddDrugNavigationVC") as! UINavigationController
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: false, completion: nil)
    }
    
    private func getMedicationList() {
        let userId = PreferenceHelper().getId()
         let params = [
             "userid": userId,
             "choice": "15"
             ] as [String : Any]
        
         Alamofire.request(DataUtils.APIURL + DataUtils.MYDRUG_URL, method: .post, parameters: params)
             .responseJSON(completionHandler: {response in
                 
             if let data = response.result.value {
                 let json = data as! [String: Any]
                self.medicationList = json["data"] as! [[String: Any]]
                self.tableView.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileMedicationsTableViewCell", for: indexPath) as? ProfileMedicationsTableViewCell
        cell?.medicationName.text = self.medicationList[indexPath.row]["medicationname"] as? String
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 64
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let drugInfo = self.medicationList[indexPath.row]
        let drugId = drugInfo["id"] as! String
        let viewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "MedicationInfoMainViewController") as! MedicationInfoMainViewController
        viewController.id = Int(drugId)
        viewController.delegate = self
        viewController.modalPresentationStyle = .overFullScreen
        
        self.present(viewController, animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        Global_ShowFrostGlass(self.view)
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame

        self.view.insertSubview(blurEffectView, at: 0)
    }

    override func viewWillDisappear(_ animated: Bool) {
//        Global_HideFrostGlass()
    }
    
    func closeMedicationInfoDialog() {
        self.dismiss(animated: false, completion: nil)
    }
}

class ProfileMedicationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var medicationName: UILabel!
    
}
