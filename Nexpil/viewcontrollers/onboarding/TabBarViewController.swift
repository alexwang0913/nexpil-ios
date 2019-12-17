//
//  TabBarViewController.swift
//  Nexpil
//
//  Created by Yun Lai on 2018/12/10.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

var mTabView: TabbarView = TabbarView()

class TabBarViewController: UITabBarController {
    var mTabs: [TabObj] = [TabObj]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        initUI(0)
        NotificationCenter.default.addObserver(self, selector: #selector(updateHomeNavbar(noti:)), name: Notification.Name.Action.UpdateTabBarItem, object: nil)
        
        // Check current time and set Home nav icon
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "GMT")!
        let currentHour = calendar.component(.hour, from: GlobalManager.GetToday())
        
        for i in 0...3 {
            let starttime = DataUtils.getTimeRange(index: i)!.components(separatedBy: "-")[0]
            let endtime = DataUtils.getTimeRange(index: i)!.components(separatedBy: "-")[1]
            let startH = Int(starttime.components(separatedBy: ":")[0])!
            let endH = Int(endtime.components(separatedBy: ":")[0])!
            
            if currentHour >= startH && currentHour <= endH {
                initUI(i)
            }
        }
        if currentHour == 0 {
            initUI(0)
        }
    }
    
    func initUI(_ index: Int) {
        self.selectedIndex = 0
        self.tabBar.isHidden = true
        
        let margin: CGFloat = 10
        let width: CGFloat = self.view.frame.width - CGFloat(margin * 2)
        let height: CGFloat = 66
        let x: CGFloat = margin
        let y: CGFloat = self.view.frame.size.height - CGFloat(height + margin * 2)
        
        initTabs(selectedNo: index)
        
        mTabView = TabbarView.init(frame: CGRect.init(x: x, y: y, width: width, height: height), tabs: mTabs)
        mTabView.viewShadow_drug()
        
        mTabView.setSelectedIndex(0)
        mTabView.blockSelected = {
            (tabObj: TabObj) -> Void in
            let index = self.mTabs.index(of: tabObj)
            self.selectedIndex = index ?? 0
        }
        mTabView.tag = 101
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapHome))
        gesture.numberOfTapsRequired = 2
        mTabView.subviews[0].addGestureRecognizer(gesture)
        self.view.addSubview(mTabView)
    }
    
    func initTabs(selectedNo: Int) {
        let colors = ["Aqua", "Blue", "Navy", "Purple"]
        
        let tabHome: TabObj = TabObj.init(name: "Home", image: "Home_Grey", imageSelected: "Home_\(colors[selectedNo])")
        let tabHealth: TabObj = TabObj.init(name: "Health", image: "Health_Grey", imageSelected: "Health_" + "\(colors[selectedNo])")
        let tabCommunity: TabObj = TabObj.init(name: "Community", image: "Community_Grey", imageSelected: "Community_" + "\(colors[selectedNo])")
        let tabProfile: TabObj = TabObj.init(name: "Profile", image: "Profile_Grey", imageSelected: "Profile_" + "\(colors[selectedNo])")
        
        mTabs.append(tabHome)
        mTabs.append(tabHealth)
        mTabs.append(tabCommunity)
        mTabs.append(tabProfile)
        
        
        
    }
    
    @objc func updateHomeNavbar(noti: Notification) {
        guard let dic = noti.object as? Dictionary<String, String>, let index = dic["index"]  else {
            return
        }
        let idx = Int(index) ?? 0
        
        let viewWithTag = self.view.viewWithTag(101)
        viewWithTag?.removeFromSuperview()
        
        mTabs = [TabObj]()
        
        initUI(idx)
    }
    
    @objc func doubleTapHome() {
        NotificationCenter.default.post(name: Notification.Name.Action.DoubleTapHomeTab, object: ["index": "0"])
    }
    
}

