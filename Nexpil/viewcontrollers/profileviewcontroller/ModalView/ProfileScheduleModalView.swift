//
//  ProfileScheduleModalView.swift
//  Nexpil
//
//  Created by Guang on 12/16/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Alamofire

class ProfileScheduleModalView: UIView,  TTRangeSliderDelegate{

    @IBOutlet weak var rangeSlider: TTRangeSlider!
    @IBOutlet weak var awakeTimeLabel: UILabel!
    @IBOutlet weak var awakeNoonLabel: UILabel!
    @IBOutlet weak var asleepTimeLabel: UILabel!
    @IBOutlet weak var asleepNoonLabel: UILabel!
    
    var delegate: ProfileScheduleDetailModalViewDelegate?
    var type = 0
    var data: NSDictionary? {
        didSet {
            let timeStart = Float(data!.value(forKey: "timeStart") as! String)!
            let timeEnd = Float(data!.value(forKey: "timeEnd") as! String)!
            rangeSlider.selectedMinimum = timeStart
            rangeSlider.selectedMaximum = timeEnd
            
            self.updateTimeLabel(timeStart, timeEnd)
        }
    }
    
    private var startTime = 0
    private var endTime = 0
    
    override func awakeFromNib() {
        rangeSlider.minHandleColor = UIColor(hex: "39D3E3")
        rangeSlider.maxHandleColor = UIColor(hex: "4939E3")
        rangeSlider.delegate = self
        
    }
    
    @IBAction func closeDialog(_ sender: Any) {
        self.delegate?.popScheduleDetailViewDismissal()
    }
    
    @IBAction func saveSchedule(_ sender: Any) {
        let params = [
            "userid": PreferenceHelper().getId(),
            "startTime": startTime,
            "endTime": endTime,
            "type": type,
            "choice": 0
        ]

        Alamofire.request(DataUtils.APIURL + DataUtils.PATIENT_URL, method: .post, parameters: params, encoding: URLEncoding()).responseString { response in
            self.delegate?.popScheduleDetailViewDismissal()
        }
    }
    
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        self.updateTimeLabel(selectedMinimum, selectedMaximum)
    }
    
    private func updateTimeLabel(_ selectedMinimum: Float, _ selectedMaximum: Float) {
        self.awakeTimeLabel.text = "\(selectedMinimum > 11 ? selectedMinimum == 12 ? 12 : Int(selectedMinimum - 12) : Int(selectedMinimum))";
        self.awakeNoonLabel.text = selectedMinimum > 11 ? "PM" : "AM"
        
        self.asleepTimeLabel.text = "\(selectedMaximum > 11 ? selectedMaximum == 12 ? 12 : Int(selectedMaximum - 12) : Int(selectedMaximum))";
        self.asleepNoonLabel.text = selectedMaximum > 11 ? selectedMaximum == 24 ? "AM" : "PM" : "AM"
        
        self.startTime = Int(selectedMinimum)
        self.endTime = Int(selectedMaximum)
    }
}
