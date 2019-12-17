//
//  ProfileSettingModalView.swift
//  Nexpil
//
//  Created by JinYingZhe on 1/25/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Alamofire

protocol ProfileSettingModalViewDelegate {
    func popSettingViewDismissal()
    func popSettingViewSignBtnClick()
    func popSettingViewBtnsClick(name: String)
}

class ProfileSettingModalView: UIView {
    @IBOutlet weak var backUV: UIView!
    @IBOutlet weak var closeUB: UIButton!
    @IBOutlet weak var emailUB: UIButton!
    @IBOutlet weak var passwordUB: UIButton!
    @IBOutlet weak var resetHealth: UIButton!
    
    @IBOutlet weak var textOnUB: UIButton!
    @IBOutlet weak var emailOnUB: UIButton!
    @IBOutlet weak var snoozeUB: UIButton!
    @IBOutlet weak var noticationUB: NPButton!
    
    @IBOutlet weak var helpUB: UIButton!
    @IBOutlet weak var inviteUB: UIButton!
    @IBOutlet weak var rateUB: UIButton!
    @IBOutlet weak var feedbackUB: UIButton!
    
    @IBOutlet weak var termUB: UIButton!
    @IBOutlet weak var privacyUB: UIButton!
    @IBOutlet weak var disclaimerUB: UIButton!
    
    @IBOutlet weak var vw_scroll: UIScrollView!
    
    @IBOutlet weak var signOutUB: NPButton!
    @IBOutlet weak var snoozeLabel: UILabel!
    
    var delegate: ProfileSettingModalViewDelegate?
    var isText: Bool = true
    var isEmail: Bool = false
    
    var snooze = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //  Initialation code
        backUV.setPopItemViewStyle(radius: 30.0, title: .large)
        self.closeUB.setPopItemViewStyle(radius: 22.5)
        
        emailUB.setPopItemViewStyle()
        passwordUB.setPopItemViewStyle()
        resetHealth.setPopItemViewStyle()
        
       // emailOnUB.setPopItemViewStyle()
        snoozeUB.setPopItemViewStyle()
        
        helpUB.setPopItemViewStyle()
        inviteUB.setPopItemViewStyle()
        rateUB.setPopItemViewStyle()
        feedbackUB.setPopItemViewStyle()
        
        termUB.setPopItemViewStyle()
        privacyUB.setPopItemViewStyle()
        disclaimerUB.setPopItemViewStyle()
        
        //textOnUB.setPopItemViewStyle()
        vw_scroll.contentSize = CGSize(width: vw_scroll.frame.size.width, height: 1157)
        
        let params = [
            "userid": PreferenceHelper().getId(),
            "choice": 4
        ]
        Alamofire.request(DataUtils.APIURL + DataUtils.PATIENT_URL, method: .post, parameters: params).responseJSON {response in
            if let data = response.result.value {
                let json = data as! [String : Any]
                self.snooze = Int(json["snooze"] as! String)!
                self.snoozeLabel.text = "\(self.snooze) minutes"
            }
        }
    }
    
    @IBAction func onClickCloseUB(_ sender: Any) {
        self.delegate?.popSettingViewDismissal()
    }
    
    @IBAction func onClickVerifyUB(_ sender: Any) {
        self.delegate?.popSettingViewSignBtnClick()
    }

    @IBAction func OnResetHealth(){
        let alert = UIAlertController(title: "Confirm", message: "Removing the data will remove all heath data from the app and reset your health section to default. Are you sure you want to do this?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler:  { _ in
            alert.dismiss(animated: true, completion: nil)
            UserDefaults.standard.set(nil, forKey: "selected_health")
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }
    
    @IBAction func onClickTextFlagUB(_ sender: Any) {
        if isText {
            textOnUB.titleLabel?.text = "   Text    Off"
            textOnUB.backgroundColor = UIColor.white
            textOnUB.setTitleColor(UIColor(hex: "333333", alpha: 0.2), for: .normal)
        } else {
            textOnUB.titleLabel?.text = "   Text    On"
            textOnUB.backgroundColor = PColorScheme.blue.color
            textOnUB.setTitleColor(.white, for: .normal)
        }
        isText = !isText
    }
    
    @IBAction func onClickEmailFlagUB(_ sender: Any) {
        if isEmail {
            emailOnUB.titleLabel?.text = "   Email    Off"
            emailOnUB.backgroundColor = UIColor.white
            emailOnUB.setTitleColor(UIColor(hex: "333333", alpha: 0.2), for: .normal)
        } else {
            emailOnUB.titleLabel?.text = "   Email    On"
            emailOnUB.backgroundColor = PColorScheme.blue.color
            emailOnUB.setTitleColor(.white, for: .normal)
        }
        isEmail = !isEmail
    }
    
    @IBAction func onClickSettingUBs(_ sender: Any) {
        let btn = sender as! UIButton
        let title: String = (btn.titleLabel?.text)!
        self.delegate?.popSettingViewBtnsClick(name: title)
    }
}
