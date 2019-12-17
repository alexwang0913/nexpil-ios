//
//  OnboardingTwoViewController.swift
//  Nexpil
//
//  Created by Cagri Sahan on 9/25/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class OnboardingTwoViewController: UIViewController {

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
        let datas = DBManager.getObject().getMedications()
        if datas.count > 0 {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let medicationController = storyBoard.instantiateViewController(withIdentifier: "AddMedicationListViewController") as! AddMedicationListViewController
            self.navigationController?.pushViewController(medicationController, animated: true)
        } else {
            if m_fromWelcome == false {
                self.navigationController?.popViewController(animated: false)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       // self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillDisappear(animated)
        m_fromWelcome = false
    }
    @IBAction func gotoFirstMedicationAddViewController(_ sender: Any) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstMedicationAddViewController") as! FirstMedicationAddViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.isHidden = true
        navController.modalPresentationStyle = .overFullScreen
        present(navController, animated: false, completion: nil)
    }
    @IBAction func backButton(_ sender: UIButton) {        
        self.navigationController?.popViewController(animated: false)
    }
    
}
