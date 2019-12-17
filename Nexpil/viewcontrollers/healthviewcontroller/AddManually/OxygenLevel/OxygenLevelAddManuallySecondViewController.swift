//
//  OxygenLevelAddManuallySecondViewController.swift
//  Nexpil
//
//  Created by mac on 9/4/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class OxygenLevelAddManuallySecondViewController: UIViewController {

    @IBOutlet weak var currentCircle: UIImageView!
    @IBOutlet weak var defaultCircle: UIImageView!
    @IBOutlet weak var timeBackView: UIView!
    @IBOutlet weak var measurementLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeLabel1: UILabel!
    
    @IBOutlet weak var hour1Button: UIButton!
    @IBOutlet weak var hour2Button: UIButton!
    @IBOutlet weak var hour3Button: UIButton!
    @IBOutlet weak var hour4Button: UIButton!
    @IBOutlet weak var hour5Button: UIButton!
    @IBOutlet weak var hour6Button: UIButton!
    @IBOutlet weak var hour7Button: UIButton!
    @IBOutlet weak var hour8Button: UIButton!
    @IBOutlet weak var hour9Button: UIButton!
    @IBOutlet weak var hour10Button: UIButton!
    @IBOutlet weak var hour11Button: UIButton!
    @IBOutlet weak var hour12Button: UIButton!
    
    @IBOutlet weak var min00Button: UIButton!
    @IBOutlet weak var min05Button: UIButton!
    @IBOutlet weak var min10Button: UIButton!
    @IBOutlet weak var min15Button: UIButton!
    @IBOutlet weak var min20Button: UIButton!
    @IBOutlet weak var min25Button: UIButton!
    @IBOutlet weak var min30Button: UIButton!
    @IBOutlet weak var min35Button: UIButton!
    @IBOutlet weak var min40Button: UIButton!
    @IBOutlet weak var min45Button: UIButton!
    @IBOutlet weak var min55Button: UIButton!
    @IBOutlet weak var min50Button: UIButton!
    
    var measurement: String = ""
    
    private var hourButtons: [UIButton] = []
    private var minButtons: [UIButton] = []
    private var hourString: String = ""
    private var minuteString: String = "00"
    private var timeModeString: String = ""
    private let minLabels = ["00", "05", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentCircle.backgroundColor = UIColor.white
        currentCircle.layer.borderWidth = 2
        currentCircle.layer.borderColor = #colorLiteral(red: 0.2235294118, green: 0.8274509804, blue: 0.8901960784, alpha: 1)
        currentCircle.layer.cornerRadius = 15
        currentCircle.layer.masksToBounds = false
        
        defaultCircle.layer.borderWidth = 2
        defaultCircle.layer.borderColor = UIColor.lightGray.cgColor
        defaultCircle.layer.cornerRadius = 15
        defaultCircle.backgroundColor = UIColor.white
        
        timeBackView.layer.shadowColor = UIColor.black.cgColor
        timeBackView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        timeBackView.layer.shadowOpacity = 0.16
        timeBackView.layer.shadowRadius = 12.0
        timeBackView.layer.masksToBounds = false
        timeBackView.layer.cornerRadius = 20
        
        hourButtons = [hour1Button, hour2Button, hour3Button, hour4Button, hour5Button, hour6Button, hour7Button, hour8Button, hour9Button, hour10Button, hour11Button, hour12Button]
        
        measurementLabel.text = "\(measurement) %"
        
        minButtons = [min00Button, min05Button, min10Button, min15Button, min20Button, min25Button, min30Button, min35Button, min40Button, min45Button, min50Button, min55Button]
    }
    
    @IBAction func hourButtonClick(_ sender: UIButton) {
        let tag = sender.tag
        for i in 0..<12 {
            if i == tag {
                selectButtonStyle(hourButtons[tag])
            } else {
                defaultButtonStyle(hourButtons[i])
            }
        }
        hourString = "\(tag + 1)"
        updateTimeLabel()
    }
    
    @IBAction func minButtonClick(_ sender: Any) {
        let tag = (sender as! UIButton).tag
        for i in 0..<12 {
            if i == tag {
                selectButtonStyle(minButtons[tag])
            } else {
                defaultButtonStyle(minButtons[i])
            }
        }
        minuteString = minLabels[tag]
        updateTimeLabel()
    }
    
    
    private func selectButtonStyle(_ button: UIButton) {
        button.backgroundColor = NPColorScheme.aqua.color
        button.layer.borderWidth = 1
        button.layer.borderColor = NPColorScheme.aqua.color.cgColor
        button.layer.cornerRadius = 20
        button.setTitleColor(UIColor.white, for: .normal)
    }
    
    private func defaultButtonStyle(_ button: UIButton) {
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = UIColor.clear.cgColor
        button.setTitleColor(UIColor.black, for: .normal)
    }
    
    @IBAction func closeButtonClick(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func nextButtonClick(_ sender: Any) {
        let viewController = UIStoryboard(name: "Health", bundle: nil).instantiateViewController(withIdentifier: "OxygenLevelAddManuallyThirdViewController") as! OxygenLevelAddManuallyThirdViewController
        viewController.measurement = measurement
        viewController.time = timeLabel.text ?? ""
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: false, completion: nil)
    }
    
    private func updateTimeLabel() {
        timeLabel.text = hourString + ":" + minuteString + timeModeString
        timeLabel1.text = hourString + ":" + minuteString
    }
    
    @IBAction func amButtonClick(_ sender: Any) {
        timeModeString = "am"
        updateTimeLabel()
    }
    
    @IBAction func pmButtonClick(_ sender: Any) {
        timeModeString = "pm"
        updateTimeLabel()
    }
}
