//
//  CommunityOnboardingFirstViewController.swift
//  Nexpil
//
//  Created by mac on 6/30/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import AVFoundation

class CommunityOnboardingFirstViewController: UIViewController {

    @IBOutlet weak var labelForText: UILabel!
    public var m_fromWelcome = true
    override func viewDidLoad() {
        super.viewDidLoad()

        let attributedString = NSMutableAttributedString(string: labelForText.text!)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 10
        paragraphStyle.alignment = .center
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        labelForText.attributedText = attributedString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if m_fromWelcome == false {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        m_fromWelcome = false
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func allowButtonTapped(_ sender: Any) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            DispatchQueue.main.async {
                if response {
                    let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommunityOnboardingSecondViewController") as! CommunityOnboardingSecondViewController
                    self.navigationController?.pushViewController(viewController, animated: true)
                } else {
                    self.navigationController?.popViewController(animated: false)
                }
            }
        }        
    }

    @objc func closeWindow() {
        self.navigationController?.popViewController(animated: true)
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
}
