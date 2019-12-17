//
//  OnboardingMyHealthScanLabelViewController.swift
//  Nexpil
//
//  Created by Cagri Sahan on 9/25/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import AVFoundation

class OnboardingMyHealthScanLabelViewController: UIViewController {
    
    @IBOutlet weak var labelForText: UILabel!
    public var m_fromWelcome = true
    
    @IBAction func allowButtonTapped(_ sender: Any) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            DispatchQueue.main.async {
                if response {
                    let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardingTwoViewController") as! OnboardingTwoViewController
                    self.navigationController?.pushViewController(viewController, animated: true)
                } else {
                    self.navigationController?.popViewController(animated: false)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributedString = NSMutableAttributedString(string: labelForText.text!)
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = 10
        paragraphStyle.alignment = .center
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        labelForText.attributedText = attributedString
    }
    
    @objc func closeWindow() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
        if m_fromWelcome == false {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       // self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillDisappear(animated)
        m_fromWelcome = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        print(authStatus.rawValue)
        switch authStatus {
        case .authorized:
            super.prepare(for: segue, sender: sender)
        case .denied:
            DispatchQueue.main.async {
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, completionHandler: nil)
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        super.prepare(for: segue, sender: sender)
                    }
                }
            }
        default:
            DispatchQueue.main.async {
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, completionHandler: nil)
            }
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
