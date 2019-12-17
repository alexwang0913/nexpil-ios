//
//  CommunityMainViewController.swift
//  Nexpil
//
//  Created by Admin on 4/9/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

import XLPagerTabStrip

import ASHorizontalScrollView

import Alamofire
import Kingfisher

protocol CommunitySubMenuDelegate {
    func selectDay(value:Int) -> (Int,Int)
}

class CommunityMainViewController: UIViewController, CommunitySubMenuDelegate  {

    //let names = ["You","James W.","Dr. Smith","Jess W","Hust Wilson","Lau Keith"]
    //let photos = ["you.png","james.png","smith.png","jess.png","hust.png","lau.png"]
    var communityusers:[CommunityUser] = []
    
    var photoProfiles:[ProfilePhoto] = []
    
    @IBOutlet weak var scrollContentWidth: NSLayoutConstraint!
    @IBOutlet weak var userPhotosView: UIView!
    var selectedUser:Int = 0
    var viewSelect = 0
    
    var userAddProfilePhoto:ProfilePhoto?
    var youImage:ProfilePhoto?
    var addState = false
    public var vw_feeds: FeedViewController!
    @IBOutlet weak var userAddbtn: GradientView!
    @IBOutlet weak var vw_addCode: GradientView!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var notificationDot: GradientView!
    
    @IBOutlet weak var notificationButton: FAButton!
    var startColor:UIColor?
    var endColor:UIColor?
    public var showCongPopup = false
    public var m_communityUserData: [String: Any]!
    
    @IBOutlet weak var pointLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startColor = UIColor.init(hex: "7ce2ec")
        endColor = UIColor.init(hex: "39d3e3")
        notificationDot.isHidden = true
        
        DataUtils.setStartColor(name: startColor!.toHex()!)
        DataUtils.setEndColor(name: endColor!.toHex()!)
        vw_addCode.isHidden = true
        
        self.hideKeyboardWhenTappedAround()
        
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(self.addUser))
        userAddbtn.addGestureRecognizer(gesture2)
        getCommunityUsersFromBackend()
        
        vw_feeds = (UIStoryboard(name: "Community", bundle: nil).instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController)
        vw_feeds.delegate = self
        addChildViewController(vw_feeds)
        vw_feeds.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        containerView.addSubview(vw_feeds.view)
        vw_feeds.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height)
        vw_feeds.didMove(toParentViewController: self)
        
        
        if showCongPopup {
            let vc = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommunityOnboardingCompleteViewController") as! CommunityOnboardingCompleteViewController)
            vc.m_user = CommunityUser.init(json: m_communityUserData)
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false)
            self.showCongPopup = false
        }
        
        // Event for notification button
        notificationButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(OnNotification)))
        notificationButton.isUserInteractionEnabled = true
        
//        Timer.scheduledTimer( withTimeInterval: 1.0, repeats: true) { timer in
//            let payload = ["choice":"1", "userid":PreferenceHelper().getId()] as [String : Any]
//            Alamofire.request(DataUtils.APIURL + DataUtils.COMMUNITYNOTIFICATION_URL, method: .post, parameters: payload)
//                .responseJSON(completionHandler: { response in
//                    if let data = response.result.value {
//                        let json : [String:Any] = data as! [String : Any]
//                        
//                        let result = json["status"] as? String
//                        if result == "true"
//                        {
//                            self.notificationDot.isHidden = !(json["data"] as! Bool)
//                        }
//                    }
//                })
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let _ = youImage else { return}
        if PreferenceHelper().getUserImage()! == ""
        {
            youImage!.photoImage.image = UIImage(named: "Intersection 1")
        }
        else {
            let url = URL(string: DataUtils.PROFILEURL + PreferenceHelper().getUserImage()!)
            youImage!.photoImage.kf.setImage(with: url)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 200
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 200
            }
        }
    }
    
    @objc func addUser(sender : UITapGestureRecognizer) {
        
        if codeTextField.text == "" {
            DataUtils.messageShow(view: self, message: "Please enter code", title: "")
            return
        }
        codeTextField.resignFirstResponder()
        
        let params = [
            "userid" : PreferenceHelper().getId(),
            "choice" : "2",
            "usercode" : codeTextField.text!
            ] as [String : Any]
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        Alamofire.request(DataUtils.APIURL + DataUtils.COMMUNITYUSERS_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                let user = PreferenceHelper()
                self.communityusers.append(CommunityUser.init(userid: user.getId(), firstname: user.getFirstName()!, lastname: user.getLastName()!, userimage: user.getUserImage()!))
                if let data = response.result.value {
                    let json : [String:Any] = data as! [String : Any]
                    
                    let result = json["status"] as? String
                    if result == "true"
                    {
                        let users = json["data"] as? [[String:Any]]
                        for user in users!
                        {
                            let communityuser = CommunityUser.init(json: user)
                            self.communityusers.append(communityuser)
                        }
                        //self.getCommunityUsers()
                        self.communityUserAdd()
                    }
                    else {
                        let message = json["message"] as! String
                        DataUtils.messageShow(view: self, message: message, title: "")
                    }
                }
            })
    }
    
    func selectDay(value: Int) -> (Int,Int){
        viewSelect = value
        var userid = 0
        if communityusers.count == 0
        {
            userid = PreferenceHelper().getId()
        }
        else {
            userid = communityusers[selectedUser].userid
        }
        return (selectedUser,userid)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func getCommunityUsersFromBackend() {
        communityusers = []
        let params = [
            "userid" : PreferenceHelper().getId(),
            "choice" : "0"
            ] as [String : Any]
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        Alamofire.request(DataUtils.APIURL + DataUtils.COMMUNITYUSERS_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                print(response.result.description)
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                let user = PreferenceHelper()
                self.communityusers.append(CommunityUser.init(userid: user.getId(), firstname: user.getFirstName()!, lastname: user.getLastName()!, userimage: user.getUserImage()!))
                
                if let data = response.result.value {
                    let json : [String:Any] = data as! [String : Any]
                    
                    let result = json["status"] as? String
                    if result == "true"
                    {
                        let users = json["data"] as? [[String:Any]]
                        for user in users!
                        {
                            let communityuser = CommunityUser.init(json: user)
                            self.communityusers.append(communityuser)
                        }
                    }
                    self.getCommunityUsers()
                }
            })
    }
    
    func communityUserAdd()
    {
        let photoProfile = ProfilePhoto.init(frame: CGRect(x: 0 , y: 0, width: 110, height: 110))
        //photoProfile.frame = CGRect.init(x: 0, y: 0, width: 110, height: 110)
        var image: UIImage?
        if communityusers[communityusers.count - 1].userimage == ""
        {
            image = UIImage(named: "Intersection 1")
            photoProfile.photoImage.image = image
            photoProfile.photoImage.contentMode = .bottom
        }
        else
        {
            let url = URL(string: DataUtils.PROFILEURL + communityusers[communityusers.count - 1].userimage)
            photoProfile.photoImage.kf.setImage(with: url)
        }
        
        photoProfile.photoImage.layer.masksToBounds = false
        photoProfile.photoImage.layer.borderWidth = 0.0
        
        photoProfile.photoImage.layer.cornerRadius =  photoProfile.photoImage.frame.size.height/2
        
        photoProfile.photoImage.clipsToBounds = true
        photoProfile.userName.text = communityusers[communityusers.count - 1].firstname + " " + communityusers[communityusers.count - 1].lastname.prefix(1).uppercased() + "." //names[i]
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(gesture:)))
        photoProfile.photoImage.tag = communityusers.count - 1
        
        photoProfile.photoImage.addGestureRecognizer(tapGesture)
        photoProfile.photoImage.isUserInteractionEnabled = true       
        
        userPhotosView.addSubview(photoProfile)// addItem(photoProfile)
        photoProfiles.append(photoProfile)        
    }
    
    func getCommunityUsers() {
        userPhotosView.removeAllSubviews()
        photoProfiles.removeAll()
        let itemWidth: CGFloat = 80.0
//        scrollContentWidth.constant = 320
//        for i in 0..<9 {
//            let xPos = itemWidth * CGFloat(i)
////            userAddProfilePhoto = ProfilePhoto.init(frame: CGRect(x: 0 , y: 0, width: itemWidth, height: itemWidth))
//            print(xPos)
//            userAddProfilePhoto = ProfilePhoto.init(frame: CGRect(x: xPos , y: 0, width: itemWidth, height: itemWidth))
//            //photoProfile.frame = CGRect.init(x: 0, y: 0, width: 110, height: 110)
//            userAddProfilePhoto!.userName.text = "Add \(i)"//names[i]
//            //let image: UIImage = UIImage(named: photos[i])!
//            //photoProfile.photoImage.image = image
//            userAddProfilePhoto!.photoImage.image = UIImage(named: "Add")
//            userAddProfilePhoto!.photoImage.layer.masksToBounds = false
//            userAddProfilePhoto!.photoImage.layer.borderWidth = 0.0
//            userAddProfilePhoto!.photoImage.layer.borderColor = UIColor.init(hex: "5546E4").cgColor
//            userAddProfilePhoto!.photoImage.layer.cornerRadius =  userAddProfilePhoto!.photoImage.frame.size.width/2
//            //photoProfile.photoImage.layer.borderWidth = 5.0
//
//            let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(self.addCommunityMember(gesture:)))
//            userAddProfilePhoto!.photoImage.tag = communityusers.count
//            userAddProfilePhoto!.photoImage.addGestureRecognizer(tapGesture1)
//            userAddProfilePhoto!.photoImage.isUserInteractionEnabled = true
//
//            userPhotosView.addSubview(userAddProfilePhoto!)
//        }
        
        scrollContentWidth.constant = CGFloat((communityusers.count + 1) * 40)
        userAddProfilePhoto = ProfilePhoto.init(frame: CGRect(x: 0 , y: 0, width: itemWidth, height: itemWidth))
        userAddProfilePhoto = ProfilePhoto.init(frame: CGRect(x: 0 , y: 0, width: itemWidth, height: itemWidth))
        //photoProfile.frame = CGRect.init(x: 0, y: 0, width: 110, height: 110)
        userAddProfilePhoto!.userName.text = "Add"//names[i]
        //let image: UIImage = UIImage(named: photos[i])!
        //photoProfile.photoImage.image = image
        userAddProfilePhoto!.photoImage.image = UIImage(named: "Add")
        userAddProfilePhoto!.photoImage.layer.masksToBounds = false
        userAddProfilePhoto!.photoImage.layer.borderWidth = 0.0
        userAddProfilePhoto!.photoImage.layer.borderColor = UIColor.init(hex: "5546E4").cgColor
        userAddProfilePhoto!.photoImage.layer.cornerRadius =  userAddProfilePhoto!.photoImage.frame.size.width/2
        //photoProfile.photoImage.layer.borderWidth = 5.0
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(self.addCommunityMember(gesture:)))
        userAddProfilePhoto!.photoImage.tag = communityusers.count
        userAddProfilePhoto!.photoImage.addGestureRecognizer(tapGesture1)
        userAddProfilePhoto!.photoImage.isUserInteractionEnabled = true

        userPhotosView.addSubview(userAddProfilePhoto!)
        
        var xPos: CGFloat = userAddProfilePhoto?.frame.size.width ?? 0
        
        for i in 0 ..< communityusers.count
        {
            let photoProfile = ProfilePhoto.init(frame: CGRect(x: xPos, y: 0, width: itemWidth, height: itemWidth))
            xPos += photoProfile.frame.size.width
            if i == 0
            {
                photoProfile.userName.text = "You"
            }
            else
            {
                photoProfile.userName.text = communityusers[i].firstname + " " + communityusers[i].lastname.prefix(1).uppercased() + "." //names[i]
            }

            var image: UIImage?
            if communityusers[i].userimage == ""
            {
                image = UIImage(named: "Intersection 1")
                photoProfile.photoImage.image = image
                photoProfile.photoImage.contentMode = .bottom
            }
            else
            {
                let url = URL(string: DataUtils.PROFILEURL + communityusers[i].userimage)
                photoProfile.photoImage.kf.setImage(with: url)
            }

            photoProfile.photoImage.layer.borderColor = UIColor.init(hex: "5546E4").cgColor
            photoProfile.photoImage.layer.masksToBounds = false
            photoProfile.photoImage.layer.borderWidth = 0.0

            photoProfile.photoImage.frame = CGRect(x: 0, y: 8, width: 60, height: 60)
            Global_CenterView(photoProfile.photoImage)
            photoProfile.photoImage.layer.cornerRadius =  photoProfile.photoImage.frame.size.height/2
            photoProfile.userName.frame = CGRect(x: 0, y: 75, width: 80, height: 18)
            Global_CenterView(photoProfile.userName)
            photoProfile.photoImage.clipsToBounds = true

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(gesture:)))
            photoProfile.photoImage.tag = i

            photoProfile.photoImage.addGestureRecognizer(tapGesture)
            photoProfile.photoImage.isUserInteractionEnabled = true

            if i == 0
            {
                youImage = photoProfile
            }

            userPhotosView.addSubview(photoProfile)
            photoProfiles.append(photoProfile)
        }
    }
    
    func setColorSettings()
    {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        var currentDate1 = ""
        formatter.timeZone = TimeZone.current
        let locale = NSLocale.current
        let formatter1 : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
        if formatter1.contains("a") {
            
            //phone is set to 12 hours
            formatter.dateFormat = "h:mm a"
            let time1 = formatter.string(from: currentDateTime)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            let date = formatter.date(from: time1)
            formatter.dateFormat = "HH:mm"
            currentDate1 = formatter.string(from: date!)
            
            
        } else {
            //phone is set to 24 hours
            formatter.dateFormat = "HH:mm"
            currentDate1 = formatter.string(from: currentDateTime)
        }
        
        
        let hour = Int(currentDate1.components(separatedBy: ":")[0])!
        let min = Int(currentDate1.components(separatedBy: ":")[1])!
        var starttime = DataUtils.getTimeRange(index: 0)!.components(separatedBy: "-")[0]
        var endtime = DataUtils.getTimeRange(index: 0)!.components(separatedBy: "-")[1]
        var startH = Int(starttime.components(separatedBy: ":")[0])!
        var startM = Int(starttime.components(separatedBy: ":")[1])!
        var endH = Int(endtime.components(separatedBy: ":")[0])!
        var endM = Int(endtime.components(separatedBy: ":")[1])!
        

        
        if startH * 60 + startM <= hour * 60 + min && endH * 60 + endM > hour * 60 + min {
            //UITabBar.appearance().tintColor = UIColor.init(hex: "39d3e3")
            //self.tabBarController?.tabBar.tintColor = UIColor.init(hex: "39d3e3")

            //return
        }
        
        starttime = DataUtils.getTimeRange(index: 1)!.components(separatedBy: "-")[0]
        endtime = DataUtils.getTimeRange(index: 1)!.components(separatedBy: "-")[1]
        startH = Int(starttime.components(separatedBy: ":")[0])!
        startM = Int(starttime.components(separatedBy: ":")[1])!
        endH = Int(endtime.components(separatedBy: ":")[0])!
        endM = Int(endtime.components(separatedBy: ":")[1])!
        if startH * 60 + startM <= hour * 60 + min && endH * 60 + endM > hour * 60 + min {
            //UITabBar.appearance().tintColor = UIColor.init(hex: "397ee3")
            //self.tabBarController?.tabBar.tintColor = UIColor.init(hex: "397ee3")

            //return
        }
        
        starttime = DataUtils.getTimeRange(index: 2)!.components(separatedBy: "-")[0]
        endtime = DataUtils.getTimeRange(index: 2)!.components(separatedBy: "-")[1]
        startH = Int(starttime.components(separatedBy: ":")[0])!
        startM = Int(starttime.components(separatedBy: ":")[1])!
        endH = Int(endtime.components(separatedBy: ":")[0])!
        endM = Int(endtime.components(separatedBy: ":")[1])!
        if startH * 60 + startM <= hour * 60 + min && endH * 60 + endM > hour * 60 + min {
            //UITabBar.appearance().tintColor = UIColor.init(hex: "415ce3")
            //self.tabBarController?.tabBar.tintColor = UIColor.init(hex: "415ce3")

            //return
        }
        
        starttime = DataUtils.getTimeRange(index: 3)!.components(separatedBy: "-")[0]
        endtime = DataUtils.getTimeRange(index: 3)!.components(separatedBy: "-")[1]
        startH = Int(starttime.components(separatedBy: ":")[0])!
        startM = Int(starttime.components(separatedBy: ":")[1])!
        endH = Int(endtime.components(separatedBy: ":")[0])!
        endM = Int(endtime.components(separatedBy: ":")[1])!
        if startH * 60 + startM <= hour * 60 + min && endH * 60 + endM > hour * 60 + min {
            //UITabBar.appearance().tintColor = UIColor.init(hex: "4939e3")
            //self.tabBarController?.tabBar.tintColor = UIColor.init(hex: "4939e3")

            //return
        }
  
    }
    
    func showShareScreen()
    {
        let params = [
            "userid" : PreferenceHelper().getId(),
            "choice" : "4"
            ] as [String : Any]
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        Alamofire.request(DataUtils.APIURL + DataUtils.COMMUNITYUSERS_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                
                debugPrint(response);
                
                if let data = response.result.value {                    
                    let json : [String:Any] = data as! [String : Any]
                    //let statusMsg: String = json["status_msg"] as! String
                    //self.showResultMessage(statusMsg)
                    //self.showGraph(json)
                    let result = json["status"] as? String
                    if result == "true"
                    {
                        let usercode = json["usercode"] as? String
                        //DataUtils.messageShow(view: self, message: usercode!, title: "")
                        let shareText = "My code is " + usercode!
                        let activityViewController = UIActivityViewController(activityItems: [shareText] , applicationActivities: nil)
                        activityViewController.popoverPresentationController?.sourceView = self.view
                        self.present(activityViewController, animated: true, completion: nil)
                    }
                    else
                    {
                        let message = json["message"] as! String
                        DataUtils.messageShow(view: self, message: message, title: "")
                    }
                }
            })
    }
    
    @objc func addCommunityMember(gesture: UIGestureRecognizer) {
        
        if addState == true
        {
            userAddProfilePhoto!.userName.text = "Add"//names[i]
            userAddProfilePhoto!.photoImage.image = UIImage(named: "Add")
            userAddProfilePhoto!.photoImage.layer.masksToBounds = false
            userAddProfilePhoto!.photoImage.layer.borderWidth = 0.0
            userAddProfilePhoto!.photoImage.layer.cornerRadius =  userAddProfilePhoto!.photoImage.frame.size.width/2
            vw_addCode.isHidden = true;
//            containerView.frame.origin = CGPoint(x: 0, y: 270)
            vw_feeds.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height)
        }
        else {
            
            userAddProfilePhoto!.userName.text = "Cancel"//names[i]
            userAddProfilePhoto!.photoImage.image = UIImage(named: "Close_x")
            userAddProfilePhoto!.photoImage.layer.masksToBounds = false
            userAddProfilePhoto!.photoImage.layer.borderWidth = 0.0
            userAddProfilePhoto!.photoImage.layer.cornerRadius =  userAddProfilePhoto!.photoImage.frame.size.width/2
            vw_addCode.isHidden = false;
//            containerView.frame.origin = CGPoint(x: 0, y: vw_addCode.frame.origin.y + vw_addCode.frame.size.height)
            vw_feeds.view.frame = CGRect(x: 0, y: vw_addCode.frame.origin.y + vw_addCode.frame.size.height, width: containerView.frame.size.width, height: containerView.frame.size.height)
            showShareScreen()
        }
        addState = !addState
    }
    @objc func tapGesture(gesture: UIGestureRecognizer) {
        let view = gesture.view
        let index = view!.tag
        
        if index == selectedUser
        {
            return
        }
        else{
            selectedUser = index
        }
        for (i,obj) in photoProfiles.enumerated()
        {
            if i == index
            {
                obj.photoImage.layer.borderWidth = 5.0
            }
            else
            {
                obj.photoImage.layer.borderWidth = 0.0
            }
        }
        vw_feeds!.selectedUser = self.selectedUser
        vw_feeds!.selectedUserid = communityusers[selectedUser].userid
        vw_feeds!.communityUsers = self.communityusers
        vw_feeds!.showData()
    }
    
    @objc func OnNotification(){
        let viewcontroller = (UIStoryboard(name: "Community", bundle: nil).instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController)
        viewcontroller.delegate = self
        viewcontroller.modalPresentationStyle = .overCurrentContext
        present(viewcontroller, animated: false, completion: nil)
    }
}

