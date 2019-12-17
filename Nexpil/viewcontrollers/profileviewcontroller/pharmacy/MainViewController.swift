//
//  MainViewController.swift
//  Pharmacies
//
//  Created by Mohammed Faizuddin on 3/15/19.
//  Copyright © 2019 Mohammed Faizuddin. All rights reserved.
//

import UIKit
import Pulley

protocol MainViewControllerDelegate: class{
    func closeBtnAction()
}

class MainViewController: UIViewController {

    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet var cancelButton: UIButton!
    
   weak var delegate: MainViewControllerDelegate?
    
    //weak var childDrawerViewController: PharmacyInfoViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
            }
    
    func setupUI() {
        bgView.backgroundColor = UIColor.clear //this will fix your white corners issue
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOffset = .zero
        bgView.layer.shadowOpacity = 0.3
        bgView.layer.shadowRadius = 5.0
        
        containerView.frame = view.bounds
        containerView.layer.cornerRadius = 30.0
        containerView.layer.masksToBounds = true
        
        self.bgView.layer.cornerRadius = 30.0
        cancelButton.setImage(UIImage(named: "close"), for: .normal)
    }
    
    
    @IBAction func cancelTapped(_ sender: Any) {
        
        if cancelButton.currentImage == UIImage(named: "close") {
            dismiss(animated: true, completion: nil)
            delegate?.closeBtnAction()
        } else if cancelButton.currentImage == UIImage(named: "back"){
            
            
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "goBack"), object: nil)

            cancelButton.setImage(UIImage(named: "close"), for: .normal)
        }
        
        
    }
    
}
