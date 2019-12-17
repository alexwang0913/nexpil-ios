//
//  AddManuallySecondViewController.swift
//  Nexpil
//
//  Created by mac on 9/3/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class BloodGlucoseAddManuallySecondViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var beforeView: UIView!
    @IBOutlet weak var afterView: UIView!
    @IBOutlet weak var beforeLabel: UILabel!
    @IBOutlet weak var afterLabel: UILabel!
    @IBOutlet weak var measurementLabel: UILabel!
    @IBOutlet weak var defaultCircle: UIImageView!
    @IBOutlet weak var breakfastView: UIView!
    @IBOutlet weak var breakfastLabel: UILabel!
    @IBOutlet weak var launchView: UIView!
    @IBOutlet weak var launchLabel: UILabel!
    @IBOutlet weak var dinnerView: UIView!
    @IBOutlet weak var dinnerLabel: UILabel!
    @IBOutlet weak var defaultCircle1: UIImageView!
    
    
    var measurement: String = ""
    var prevStr: String = "" {
        didSet {
            updateTimeLabel()
        }
    }
    var nextStr: String = "" {
        didSet {
            updateTimeLabel()
        }
    }
    
    var firstStepDelegate: AddManuallyViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        measurementLabel.text = "\(measurement) mg/dl"
        timeLabel.text = ""
        
        let uiviews = [beforeView, afterView, breakfastView, launchView, dinnerView]
        
        for uiview in uiviews {
            styleView(uiview!)
        }
        
        defaultCircle.layer.borderWidth = 2
        defaultCircle.layer.borderColor = UIColor.lightGray.cgColor
        defaultCircle.layer.cornerRadius = 15
        defaultCircle.backgroundColor = UIColor.white
        
        defaultCircle1.layer.borderWidth = 2
        defaultCircle1.layer.borderColor = UIColor.lightGray.cgColor
        defaultCircle1.layer.cornerRadius = 15
        defaultCircle1.backgroundColor = UIColor.white
        
        let beforeTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleBeforeViewTap(_:)))
        beforeView.addGestureRecognizer(beforeTapGesture)
        
        let afterTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleAfterViewTap(_:)))
        afterView.addGestureRecognizer(afterTapGesture)
        
        let breakfastTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleBreakfastViewTap(_:)))
        breakfastView.addGestureRecognizer(breakfastTapGesture)
        
        let launchTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleLanuchViewTap(_:)))
        launchView.addGestureRecognizer(launchTapGesture)
        
        let dinnerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleDinnerViewTap(_:)))
        dinnerView.addGestureRecognizer(dinnerTapGesture)
        
    }
    
    @IBAction func closeButtonClick(_ sender: Any) {
        presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func nextButtonClick(_ sender: Any) {
        let viewController = UIStoryboard(name: "Health", bundle: nil).instantiateViewController(withIdentifier: "BloodGlucoseAddManuallyThirdViewController") as! BloodGlucoseAddManuallyThirdViewController
        
        viewController.measurement = measurement
        viewController.time = timeLabel.text ?? ""
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: false, completion: nil)
    }
    
    @objc func handleBeforeViewTap(_ sender: UITapGestureRecognizer? = nil) {
        selectView(beforeView, beforeLabel)
        styleView(afterView)
        afterLabel.textColor = UIColor.black
        
        prevStr = "Before"
    }
    
    @objc func handleAfterViewTap(_ sender: UITapGestureRecognizer? = nil) {
        selectView(afterView, afterLabel)
        styleView(beforeView)
        beforeLabel.textColor = UIColor.black
        
        prevStr = "After"
    }
    
    private func updateTimeLabel() {
        timeLabel.text = prevStr + " " + nextStr
    }
    
    private func styleView(_ uiview: UIView) {
        uiview.backgroundColor = UIColor.white
        uiview.layer.shadowColor = UIColor.black.cgColor
        uiview.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        uiview.layer.shadowOpacity = 0.16
        uiview.layer.shadowRadius = 12.0
        uiview.layer.masksToBounds = false
        uiview.layer.cornerRadius = 30
    }
    
    private func selectView(_ view: UIView, _ label: UILabel) {
        view.backgroundColor = NPColorScheme.blue.color
        view.layer.shadowColor = UIColor.clear.cgColor
        label.textColor = UIColor.white
    }
 
    @objc func handleBreakfastViewTap(_ sender: UITapGestureRecognizer? = nil) {
        selectView(breakfastView, breakfastLabel)
        styleView(launchView)
        styleView(dinnerView)
        
        launchLabel.textColor = UIColor.black
        dinnerLabel.textColor = UIColor.black
        
        nextStr = "Breakfast"
    }
    
    @objc func handleLanuchViewTap(_ sender: UITapGestureRecognizer? = nil) {
        selectView(launchView, launchLabel)
        styleView(breakfastView)
        styleView(dinnerView)
        
        breakfastLabel.textColor = UIColor.black
        dinnerLabel.textColor = UIColor.black
        
        nextStr = "Lunch"
    }
    
    @objc func handleDinnerViewTap(_ sender: UITapGestureRecognizer? = nil) {
        selectView(dinnerView, dinnerLabel)
        styleView(breakfastView)
        styleView(launchView)
        
        breakfastLabel.textColor = UIColor.black
        launchLabel.textColor = UIColor.black
        
        nextStr = "Dinner"
    }
}
