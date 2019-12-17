//
//  NotificationsViewController.swift
//  Nexpil
//
//  Created by Admin on 4/9/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

import XLPagerTabStrip
import Alamofire

class NotificationsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var notificationtableView: UITableView!
    var delegate: CommunityMainViewController?
    var startColor:String?
    var endColor:String?
    var notifications:[NotificationEntity] = []
    override func viewDidLoad() {
        super.viewDidLoad()
//        Global_ShowFrostGlass(self.view)
//        Global1_ShowFrostGlass(self.view)
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame

        self.view.insertSubview(blurEffectView, at: 0)
        
        notificationtableView.register(UITableViewCell.self, forCellReuseIdentifier: "default")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        showData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Global_HideFrostGlass()
    }
    
    @IBAction func OnClose(){
        dismiss(animated: false, completion: nil)
    }
    
    func showData()
    {
        let params = [
            "userid" : PreferenceHelper().getId(),
            "choice" : "0"
            ] as [String : Any]
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        Alamofire.request(DataUtils.APIURL + DataUtils.COMMUNITYNOTIFICATION_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                self.notifications.removeAll()
                
                if let data = response.result.value {                    
                    let json : [String:Any] = data as! [String : Any]
                    let result = json["status"] as? String
                    if result == "true"
                    {
                        let users = json["data"] as? [[String:Any]]
                        for user in users!
                        {
                            let post = NotificationEntity.init(json: user)
                            self.notifications.append(post)
                        }
                    }
                    else
                    {
                        let message = json["message"] as! String
                        DataUtils.messageShow(view: self, message: message, title: "")
                    }
                    self.notificationtableView.reloadData()
                }
            })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if notifications.count == 0 {
            return 1
        }
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if notifications.count == 0 {
            let cell:UITableViewCell = notificationtableView.dequeueReusableCell(withIdentifier: "default") as UITableViewCell!
            cell.textLabel?.text = "No Medications or No-one in your community"
            cell.backgroundColor = UIColor.clear
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.lineBreakMode = .byWordWrapping
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as? NotificationTableViewCell
        let first = notifications[indexPath.row].firstname
        let last = notifications[indexPath.row].lastname
        cell?.userName.text =  first + " " + last
        cell?.content.text = notifications[indexPath.row].notification
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dt = formatter.date(from: notifications[indexPath.row].createat)
        formatter.dateFormat = "hh:mm a"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        cell?.time.text = formatter.string(from: dt!)
        
        if notifications[indexPath.row].userimage == "" {
            cell?.userphoto.image = UIImage(named: "Intersection 2")
            cell?.userphoto.contentMode = .center
        } else {
            let url = URL(string: DataUtils.PROFILEURL + notifications[indexPath.row].userimage)
            cell?.userphoto.kf.setImage(with: url)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 90
    }
}

extension NotificationsViewController : IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Notifications")
    }
}
