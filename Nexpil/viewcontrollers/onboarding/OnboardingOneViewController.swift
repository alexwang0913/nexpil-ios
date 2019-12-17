//
//  OnboardingOneViewController.swift
//  Nexpil
//
//  Created by Cagri Sahan on 9/24/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class OnboardingOneViewController: UIViewController {
    @IBOutlet weak var firstViewHeight: NSLayoutConstraint!
    @IBOutlet weak var secondViewHeight: NSLayoutConstraint!
    @IBOutlet weak var textSpaceFromtop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let screensize = UIScreen.main.bounds.size
        textSpaceFromtop.constant = ((screensize.height * 4.92) / 100)
        firstViewHeight.constant = (((screensize.width - 40) * 67.46268) / 100)
        secondViewHeight.constant = (((screensize.width - 40) * 67.46268) / 100)//Float(((screensize.width - 40) * 71.64) / 100)
        DBManager.getObject().deleteTmpDrug()
    }
    @IBAction func gotoCameraAccessAllow(_ sender: Any) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardingMyHealthScanLabelViewController") as! OnboardingMyHealthScanLabelViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func onCommunity(_ sender: Any) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommunityOnboardingFirstViewController") as! CommunityOnboardingFirstViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func closeWindow()
    {
        dismiss(animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
