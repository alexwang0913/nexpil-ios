//
//  SelectTimeViewController.swift
//  Nexpil
//
//  Created by Admin on 4/19/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Alamofire

class SelectTimeViewController: UIViewController {

    @IBOutlet weak var medicationname: UILabel!
    @IBOutlet weak var strength: UILabel!
    @IBOutlet weak var timeView: UIView!
    
    @IBOutlet weak var donebtn: UIButton!
    
    var mymedication = MyMedication()
    
    var quantity = ""
    var painScore = ""
    var m_painScore = ""
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var imgGreenCircle: UIImageView!
    @IBOutlet weak var lblPainScore: UILabel!
    @IBOutlet weak var lblSelectedHour: UILabel!
    @IBOutlet weak var vwAM: UIView!
    @IBOutlet weak var vwPM: UIView!
    
    var delegate: DialogClose?
    
    @IBOutlet weak var tv1: UIView!
    @IBOutlet weak var tv2: UIView!
    @IBOutlet weak var tv3: UIView!
    @IBOutlet weak var tv4: UIView!
    @IBOutlet weak var tv5: UIView!
    @IBOutlet weak var tv6: UIView!
    @IBOutlet weak var tv7: UIView!
    @IBOutlet weak var tv8: UIView!
    @IBOutlet weak var tv9: UIView!
    @IBOutlet weak var tv10: UIView!
    @IBOutlet weak var tv11: UIView!
    @IBOutlet weak var tv12: UIView!
    
    @IBOutlet weak var tl1: UILabel!
    @IBOutlet weak var tl2: UILabel!
    @IBOutlet weak var tl3: UILabel!
    @IBOutlet weak var tl4: UILabel!
    @IBOutlet weak var tl5: UILabel!
    @IBOutlet weak var tl6: UILabel!
    @IBOutlet weak var tl7: UILabel!
    @IBOutlet weak var tl8: UILabel!
    @IBOutlet weak var tl9: UILabel!
    @IBOutlet weak var tl10: UILabel!
    @IBOutlet weak var tl11: UILabel!
    @IBOutlet weak var tl12: UILabel!
    
    @IBOutlet weak var mv1: UIView!
    @IBOutlet weak var mv2: UIView!
    @IBOutlet weak var mv3: UIView!
    @IBOutlet weak var mv4: UIView!
    @IBOutlet weak var mv5: UIView!
    @IBOutlet weak var mv6: UIView!
    @IBOutlet weak var mv7: UIView!
    @IBOutlet weak var mv8: UIView!
    @IBOutlet weak var mv9: UIView!
    @IBOutlet weak var mv10: UIView!
    @IBOutlet weak var mv11: UIView!
    @IBOutlet weak var mv12: UIView!
    
    @IBOutlet weak var ml1: UILabel!
    @IBOutlet weak var ml2: UILabel!
    @IBOutlet weak var ml3: UILabel!
    @IBOutlet weak var ml4: UILabel!
    @IBOutlet weak var ml5: UILabel!
    @IBOutlet weak var ml6: UILabel!
    @IBOutlet weak var ml7: UILabel!
    @IBOutlet weak var ml8: UILabel!
    @IBOutlet weak var ml9: UILabel!
    @IBOutlet weak var ml10: UILabel!
    @IBOutlet weak var ml11: UILabel!
    @IBOutlet weak var ml12: UILabel!
    
    var tvs:[UIView]?
    var tls:[UILabel]?
    var mvs:[UIView]?
    var mls:[UILabel]?
    
    var selectedTime = 8
    var selectedMinute = 0
    
    var selectedMorningnoon = 0
    
    var timeRange = ""
    var colorCode = ""
    var dayIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        donebtn.layer.cornerRadius = 20
        imgGreenCircle.layer.borderColor = UIColor.init(hexString: "#43D3E3")?.cgColor
        imgGreenCircle.layer.borderWidth = 2
        imgGreenCircle.layer.masksToBounds = false
        imgGreenCircle.layer.cornerRadius = 15
        lblPainScore.text = m_painScore
        
        // Do any additional setup after loading the view.
        timeView.viewShadow()
//        mainView.viewShadow()
        
        tvs = [tv1,tv2,tv3,tv4,tv5,tv6,tv7,tv8,tv9,tv10,tv11,tv12]
        tls = [tl1,tl2,tl3,tl4,tl5,tl6,tl7,tl8,tl9,tl10,tl11,tl12]
        mvs = [mv1,mv2,mv3,mv4,mv5,mv6,mv7,mv8,mv9,mv10,mv11,mv12]
        mls = [ml1,ml2,ml3,ml4,ml5,ml6,ml7,ml8,ml9,ml10,ml11,ml12]
        
        for index in 0 ..< tvs!.count
        {
            let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(timeSelect(sender:)))
            tvs![index].tag = index
            tvs![index].layer.cornerRadius = 16
            
            tvs![index].addGestureRecognizer(gesture2)
            
            let gesture3 = UITapGestureRecognizer(target: self, action:  #selector(minuteSelect(sender:)))
            mvs![index].tag = index
            mvs![index].layer.cornerRadius = 16
            mvs![index].addGestureRecognizer(gesture3)
        }
        
        Global_HideFrostGlass()
        Global_ShowFrostGlass(self.view)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Global_HideFrostGlass()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        medicationname.text = mymedication.medicationname + " - " + mymedication.strength
        strength.text = "(\(GlobalManager.capitalizeFirstLetters(mymedication.directions)))"
        
//        let taketime = mymedication.createat.components(separatedBy: " ")[1]
//        let taketime = GlobalManager.GetToday().components(separatedBy: " ")[1]
//        let hour = taketime.components(separatedBy: ":")[0]
//        let min = taketime.components(separatedBy: ":")[1]
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "GMT")!
        let today = GlobalManager.GetToday()
        let hour = calendar.component(.hour, from: today)
        let min = calendar.component(.minute, from: today)
        
        if mymedication.taketime == "Morning"
        {
            colorCode = "39d3e3"
            dayIndex = 0
        }
        if mymedication.taketime == "Midday"
        {
            colorCode = "397EE3"
            dayIndex = 1
        }
        if mymedication.taketime == "Evening"
        {
            colorCode = "415CE3"
            dayIndex = 2
        }
        if mymedication.taketime == "Night"
        {
            colorCode = "4939E3"
            dayIndex = 3
        }
        timeInitialize(hour: hour, min: min)
    }
    
    func updateAMPM(){
        if selectedMorningnoon == 0 {
            vwAM.isHidden = false
            vwPM.isHidden = true
        } else {
            vwAM.isHidden = true
            vwPM.isHidden = false
        }
        setSelectedTimeLabel()
    }
    
    @IBAction func onChangeAMPM(_ btn: UIButton){
        selectedMorningnoon = btn.tag
        updateAMPM()
    }
    
    func setSelectedTimeLabel(){
        if selectedMorningnoon == 0 {
            lblSelectedHour.text = timeLabel.text! + "am"
        } else { lblSelectedHour.text = timeLabel.text! + "pm" }
    }
    
    func timeInitialize(hour:Int,min:Int)
    {
        if hour > 12
        {
            tvs![hour - 1 - 12].backgroundColor = UIColor.init(hex: colorCode)
            tls![hour - 1 - 12].textColor = UIColor.white
            selectedTime = hour - 1 - 12
            selectedMorningnoon = 1
            updateAMPM()
        }
        else {
            tvs![hour ].backgroundColor = UIColor.init(hex: colorCode)
            tls![hour ].textColor = UIColor.white
            selectedTime = hour - 1
            selectedMorningnoon = 0
            updateAMPM()
        }
        timeChange(tag: selectedTime)
        mvs![min/5].backgroundColor = UIColor.init(hex: colorCode)
        mls![min/5].textColor = UIColor.white
        selectedMinute = min/5
        minuteChange(tag: selectedMinute)
        timeRange = DataUtils.getTimeRange(index: dayIndex)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func minuteChange(tag:Int)
    {
        for index in 0 ..< tvs!.count
        {
            mvs![index].backgroundColor = UIColor.white
            mls![index].textColor = UIColor.init(hex: "333333")
        }
        mvs![tag].backgroundColor = UIColor.init(hex: colorCode)
        
        mls![tag].textColor = UIColor.white
        selectedMinute = tag
        
        timeLabel.text = tls![selectedTime].text! + ":" + mls![selectedMinute].text!
        setSelectedTimeLabel()
    }
    
    func timeChange(tag:Int)
    {
        for index in 0 ..< tvs!.count
        {
            tvs![index].backgroundColor = UIColor.white
            tls![index].textColor = UIColor.init(hex: "333333")
        }
        
        tvs![tag].backgroundColor = UIColor.init(hex: colorCode)
        
        tls![tag].textColor = UIColor.white
        selectedTime = tag
        
        timeLabel.text = tls![selectedTime].text! + ":" + mls![selectedMinute].text!
        setSelectedTimeLabel()
    }
    
    @objc func timeSelect(sender : UITapGestureRecognizer) {
        let tag = sender.view!.tag
        print(tls![tag].text!)
        timeChange(tag: tag)
    }
    
    @objc func minuteSelect(sender : UITapGestureRecognizer) {
        let tag = sender.view!.tag
        print(mls![tag].text!)
        minuteChange(tag: tag)
    }
    
    @objc func addNeededSelect(sender : UITapGestureRecognizer) {
        dismiss(animated: false, completion: {
            self.delegate?.closeDialog()
            })
    }
    
    @objc func addNeededSelect1(sender : UITapGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func gotoCancel(_ sender: Any) {
        self.dismiss(animated: false, completion: {
            self.delegate?.closeDialog1()
        })
    }
    
    @IBAction func gotoDone(_ sender: Any) {
        
        let currentDateTime = GlobalManager.GetToday()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        
        
        let date = timeLabel.text!.components(separatedBy: ":")
        var hourSet = Int(date[0])!
        let minSet = Int(date[1])!
        
        if selectedMorningnoon == 1
        {
            hourSet += 12
        }
        
        var calendar = Calendar.current // or e.g. Calendar(identifier: .persian)
        calendar.timeZone = TimeZone(abbreviation: "GMT")!
        var hour = calendar.component(.hour, from: currentDateTime)
        var min = calendar.component(.minute, from: currentDateTime)
        
        let different = (hour - hourSet) * 3600 + (min - minSet) * 60
        let different1 = abs(different)
        hour = different1 / 3600
        min = (different1 % 3600) / 60
        var timeMsg = ""
        if different < 0
        {
            if hour > 0
            {
                timeMsg = "\(hour)h \(min) mins ago"
            }
            else{
                timeMsg = "\(min) mins ago"
            }
        }
        else {
            if hour > 0
            {
                timeMsg = "\(hour)h \(min) mins after"
            }
            else{
                timeMsg = "\(min) mins after"
            }
        }
        
        let takeDate: Date = calendar.date(bySettingHour: hourSet, minute: minSet, second: 0, of: currentDateTime) ?? Date()
        let takeDateFormatter = DateFormatter()
        takeDateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        takeDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        let takeDateString = takeDateFormatter.string(from: takeDate)
        print(takeDateString)
        
        let params: NSDictionary = [
            "choice": "9",
            "drug_id": mymedication.id,
            "user_id": PreferenceHelper().getId(),
            "date": takeDateString
        ]
        
        let url = DataUtils.APIURL + DataUtils.MYDRUG_URL
        Alamofire.request(url, method: .post, parameters: params as! Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            self.dismiss(animated: false, completion: {
                self.delegate?.closeDialog1()
            })
        }
    }
}
