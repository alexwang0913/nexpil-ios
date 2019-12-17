//
//  HealthDefaultViewController.swift
//  Nexpil
//
//  Created by Ajai Nair on 4/8/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class VwHealthDefault: UIView {

    @IBOutlet var vw_container: GradientView!
    public var parentVc: HealthViewController!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        Global_CenterView(vw_container!)
        Global_ShowFrostGlass(self)
    }
    @IBAction func OnAdd(){
        parentVc.manager.delegate = self;
        parentVc.manager.authorizeHealthKit()
    }
    
    public func OnCloseHealthSetting(_ ret: Bool){
        if ret == true {
            DispatchQueue.main.async {
                UserDefaults.standard.set(true, forKey: "health_default")
                Global_HideFrostGlass()
                self.removeFromSuperview()
                self.parentVc.HideDefaultOverlay()
            }
        }
    }
}
