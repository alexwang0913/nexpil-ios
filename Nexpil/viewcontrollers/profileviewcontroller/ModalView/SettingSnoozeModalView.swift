//
//  SettingSnoozeModalView.swift
//  Nexpil
//
//  Created by JinYingZhe on 1/30/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Alamofire

protocol SettingSnoozeModalViewDelegate {
    func popSettingSnoozeModalViewDismissal()
    func popSettingSnoozeAddView()
}

class SettingSnoozeModalView: UIView {
    @IBOutlet weak var backUV: UIView!
    @IBOutlet weak var backUB: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn10: UIButton!
    @IBOutlet weak var btn15: UIButton!
    @IBOutlet weak var btn20: UIButton!
    @IBOutlet weak var btn25: UIButton!
    @IBOutlet weak var btn30: UIButton!
    
    var delegate: SettingSnoozeModalViewDelegate?
    
    var snooze: Int? {
        didSet{
            let btnGroup = [btn5, btn10, btn15, btn20, btn25, btn30]
            for btn in btnGroup {
                if btn?.tag == self.snooze {
                    btn?.backgroundColor = UIColor(hex: "415cE3", alpha: 1.0)
                    btn?.setTitleColor(UIColor.white, for: .normal)
                }
            }
        }
    };
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //  Initialation code
        backUV.setPopItemViewStyle(radius: 30.0, title: .large)
        backUB.setPopItemViewStyle(radius: 22.5)
        
        btn5.setPopItemViewStyle()
        btn10.setPopItemViewStyle()
        btn20.setPopItemViewStyle()
        btn15.setPopItemViewStyle()
        btn25.setPopItemViewStyle()
        btn30.setPopItemViewStyle()
        
        initBtnUIs()
    }
    
    func initBtnUIs() {
        btn5.backgroundColor = UIColor.white
        btn10.backgroundColor = UIColor.white
        btn15.backgroundColor = UIColor.white
        btn20.backgroundColor = UIColor.white
        btn25.backgroundColor = UIColor.white
        btn30.backgroundColor = UIColor.white
        
        btn5.setTitleColor(UIColor(hex: "333333", alpha: 1.0), for: .normal)
        btn10.setTitleColor(UIColor(hex: "333333", alpha: 1.0), for: .normal)
        btn15.setTitleColor(UIColor(hex: "333333", alpha: 1.0), for: .normal)
        btn20.setTitleColor(UIColor(hex: "333333", alpha: 1.0), for: .normal)
        btn25.setTitleColor(UIColor(hex: "333333", alpha: 1.0), for: .normal)
        btn30.setTitleColor(UIColor(hex: "333333", alpha: 1.0), for: .normal)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBAction func onClickBackUB(_ sender: Any) {
        self.delegate?.popSettingSnoozeModalViewDismissal()
    }
    
    @IBAction func onClickAddUB(_ sender: Any) {
        let params = [
            "userid": PreferenceHelper().getId(),
            "snooze": self.snooze,
            "choice": 3
        ]
        Alamofire.request(DataUtils.APIURL + DataUtils.PATIENT_URL, method: .post, parameters: params).responseJSON { response in
            self.delegate?.popSettingSnoozeModalViewDismissal()
        }
    }
    
    @IBAction func onClickBtnUBs(_ sender: Any) {
        initBtnUIs()
        let selBtn: UIButton = sender as! UIButton
        selBtn.backgroundColor = UIColor(hex: "415CE3", alpha: 1.0)
        selBtn.setTitleColor(UIColor.white, for: .normal)
        self.snooze = selBtn.tag
    }

}
