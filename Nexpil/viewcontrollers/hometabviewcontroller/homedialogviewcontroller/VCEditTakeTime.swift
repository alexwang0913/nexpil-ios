//
//  VCEditTakeTime.swift
//  Nexpil
//
//  Created by mac on 7/17/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Alamofire

class VCEditTakeTime: UIViewController {

    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var donebtn: UIButton!
    @IBOutlet weak var vwAM: UIView!
    @IBOutlet weak var vwPM: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var mymedication = MyMedication()
    
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
    
    public var vc_parent: MedicationInfoMainViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timeView.viewShadow()
        mainView.viewShadow()
        
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
        }// Do any additional setup after loading the view.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        
        let taketime = mymedication.createat.components(separatedBy: " ")[1]
        let hour = taketime.components(separatedBy: ":")[0]
        let min = taketime.components(separatedBy: ":")[1]
        
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
    }
    
    @IBAction func onChangeAMPM(_ btn: UIButton){
        selectedMorningnoon = btn.tag
        updateAMPM()
    }
    
    func setSelectedTimeLabel(){
//        if selectedMorningnoon == 0 {
//            lblSelectedHour.text = timeLabel.text! + "am"
//        } else { lblSelectedHour.text = timeLabel.text! + "pm" }
    }
    
    func timeInitialize(hour:String,min:String)
    {
        if Int(hour)! > 12
        {
            tvs![Int(hour)! - 1 - 12].backgroundColor = UIColor.init(hex: colorCode)
            tls![Int(hour)! - 1 - 12].textColor = UIColor.white
            selectedTime = Int(hour)! - 1 - 12
            selectedMorningnoon = 1
            updateAMPM()
        }
        else {
            tvs![Int(hour)! - 1].backgroundColor = UIColor.init(hex: colorCode)
            tls![Int(hour)! - 1].textColor = UIColor.white
            selectedTime = Int(hour)! - 1
            selectedMorningnoon = 0
            updateAMPM()
        }
        timeChange(tag: selectedTime)
        mvs![Int(min)!/5].backgroundColor = UIColor.init(hex: colorCode)
        mls![Int(min)!/5].textColor = UIColor.white
        selectedMinute = Int(min)!/5
        minuteChange(tag: selectedMinute)
        timeRange = DataUtils.getTimeRange(index: dayIndex)!
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
    
    @IBAction func onClose(){
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func onDone(){
        let updatedTime = mymedication.createat.components(separatedBy: " ")[0] + " " + timeLabel.text!
        let params = [
            "drug_id" : mymedication.id,
            "choice" : "11",
            "date" : updatedTime
            ] as [String : Any]
        Alamofire.request(DataUtils.APIURL + DataUtils.MYDRUG_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                if let data = response.result.value {
                    let json : [String:Any] = data as! [String : Any]
                    let result = json["status"] as? String
                    if result == "true"
                    {
                        self.dismiss(animated: false, completion: {
                            self.vc_parent.navigationController?.popViewController(animated: false)
                        })
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
