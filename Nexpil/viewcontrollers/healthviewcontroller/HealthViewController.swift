//
//  HealthViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/28.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import SVProgressHUD
import XLPagerTabStrip

class HealthViewController: UIViewController,
    AtHomeViewControllerDelegate,
    UITabBarControllerDelegate
{

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var bgPageView: UIView!
    
    @IBOutlet weak var m_vwRadialRight: UIView!
    @IBOutlet weak var m_vwRadialLeft: UIView!
    @IBOutlet weak var containerView: UIScrollView!
    @IBOutlet weak var vw_intro: GradientView!
    @IBOutlet weak var addButton: FAButton!
    
    @IBOutlet weak var img_defaultOverlay: UIImageView!
    var blurEffectView: UIVisualEffectView!
    
    var oldCell:ButtonBarViewCell?
    var newCell:ButtonBarViewCell?
    
    var navIVArray: [UIImageView] = []
    var topNavActiveArray: [String] = []
    var topNavDeactiveArray: [String] = []
    
    var pageMenu:CAPSPageMenu?
    var vc_heathData: AtHomeViewController = AtHomeViewController()
    var currentPage = NSInteger()
    var arrayAtHome = NSMutableArray()
    var arrayLabs = NSMutableArray()
    public var manager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.backgroundColor = UIColor.white//init(hexString: "#F7F7F7")
 
        self.tabBarController?.delegate = self

        vc_heathData = AtHomeViewController(nibName: "AtHomeViewController", bundle: nil)
        vc_heathData.delegate = self
        addChildViewController(vc_heathData)
        vc_heathData.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        containerView.addSubview(vc_heathData.view)
        vc_heathData.didMove(toParentViewController: self)
        vc_heathData.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height)
        
//        if !UserDefaults.standard.bool(forKey: "health_default")
//        {
//            img_defaultOverlay.isHidden = false
//            
//            let nib = UINib(nibName: "VwHealthDefault", bundle: nil)
//            let vw = nib.instantiate(withOwner: self, options: nil)[0] as! VwHealthDefault
//            vw.frame = self.view.frame
//            vw.parentVc = self
//            self.view.addSubview(vw)
//        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onClickAddButton))
        addButton.addGestureRecognizer(gesture)
        addButton.isUserInteractionEnabled = true
        
        getNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.UpdateUI()
    }
    
    public func HideDefaultOverlay(){
        img_defaultOverlay.isHidden = true        
        self.UpdateUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        m_vwRadialLeft.layer.cornerRadius = m_vwRadialLeft.frame.width / 2
        m_vwRadialRight.layer.cornerRadius = m_vwRadialRight.frame.width / 2
        
    }

    // init MainView
    func initMainView() {
        lblTitle.font = UIFont.init(name: "Montserrat-Bold", size: 40)
        
    }

    func getNotifications() {
        let notificationKey1 = "sendSteps"
        NotificationCenter.default.addObserver(self, selector: #selector(catchNotification1(notification:)), name: NSNotification.Name(rawValue: notificationKey1), object: nil)
        
        let notificationKey5 = "sendStepsHour"
        NotificationCenter.default.addObserver(self, selector: #selector(catchNotification5(notification:)), name: NSNotification.Name(rawValue: notificationKey5), object: nil)

        let notificationKey2 = "sendBloodPressure"
        NotificationCenter.default.addObserver(self, selector: #selector(catchNotification2(notification:)), name: NSNotification.Name(rawValue: notificationKey2), object: nil)

        let notificationKey3 = "sendBloodGlucose"
        NotificationCenter.default.addObserver(self, selector: #selector(catchNotification3(notification:)), name: NSNotification.Name(rawValue: notificationKey3), object: nil)

        let notificationKey4 = "sendOxygenLevel"
        NotificationCenter.default.addObserver(self, selector: #selector(catchNotification4(notification:)), name: NSNotification.Name(rawValue: notificationKey4), object: nil)

    }
    
    @objc func catchNotification1(notification:Foundation.Notification) {
        let steps = notification.userInfo!["steps"] as! Double
        
        self.insertSteps(date: Date(), value: steps)
    }
    
    @objc func catchNotification5(notification:Foundation.Notification) {
        let steps = notification.userInfo!["steps"] as! Int64
        let hour = notification.userInfo!["hour"] as! NSInteger
        
        self.insertStepsHour(date: Date(), value: steps, hour: hour)
    }
    
    @objc func catchNotification2(notification:Foundation.Notification) {
        let bloodPressure1 = notification.userInfo!["bloodPressure1"] as! Double
        let bloodPressure2 = notification.userInfo!["bloodPressure2"] as! Double
        
        self.insertBloodPressure(date: GlobalManager.GetToday(), value1: bloodPressure1, value2: bloodPressure2)
    }
    
    @objc func catchNotification3(notification:Foundation.Notification) {
        let value = notification.userInfo!["bloodGlucose"] as! NSInteger
        let whenIndex = notification.userInfo!["whenIndex"] as! String
        
        self.insertBloodGlucose(date: Date(), value: value, whenIndex: whenIndex)
    }
    
    @objc func catchNotification4(notification:Foundation.Notification) {
        let value = notification.userInfo!["oxygenLevel"] as! NSInteger
        let time = "8:00am"
        let timeIndex = "0"
        
        self.insertOxygenLevel(date: Date(), value: value, time: time, timeIndex: timeIndex)
    }
    
    // MARK - AtHomeViewController delegate
    func didTapButtonAtHomeViewController(dic: NSDictionary, index: NSInteger) {

        sleep(UInt32(0.5))
        
        if index == 0 { // blood glucose
            let healthDetails00ViewController = self.storyboard?.instantiateViewController(withIdentifier: "HealthDetails00ViewController") as! HealthDetails00ViewController
            healthDetails00ViewController.modalPresentationStyle = .overFullScreen
            self.present(healthDetails00ViewController, animated: false, completion: nil)
            
        } else if index == 1 { // blood pressure
            let healthDetails01ViewController = self.storyboard?.instantiateViewController(withIdentifier: "HealthDetails01ViewController") as! HealthDetails01ViewController
            healthDetails01ViewController.modalPresentationStyle = .overFullScreen
            self.present(healthDetails01ViewController, animated: true, completion: nil)
            
        } else if index == 2 { // mood
            let moodVC = self.storyboard?.instantiateViewController(withIdentifier: "NewMoodViewController") as! NewMoodViewController
            moodVC.modalPresentationStyle = .overFullScreen
            self.present(moodVC, animated: true, completion: nil)
        } else if index == 3 { // weight
            let healthDetails05ViewController = self.storyboard?.instantiateViewController(withIdentifier: "HealthDetails05ViewController") as! HealthDetails05ViewController
            healthDetails05ViewController.modalPresentationStyle = .overFullScreen
            self.present(healthDetails05ViewController, animated: true, completion: nil)
        }
        else if index == 4 { // oxygen level
            let healthDetails02ViewController = self.storyboard?.instantiateViewController(withIdentifier: "HealthDetails02ViewController") as! HealthDetails02ViewController
            healthDetails02ViewController.modalPresentationStyle = .overFullScreen
            self.present(healthDetails02ViewController, animated: true, completion: nil)
        } else if index == 5 { // steps
            let healthDetails04ViewController = self.storyboard?.instantiateViewController(withIdentifier: "HealthDetails04ViewController") as! HealthDetails04ViewController
            healthDetails04ViewController.modalPresentationStyle = .overFullScreen
            self.present(healthDetails04ViewController, animated: true, completion: nil)
        }
        else if index == 6 {
            let healthDetails10ViewController = self.storyboard?.instantiateViewController(withIdentifier: "HealthDetails10ViewController") as! HealthDetails10ViewController
            healthDetails10ViewController.modalPresentationStyle = .overFullScreen
            self.present(healthDetails10ViewController, animated: true, completion: nil)
        } else if index == 7 {
            let healthDetails11ViewController = self.storyboard?.instantiateViewController(withIdentifier: "HealthDetails11ViewController") as! HealthDetails11ViewController
            healthDetails11ViewController.modalPresentationStyle = .overFullScreen
            self.present(healthDetails11ViewController, animated: true, completion: nil)
            
        } else if index == 8 {
            let healthDetails12ViewController = self.storyboard?.instantiateViewController(withIdentifier: "HealthDetails12ViewController") as! HealthDetails12ViewController
            healthDetails12ViewController.modalPresentationStyle = .overFullScreen
            self.present(healthDetails12ViewController, animated: true, completion: nil)
        }
    }
    
    func didTapButtonAtHomeViewControllerRefresh() {
        // update
        manager.updateHealthInfo()
    }
    
    // MARK - LabViewController Delegate
    func didTapButtonLabsViewController(dic: NSDictionary, index: NSInteger) {
        
        sleep(UInt32(0.5))

        if index == 0 {
            let healthDetails10ViewController = self.storyboard?.instantiateViewController(withIdentifier: "HealthDetails10ViewController") as! HealthDetails10ViewController
            self.present(healthDetails10ViewController, animated: true, completion: nil)
            
        } else if index == 1 {
            let healthDetails11ViewController = self.storyboard?.instantiateViewController(withIdentifier: "HealthDetails11ViewController") as! HealthDetails11ViewController
            self.present(healthDetails11ViewController, animated: true, completion: nil)
            
        } else if index == 2 {
            let healthDetails12ViewController = self.storyboard?.instantiateViewController(withIdentifier: "HealthDetails12ViewController") as! HealthDetails12ViewController
            self.present(healthDetails12ViewController, animated: true, completion: nil)
        }
    }
    
    private func displayAlert(for error: Error) {
        
        let alert = UIAlertController(title: nil,
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    
   
    func insertSteps(date: Date, value: Double) {
//        SVProgressHUD.show()
        let retult = manager.insertSteps(date: date, value: value)
        
//        SVProgressHUD.dismiss()
        if retult == true {
            vc_heathData.getSelfData()
            
        } else {
            
        }
    }
    
    func insertStepsHour(date: Date, value: Int64, hour: NSInteger) {
        let retult = manager.insertStepsHour(date: date, value: value, hour: hour)
        if retult == true {
            print(">>> insert step hour success, ", date, value, hour)
        } else {
            print(">>> insert step hour faild")
        }
    }
    
    func insertBloodPressure(date: Date, value1: Double, value2: Double) {
//        SVProgressHUD.show()
        
        let time = manager.getStrTime(date: date)
        let timeIndex = manager.getStrTimeIndex(date: date)
        
        let retult = manager.insertBloodPressure(date: date, time: time, timeIndex: timeIndex, value1: NSInteger(value1), value2: NSInteger(value2))
        
//        SVProgressHUD.dismiss()
        if retult == true {
            vc_heathData.getSelfData()
            
        } else {
            
        }
    }
    
    func insertBloodGlucose(date: Date, value: NSInteger, whenIndex: String) {
//        SVProgressHUD.show()
        
        let retult = manager.insertBloodGlucose(date: date, whenIndex: whenIndex, value: value)
        
//        SVProgressHUD.dismiss()
        if retult == true {
            vc_heathData.getSelfData()
            
        } else {
            
        }
    }
    
    func insertOxygenLevel(date: Date, value: NSInteger, time: String, timeIndex: String) {
//        SVProgressHUD.show()
        
        let retult = manager.insertOxygenLevel(date: date, time: time, timeIndex: timeIndex, value: value)
        
//        SVProgressHUD.dismiss()
        if retult == true {
//            child_2.getSelfData()
            
        } else {
            
        }
    }
    
    @objc func onClickAddButton(){
        let viewcontroller = (UIStoryboard(name: "Health", bundle: nil).instantiateViewController(withIdentifier: "AddHealthDataViewController") as! AddHealthDataViewController)
        viewcontroller.parentVc = self
        viewcontroller.modalPresentationStyle = .overFullScreen
        present(viewcontroller, animated: false, completion: nil)
    }
    
    public func UpdateUI(){
        let tmp = UserDefaults.standard.array(forKey: "selected_health")
        if let _ = tmp {
            manager.updateHealthInfo()
            vw_intro.isHidden = true
        }
        else{
            vw_intro.isHidden = false            
        }
        vc_heathData.getSelfData()
    }
}
