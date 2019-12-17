//
//  CommunityOnboardingCompleteViewController.swift
//  Nexpil
//
//  Created by mac on 7/1/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class CommunityOnboardingCompleteViewController: UIViewController {

    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    public var m_user: CommunityUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if m_user.userimage == ""
        {
            imgAvatar.image = UIImage(named: "Intersection 1")
        }
        else
        {
            let url = URL(string: DataUtils.PROFILEURL + m_user.userimage)
            imgAvatar.kf.setImage(with: url)
        }
        lblMsg.text = "You have successfully added " + m_user.firstname + " to your Community!"
    }

    @IBAction func onClose(){
        self.dismiss(animated: false, completion: nil)
    }
}
