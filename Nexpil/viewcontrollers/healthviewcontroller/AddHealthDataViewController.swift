//
//  AddHealthDataViewController.swift
//  Nexpil
//
//  Created by Ajai Nair on 4/9/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import HealthKitUI
import HealthKit

class AddHealthDataViewController: UIViewController {

    public var parentVc: HealthViewController!
    @IBOutlet var tbl_healthData: UITableView!
    var _healthData: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let item1 = ["name":"Blood Glucose", "img":"Group 3625"]
        let item2 = ["name":"Blood Pressure", "img":"Heart"]
        let item3 = ["name": "Mood", "img": "Happy"]
        let item4 = ["name":"Weight", "img":"Union 93"]
        let item5 = ["name":"Oxygen Level", "img":"Group 3177"]
        let item6 = ["name":"Steps", "img":"Group 3636"]
        let item7 = ["name":"Labs", "img":"Group 3177"]
//        let item7 = ["name":"Hemoglobin A1c", "img":"Group 3177"]
//        let item8 = ["name":"Lipid Panel", "img":"Group 3636"]
//        let item9 = ["name":"INR", "img":"Union 93"]
        
        let moduleIds = UserDefaults.standard.array(forKey: "selected_health") as? [Int] ?? []
        
        _healthData = NSMutableArray.init()
        _healthData.add(item1)
        _healthData.add(item2)
        _healthData.add(item3)
        _healthData.add(item4)
        _healthData.add(item5)
        if !moduleIds.contains(5) {
            _healthData.add(item6)
        }
        if !moduleIds.contains(6) {
            _healthData.add(item7)
        }
//        _healthData.add(item8)
//        _healthData.add(item9)
        Global_ShowFrostGlass(self.view)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Global_HideFrostGlass()
        parentVc.UpdateUI()
    }
    
    @IBAction func OnClose(){
        self.dismiss(animated: false, completion: nil)
    }
}

extension AddHealthDataViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _healthData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddHealthDataCell", for: indexPath) as? AddHealthDataCell
        let item:[String: String] = _healthData.object(at: indexPath.row) as! [String: String]
        cell?.name.text = item["name"]
        cell?.icon.image = UIImage(named: item["img"] ?? "")
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 74
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var ary:[Int]!
        let tmp = UserDefaults.standard.array(forKey: "selected_health")
        let item:[String: String] = _healthData.object(at: indexPath.row) as! [String: String]
        let name = item["name"]
        
        if let _ = tmp {
            ary = tmp as? [Int]
            if name == "Labs" {
                ary.append(6)
                ary.append(7)
                ary.append(8)
            } else if !ary.contains(indexPath.row){
                ary.append(indexPath.row)
            }
        }
        else{
            ary = [Int]()
            if name == "Labs" {
                ary.append(6)
                ary.append(7)
                ary.append(8)
            } else {
                ary.append(indexPath.row)
            }
        }
        UserDefaults.standard.set(ary, forKey: "selected_health")
        if indexPath.row == 2 {
            let pvc = self.presentingViewController
//            if ary.count == tmp?.count {
                self.dismiss(animated: false, completion: {
                    let moodVC = self.storyboard?.instantiateViewController(withIdentifier: "NewMoodAmdFirstViewController") as! NewMoodAmdFirstViewController
                    moodVC.modalPresentationStyle = .overFullScreen
                    pvc?.present(moodVC, animated: true, completion: nil)
                })
//            }
        }
            else if name == "Labs" {
//                types = Set([
//                    HKObjectType.clinicalType(forIdentifier: .labResultRecord)!
//                ])
                self.dismiss(animated: false, completion: nil)
            }
        else {
            
            
            var types = Set<HKSampleType>()
            switch indexPath.row {
            case 0:
                types = Set([(HKObjectType.quantityType(forIdentifier: .bloodGlucose)!)])
            case 1:
                types = Set([
                    (HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic)!),
                    (HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic)!)
                ])
            case 3:
                types = Set([(HKObjectType.quantityType(forIdentifier: .bodyMass)!)])
            case 4:
                types = Set([(HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!)])
            default:
                break
            }
            if name == "Steps" {
                types = Set([(HKObjectType.quantityType(forIdentifier: .stepCount)!)])
            }
            
            if HKHealthStore.isHealthDataAvailable() {
                let healthStore = HKHealthStore()
                healthStore.requestAuthorization(toShare: types, read: types) { (success, error) in
                    if success {
                        DispatchQueue.main.async {
                            let pvc = self.presentingViewController
//                            if ary.count == tmp?.count {
                                if indexPath.row == 0 {
                                    self.dismiss(animated: false, completion: {
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewBloodGlucoseAddManuallyViewController") as! NewBloodGlucoseAddManuallyViewController
                                        vc.modalPresentationStyle = .overFullScreen
                                        pvc?.present(vc, animated: false, completion: nil)
                                    })
                                } else if indexPath.row == 1 {
                                    self.dismiss(animated: false, completion: {
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewBloodPressureAddManuallyViewController") as! NewBloodPressureAddManuallyViewController
                                        vc.colorTheme = 1
                                        vc.modalPresentationStyle = .overFullScreen
                                        pvc?.present(vc, animated: true, completion: nil)
                                    })
                                    
                                } else if indexPath.row == 2 {
                                    self.dismiss(animated: false, completion: {
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewMoodAmdFirstViewController") as! NewMoodAmdFirstViewController
                                        vc.modalPresentationStyle = .overFullScreen
                                        pvc?.present(vc, animated: true, completion: nil)
                                    })
                                    
                                } else if indexPath.row == 3 {
                                    self.dismiss(animated: false, completion: {
                                        let healthDetails05ViewController = self.storyboard?.instantiateViewController(withIdentifier: "HealthDetails05ViewController") as! HealthDetails05ViewController
                                        healthDetails05ViewController.modalPresentationStyle = .overFullScreen
                                        pvc?.present(healthDetails05ViewController, animated: true, completion: nil)
                                    })
                                }
                                else if indexPath.row == 4 {
                                    self.dismiss(animated: false, completion: {
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewBloodPressureAddManuallyViewController") as! NewBloodPressureAddManuallyViewController
                                        vc.colorTheme = 2
                                        vc.modalPresentationStyle = .overFullScreen
                                        pvc?.present(vc, animated: true, completion: nil)
                                    })
                                }
                                else if indexPath.row == 5 {
                                    self.dismiss(animated: false, completion: nil)
                                }
                                else if indexPath.row == 6 {
                                    self.dismiss(animated: false, completion: nil)
                                }
//                            }
                        }
                    }
                }
            }
        }
    }
}
