//
//  ScanBloodGlucoseViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/31.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import AVFoundation

protocol ScanBloodGlucoseViewControllerDelegate: class {
    func didTapButtonAddGlucoseScanBloodGlucoseViewController(date: Date, whenIndex: String, value: NSInteger);
    func showShadow()
}


class ScanBloodGlucoseViewController: UIViewController,
PopupBloodGlucoseViewControllerDelegate, SHDCameraUtilityDelegate, AddManuallyBloodGlucoseViewControllerDelegate {

    weak var delegate:ScanBloodGlucoseViewControllerDelegate?
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imgTake: UIImageView!
    
    var popupBloodGlucoseViewController = PopupBloodGlucoseViewController()
    var manager = DataManager()
    var cameraUtility = SHDCameraUtility()
    
    var showPopupDialog = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.w
        
        self.initMainView()
        self.initCameraView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        cameraUtility.finalizeLoad(with: contentView)
        
        let bloodGlucosePremierShow = UserDefaults.standard.bool(forKey: "BloodGlucosePremierShow")
        
        if !bloodGlucosePremierShow {
            let modalVC = (self.storyboard?.instantiateViewController(withIdentifier: "PopupHealthPremerModalViewController") as? PopupHealthPremerModalViewController)!
            modalVC.modalPresentationStyle = .overCurrentContext
            modalVC.scheme = 1
            self.present(modalVC, animated: false, completion: nil)
            
            UserDefaults.standard.set(true, forKey: "BloodGlucosePremierShow")
        }

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
        btnAdd.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
    }
    
    func initCameraView() {
        cameraUtility = SHDCameraUtility.init(view: contentView, andDelegate: self)
    }
    
    
    @IBAction func tapBtnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.delegate?.showShadow()
        })
    }
    
    @IBAction func tapbtnAddManually(_ sender: Any) {
        sleep(UInt32(0.5))
        
        let addManuallyViewController = (self.storyboard?.instantiateViewController(withIdentifier: "NewBloodGlucoseAddManuallyViewController") as? NewBloodGlucoseAddManuallyViewController)!
        addManuallyViewController.modalPresentationStyle = .overFullScreen
        self.present(addManuallyViewController, animated: false, completion: nil)
    }
    
    // MARK - AddManuallyBloodGlucoseViewController delegate
    func didTapButtonDoneAddManuallyBloodGlucoseViewController(date: Date, whenIndex: String, value: NSInteger) {
        self.delegate?.didTapButtonAddGlucoseScanBloodGlucoseViewController(date: date,
                                                                            whenIndex: whenIndex,
                                                                            value: value)
        
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK - PopupBloodGlucoseViewControllerDelegate
    func didTapButtonClosePopupBloodGlucoseViewController() {
        popupBloodGlucoseViewController.view.removeFromSuperview()
    }
    
    func didTapButtonDonePopupBloodGlucoseViewController(date: Date, whenIndex: String, value: NSInteger) {
        popupBloodGlucoseViewController.view.removeFromSuperview()
        self.dismiss(animated: false, completion: nil)
        
        self.delegate?.didTapButtonAddGlucoseScanBloodGlucoseViewController(date: date,
                                                                            whenIndex: whenIndex,
                                                                            value: value)
    }

    func didTapButtonErrorPopupBloodGlucoseViewController(error: String) {
        self.loadAlertController(message: error)
    }
    
    func loadAlertController(message: String) {
        let alert = UIAlertController(title: message,
                                      message: nil,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func tapBtnShot(_ sender: Any) {
        AudioServicesPlaySystemSound(1108)
        cameraUtility.touchUp()
    }
    
    // MARK - CameraUtility Delegate
    func cameraUtilityDidTakePhoto(_ photo: UIImage!) {
//        imgTake.image = photo
        self.loadVerifyInformationBloodGlucoseViewController()
    }
    
    func loadVerifyInformationBloodGlucoseViewController() {
        let verifyInformationBloodGlucoseViewController = (self.storyboard?.instantiateViewController(withIdentifier: "VerifyInformationBloodGlucoseViewController") as? VerifyInformationBloodGlucoseViewController)!
//        verifyInformationBloodGlucoseViewController.delegate = self
        verifyInformationBloodGlucoseViewController.isNew = true
        self.present(verifyInformationBloodGlucoseViewController, animated: true, completion: nil)
    }
    
}
