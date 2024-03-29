//
//  PopupINRViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/06/05.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit

protocol PopupPopupINRViewControllerDelegate: class {
    func didTapButtonClosePopupINRViewController()
    func didTapButtonDonePopupINRViewController(date: Date, value: Float)
    func didTapButtonErrorPopupINRViewController(error: String)
}

class PopupINRViewController: UIViewController, PopupCalenderViewControllerDelegate {

    weak var delegate:PopupPopupINRViewControllerDelegate?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var subViewDate: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTitleDate: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblEnterTitle: UILabel!
    @IBOutlet weak var lblUnit: UILabel!
    @IBOutlet weak var txtINR: UITextFieldExtension!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    
    var popupCalenderViewController = PopupCalenderViewController()
    var dateFormatter = DateFormatter()
    var sendDate = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initMainView()
        self.setSelfData()
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

    func initMainView() {
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true;
        
        subViewDate.layer.cornerRadius = 10
        subViewDate.layer.masksToBounds = true;
        
        txtINR.layer.cornerRadius = 10
        txtINR.layer.masksToBounds = true;
        txtINR.layer.borderWidth = 0.8
        txtINR.layer.borderColor = UIColor.lightGray.cgColor
        
        txtINR.keyboardType = .numberPad
        
        btnCancel.layer.cornerRadius = 10
        btnCancel.layer.masksToBounds = true;
        
        btnDone.layer.cornerRadius = 10
        btnDone.layer.masksToBounds = true;
        
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        lblTitle.font = UIFont.init(name: "Montserrat", size: 30)
        lblTitleDate.font = UIFont.init(name: "Montserrat", size: 20)
        lblDate.font = UIFont.init(name: "Montserrat", size: 20)
        lblEnterTitle.font = UIFont.init(name: "Montserrat", size: 20)
        lblUnit.font = UIFont.init(name: "Montserrat", size: 20)
        txtINR.font = UIFont.init(name: "Montserrat", size: 20)
        btnDone.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        btnCancel.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
    }
    
    func setSelfData() {
        let date = Date()
        let strDate = dateFormatter.string(from: date)
        lblDate.text = strDate
        sendDate = date
        
    }
    
    @IBAction func taBtnBgDate(_ sender: Any) {
        self.loadPopupCalendarViewController()
    }
    
    // MARK - load PopupCalendarViewController
    func loadPopupCalendarViewController() {
        sleep(UInt32(0.5))
        
        popupCalenderViewController = (self.storyboard?.instantiateViewController(withIdentifier: "PopupCalenderViewController") as? PopupCalenderViewController)!
        popupCalenderViewController.delegate = self
        popupCalenderViewController.index = 6
        
        UIApplication.shared.keyWindow?.addSubview((popupCalenderViewController.view)!)
    }
    
    // MARK - PopupcalendarViewController delegate
    func didTapButtonClosePopupCalenderViewController() {
        popupCalenderViewController.view.removeFromSuperview()
    }
    
    func didTapButtonChooseDatePopupCalenderViewController(date: Date) {
        popupCalenderViewController.view.removeFromSuperview()
        
        let strDate = dateFormatter.string(from: date)
        lblDate.text = strDate
        print(">>> date:", strDate)
        sendDate = date
    }
    
    @IBAction func tapBtnClose(_ sender: Any) {
        self.delegate?.didTapButtonClosePopupINRViewController()
        
    }
    
    @IBAction func tapBtnCancel(_ sender: Any) {
        self.delegate?.didTapButtonClosePopupINRViewController()
    }
    
    @IBAction func tapBtnDone(_ sender: Any) {
        if (txtINR.text?.count)! > 0 {
            let val = (txtINR.text as! NSString).floatValue
            self.delegate?.didTapButtonDonePopupINRViewController(date: sendDate, value: val)
            
        } else {
            self.delegate?.didTapButtonErrorPopupINRViewController(error: "Please input value")
        }
    }
    
    
}
