//
//  AtHomeViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/28.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import XLPagerTabStrip

protocol AtHomeViewControllerDelegate: class {
    func didTapButtonAtHomeViewController(dic: NSDictionary, index: NSInteger)
    func didTapButtonAtHomeViewControllerRefresh()
}

enum HealthTableTypes {
    case HomeLabel
    case LabsLabel
    case HomeModule
    case LabModule
    case Empty
}

class AtHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var delegate:AtHomeViewControllerDelegate?
    
    @IBOutlet weak var tableList: UITableView!
    @IBOutlet weak var lbl_pulldown: UILabel!
    
    let tabTitle = "At Home"
    
    var arrayList: NSMutableArray?
    var manager = DataManager()
    var cellTypes: [HealthTableTypes] = []
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayList = NSMutableArray.init()
        // Do any additional setup after loading the view.

        lbl_pulldown.isHidden = true
        self.getSelfData()
        self.initMainView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // init MainView
    func initMainView() {
        // table
        tableList.delegate = self
        tableList.dataSource = self
        tableList.separatorColor = UIColor.clear
        
        tableList.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryTableViewCell")
        tableList.register(UINib(nibName: "HealthEmptyTableViewCell", bundle: nil), forCellReuseIdentifier: "HealthEmptyTableViewCell")
        tableList.register(UINib(nibName: "HealthLabelTableViewCell", bundle: nil), forCellReuseIdentifier: "HealthLabelTableViewCell")
        
        tableList.addSubview(refreshControl)

    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.delegate?.didTapButtonAtHomeViewControllerRefresh()
        self.getSelfData()
        refreshControl.endRefreshing()
    }
    
    func getSelfData() {
        let bloodGlucose = getBloodGlocose()
        let bloodPressure = getBloodPressure()
        let oxygenLevel = getOxygenlevel()
        let steps = getSteps()
        let weight = getWeight()
        let mood = getMood()
        
        let hemoglobin = getHemoglobinAlc()
        let lipid = getLipidPanel()
        let inr = getINR()
        
        let dic0 = NSDictionary.init(objects: ["Blood Glucose", "Blood Glucose", bloodGlucose, "mg/dl", "icon_blood_glucose", "#333333"], forKeys: ["title" as NSString, "image" as NSString, "value" as NSString, "unit" as NSString, "icon" as NSString, "unit_color" as NSString])
        let dic1 = NSDictionary.init(objects: ["Blood Pressure", "Blood Pressure", bloodPressure, "", "icon_blood_pressure", "#333333"], forKeys: ["title" as NSString, "image" as NSString, "value" as NSString, "unit" as NSString, "icon" as NSString, "unit_color" as NSString])
        let dic2 = NSDictionary.init(objects: ["Oxygen Level", "Oxygen Level", oxygenLevel, "%", "", "#333333"], forKeys: ["title" as NSString, "image" as NSString, "value" as NSString, "unit" as NSString, "icon" as NSString, "unit_color" as NSString])
        let dic3 = NSDictionary.init(objects: ["Mood", "Mood", mood, "", "", "#333333"], forKeys: ["title" as NSString, "image" as NSString, "value" as NSString, "unit" as NSString, "icon" as NSString, "unit_color" as NSString])
        let dic4 = NSDictionary.init(objects: ["Steps", "Steps", steps, "", "", "#8495ED"], forKeys: ["title" as NSString, "image" as NSString, "value" as NSString, "unit" as NSString, "icon" as NSString, "unit_color" as NSString])
        let dic5 = NSDictionary.init(objects: ["Weight", "Weight", weight, "lbs", "", "#877CEC"], forKeys: ["title" as NSString, "image" as NSString, "value" as NSString, "unit" as NSString, "icon" as NSString, "unit_color" as NSString])
        
        let dic6 = NSDictionary.init(objects: ["Hemoglobin A1c", "Hemoglobin A1c", hemoglobin, "%"], forKeys: ["title" as NSString, "image" as NSString, "value" as NSString, "unit" as NSString])
        let dic7 = NSDictionary.init(objects: ["Lipid Panel", "Lipid Panel", lipid, "mg/dl"], forKeys: ["title" as NSString, "image" as NSString, "value" as NSString, "unit" as NSString])
        let dic8 = NSDictionary.init(objects: ["INR", "INR", inr, ""], forKeys: ["title" as NSString, "image" as NSString, "value" as NSString, "unit" as NSString])
        
        if let tmp = UserDefaults.standard.array(forKey: "selected_health"){
            if arrayList?.count == 0{
                lbl_pulldown.isHidden = false
                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
                    UIView.animate(withDuration: 0.5, animations: {
                        self.lbl_pulldown.alpha = 0;
                    })
                    timer.invalidate()
                }
            }
            arrayList?.removeAllObjects()
            
            var ary = tmp as! [Int]
            ary = ary.sorted()
            for i in ary {
                switch i {
                case 0: // blood glucose
                    arrayList?.add(dic0)
                    break
                case 1: // blood pressure
                    arrayList?.add(dic1)
                    break
                case 2: // mood
                    arrayList?.add(dic3)
                    break
                case 3: // weight
                    arrayList?.add(dic5)
                    break
                case 4: // oxygen level
                    arrayList?.add(dic2)
                    break
                case 5: // steps
//                    if steps != "" {
                    arrayList?.add(dic4)
//                    }
                    break
                case 6:
                    arrayList?.add(dic6)
                    break
                case 7:
                    arrayList?.add(dic7)
                    break
                case 8:
                    arrayList?.add(dic8)
                    break
                default:
                    break
                }
            }
        }
        else
        {
            arrayList?.removeAllObjects()
        }
        DispatchQueue.main.async {
            self.tableList.reloadData()
        }

    }

    // table view datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var moduleIds = UserDefaults.standard.array(forKey: "selected_health") as? [Int]
        moduleIds = moduleIds?.sorted()
        cellTypes.removeAll()
        if moduleIds == nil {
            return 0
        }
        for (idx, id) in moduleIds!.enumerated() {
            if idx == 0 {
                if id > 5 {
                    cellTypes.append(.LabsLabel)
                } else {
                    cellTypes.append(.HomeLabel)
                }
            }
            if id > 5 {
                if !cellTypes.contains(.LabsLabel) {
                    cellTypes.append(.LabsLabel)
                }
            }
            if id > 5 {
                cellTypes.append(.LabModule)
            } else {
                cellTypes.append(.HomeModule)
            }
        }
        cellTypes.append(.Empty)
        
        return cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = cellTypes[indexPath.row]
        if cellType == .HomeModule || cellType == .LabModule {
            return 110
        } else {
            return 60
        }
//        if indexPath.row == (arrayList?.count)! + 1 {
//            return 60
//        }
//        if indexPath.row == 0{
//            return 60
//        }
//        else{
//            return 110
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = cellTypes[indexPath.row]
        print(cellType)
        if cellType == .HomeLabel {
            let cell = tableList.dequeueReusableCell(withIdentifier: "HealthLabelTableViewCell", for: indexPath) as! HealthLabelTableViewCell
            cell.label.text = "At Home"
            return cell
        } else if cellType == .LabsLabel {
            let cell = tableList.dequeueReusableCell(withIdentifier: "HealthLabelTableViewCell", for: indexPath) as! HealthLabelTableViewCell
            cell.label.text = "Labs"
            return cell
        } else if cellType == .HomeModule {
            let cell = tableList.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
            cell.setInfo(array: arrayList!, index: indexPath.row - 1)
            return cell
        } else if cellType == .LabModule {
            let cell = tableList.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
            if cellTypes.contains(.HomeLabel) {
                cell.setInfo(array: arrayList!, index: indexPath.row - 2)
            } else {
                cell.setInfo(array: arrayList!, index: indexPath.row - 1)
            }
            return cell
        } else {
            let cell = tableList.dequeueReusableCell(withIdentifier: "HealthEmptyTableViewCell", for: indexPath) as! HealthEmptyTableViewCell
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        var tmp = UserDefaults.standard.array(forKey: "selected_health") as! [Int]
        tmp = tmp.sorted()
        let cellType = cellTypes[indexPath.row]
        if cellType == .LabModule && cellTypes.contains(.HomeLabel){
            let dicList = arrayList![indexPath.row - 2] as! NSDictionary
            self.delegate?.didTapButtonAtHomeViewController(dic: dicList, index: tmp[indexPath.row - 2])
        } else {
            let dicList = arrayList![indexPath.row - 1] as! NSDictionary
            self.delegate?.didTapButtonAtHomeViewController(dic: dicList, index: tmp[indexPath.row - 1])
        }
    }
}

extension AtHomeViewController : IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: tabTitle)
    }
}
