//
//  EditTakeTimeViewController.swift
//  Nexpil
//
//  Created by Guang on 10/20/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Alamofire

class EditTakeTimeViewController: UIViewController {
    
    @IBOutlet var timeViews: [UIView]!
    @IBOutlet var timeLabels: [UILabel]!
    @IBOutlet var minView: [UIView]!
    @IBOutlet var minLabels: [UILabel]!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var amView: UIView!
    @IBOutlet weak var pmView: UIView!
    
    private var identifyNoon: String = "AM" {
        didSet {
            if self.identifyNoon == "AM" {
                amView.isHidden = false
                pmView.isHidden = true
            } else {
                amView.isHidden = true
                pmView.isHidden = false
            }
        }
    }
    private var hour: Int = 1
    private var min: Int = 0
    
    var takenId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<12 {
            timeViews[i].tag = i
            timeLabels[i].tag = i
            minView[i].tag = i
            minLabels[i].tag = i
        
            let hourTapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapHour))
            let minTapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapMin))
            timeViews[i].addGestureRecognizer(hourTapGesture)
            minView[i].addGestureRecognizer(minTapGesture)
        }
        
        initTimeLabel()
    }
    
    @IBAction func amButtonClick(_ sender: Any) {
        identifyNoon = "AM"
    }
    
    @IBAction func pmButtonClick(_ sender: Any) {
        identifyNoon = "PM"
    }
    
    @IBAction func closeButtonClick(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func doneButtonClick(_ sender: Any) {
        if identifyNoon == "PM" {
            self.hour += 12
        }
        let params = ["id": takenId, "choice": 14, "hour": self.hour, "min": self.min] as [String : Any]
        
        Alamofire.request(DataUtils.APIURL + DataUtils.MYDRUG_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                self.dismiss(animated: false, completion: nil)
        })
    }
    
    @objc func onTapHour(_ sender: UITapGestureRecognizer) {
        let index = sender.view?.tag ?? 0
        hour = index + 1
        updateTimeLabel()
        selectHour(index)
    }
    
    @objc func onTapMin(_ sender: UITapGestureRecognizer) {
        let index = sender.view?.tag ?? 0
        min = index * 5
        updateTimeLabel()
        selectMin(index)
    }
    
    private func updateTimeLabel() {
        timeLabel.text = "\(hour):\(min)"
    }
    
    private func initTimeLabel() {
        let params = ["id": takenId, "choice": "13"] as [String : Any]
        
        Alamofire.request(DataUtils.APIURL + DataUtils.MYDRUG_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                if let data = response.result.value {
                    let json = data as! [String: Any]
                    self.hour = Int(json["hour"] as! String)!
                    self.min = Int(json["min"] as! String)!
                    
                    if self.hour > 12 {
                        self.identifyNoon = "PM"
                        self.hour = self.hour - 12
                    } else {
                        self.identifyNoon = "AM"
                    }
                    
                    self.selectHour(self.hour - 1)
                    self.selectMin(Int(self.min/5))
                    
                    self.updateTimeLabel()
                }
            })
    }
    
    private func selectHour(_ index: Int) {
        for i in 0..<12 {
            timeViews![i].backgroundColor = UIColor.white
            timeLabels![i].textColor = UIColor.black
        }
        timeViews![index].backgroundColor = UIColor.init(hex: "39d3e3")
        timeViews![index].layer.cornerRadius = 15
        timeLabels![index].textColor = UIColor.white
    }
    
    private func selectMin(_ index: Int) {
        for i in 0..<12 {
            minView![i].backgroundColor = UIColor.white
            minLabels![i].textColor = UIColor.black
        }
        
        minView![index].backgroundColor = UIColor.init(hex: "39d3e3")
        minView![index].layer.cornerRadius = 15
        minLabels![index].textColor = UIColor.white
    }
}
