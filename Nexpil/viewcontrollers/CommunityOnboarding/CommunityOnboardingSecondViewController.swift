//
//  CommunityOnboardingSecondViewController.swift
//  Nexpil
//
//  Created by mac on 6/30/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class CommunityOnboardingSecondViewController: UIViewController {

    @IBOutlet weak var labelText: UILabel!
    public var m_fromWelcome = true
    override func viewDidLoad() {
        super.viewDidLoad()

        let attributedString = NSMutableAttributedString(string: labelText.text!)
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = 10
        paragraphStyle.alignment = .center
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        labelText.attributedText = attributedString
    }
    
    @objc func closeWindow() {
        self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func gotoFirstMedicationAddViewController(_ sender: Any) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommunityOnboardingScanViewController") as! CommunityOnboardingScanViewController        
        present(viewController, animated: false, completion: nil)
    }
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
}
