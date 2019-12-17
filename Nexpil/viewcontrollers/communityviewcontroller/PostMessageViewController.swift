//
//  PostMessageViewController.swift
//  Nexpil
//
//  Created by Admin on 21/06/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import VerticalSteppedSlider
import YPImagePicker

import AVFoundation
import AVKit

import Alamofire
import Photos

protocol UserSelectDelegate {
    func getSelectedUser(checks:[Bool])
    
}

class PostMessageViewController: UIViewController,ShadowDelegate,UserSelectDelegate {
    
    @IBOutlet weak var moodimage: UIImageView!
    @IBOutlet weak var postbtn: GradientView!
    @IBOutlet weak var selectedBar: UIView!
    
    @IBOutlet weak var moodbtn: UIButton!
    @IBOutlet weak var healthbtn: UIButton!
    @IBOutlet weak var mediabtn: UIButton!
    
    @IBOutlet weak var userimage: UIImageView!
    @IBOutlet weak var moodSlider: VSSlider!
    @IBOutlet weak var moodView: UIView!
    
    @IBOutlet weak var mediaImage: UIImageView!
    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var healthView: UIView!
    @IBOutlet weak var vwAttachContent: GradientView!
    
    @IBOutlet weak var containerView: GradientView!;
    public var delegate: CommunityMainViewController!
    
    var communityUsers:[CommunityUser] = []
    var viewIndex = 0
    
    var visualEffectView:VisualEffectView?
    
    var selectedUsers:[Bool] = []
    
    var filetype:Int?
    var videoUrl: URL?
    var photoImage: UIImage?
    var assets: PHFetchResult<PHAsset>? = nil
    let defaultItemSpacing: CGFloat = 1
    var itemSize:CGFloat = 0.0
    var m_healthItems = [[String: String]]()
    
    @IBOutlet weak var tblHealth: UITableView!
    @IBOutlet weak var content: UITextField!
    @IBOutlet weak var playbtn: UIButton!
    @IBOutlet weak var moodText: UILabel!
    
    var albumView:Bool = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let inset: CGFloat = 2
    let minimumLineSpacing: CGFloat = 2
    let minimumInteritemSpacing: CGFloat = 2
    let cellsPerRow = 3
    var m_selectedHealthIdx = -1
    
    @IBAction func moodChange(_ sender: Any) {
        switch Int(moodSlider.value) {
        case 1:
            moodimage.image = UIImage(named: "Very Sad")
            moodText.text = "Very Sad"
        case 2:
            moodimage.image = UIImage(named: "Sad")
            
            moodText.text = "Sad"
        case 3:
            moodimage.image = UIImage(named: "Neutral")
            moodText.text = "Neutral"
        case 4:
            moodimage.image = UIImage(named: "Happy")
            moodText.text = "Happy"
        case 5:
            moodimage.image = UIImage(named: "Very Happy")
            moodText.text = "Very Happy"
        default:
            break
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if PreferenceHelper().getUserImage() != ""
        {
            let url = URL(string: DataUtils.PROFILEURL + PreferenceHelper().getUserImage()!)
            userimage.kf.setImage(with: url)
        }
        else
        {
            userimage.image = UIImage(named: "Intersection 2")
            userimage.contentMode = .center
        }
        Global_CenterView(containerView)
        selectedBar.isHidden = true
        vwAttachContent.isHidden = true
        containerView.frame.size = CGSize(width:containerView.frame.size.width, height: 270)
        visualEffectView = self.view.backgroundBlur(view: self.view)
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.postData))
        postbtn.addGestureRecognizer(gesture)
        self.hideKeyboardWhenTappedAround1()
        
        userimage?.layer.masksToBounds = false
        userimage?.layer.borderWidth = 0.0
        //photoProfile.photoImage.layer.borderColor = endColor?.cgColor
        userimage?.layer.cornerRadius =  userimage!.frame.size.width/2
        userimage?.clipsToBounds = true
        moodSlider.value = 3
        collectionView.delegate = self
        collectionView.dataSource = self
        Global_CenterView(healthbtn!)
        Global_ShowFrostGlass(self.view)
        
        moodimage.image = UIImage(named: "Neutral")
        moodText.text = "Neutral"
        tblHealth.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryTableViewCell")
        getHealthData()
        
        if viewIndex == 1 {
            PHPhotoLibrary.requestAuthorization{ status in
                print(status)
            }
        }
    }
    
    func getHealthData() {
        let bloodGlucose = getBloodGlocose()
        let bloodPressure = getBloodPressure()
        let oxygenLevel = getOxygenlevel()
        let steps = getSteps()
        let weight = getWeight()
        
        let hemoglobin = getHemoglobinAlc()
        let lipid = getLipidPanel()
        let inr = getINR()
        
        let dic0 = ["title":"Blood Glucose", "image":"Blood Glucose", "value":bloodGlucose, "unit":"mg/dl", "icon":"icon_blood_glucose", "unit_color":"#333333"]
        let dic1 = ["title":"Blood Pressure", "image":"Blood Pressure", "value":bloodPressure, "unit":"", "icon":"icon_blood_pressure", "unit_color":"#333333"]
        let dic2 = ["title":"Oxygen Level", "image":"Oxygen Level", "value":oxygenLevel, "unit":"%", "icon":"icon_blood_glucose", "unit_color":"#333333"]
        let dic3 = ["title":"Steps", "image":"Steps", "value":steps, "unit":"", "icon":"", "unit_color":"#8495ED"]
        let dic4 = ["title":"Weight", "image":"Weight", "value":weight, "unit":"lbs", "icon":"", "unit_color":"#877CEC"]
        let dic5 = ["title":"Hemoglobin A1c", "image":"Hemoglobin A1c", "value":hemoglobin, "unit":"%"]
        let dic6 = ["title":"Lipid Panel", "image":"Lipid Panel", "value":lipid, "unit":"mg/dl"]
        let dic7 = ["title":"INR", "image":"INR", "value":inr]
        m_healthItems.removeAll()
        if let tmp = UserDefaults.standard.array(forKey: "selected_health"){

            let ary = tmp as! [Int]
            for i in ary {
                switch i {
                case 0:
                    m_healthItems.append(dic0)
                    break
                case 1:
                    m_healthItems.append(dic1)
                    break
                case 2:
                    m_healthItems.append(dic2)
                    break
                case 3:
                    m_healthItems.append(dic3)
                    break
                case 4:
                    m_healthItems.append(dic4)
                    break
                case 5:
                    m_healthItems.append(dic5)
                    break
                case 6:
                    m_healthItems.append(dic6)
                    break
                case 7:
                    m_healthItems.append(dic7)
                    break
                default:
                    break
                }
            }
        }
        tblHealth.reloadData()
    }
    
    @objc func postData(gesture: UIGestureRecognizer) {
        if viewIndex == 3
        {
            self.filetype = 4
        }
        else if viewIndex == 2
        {
            self.filetype = 3
        }
        else if viewIndex == 0 {
            self.filetype = 0
        }
        var users:String = ""
        if selectedUsers.count == 0
        {
            users = ""
        }
        else
        {
            for index in 0 ..< selectedUsers.count
            {
                users = users + "\(communityUsers[index + 1].userid)" + ","
            }
            if users.length > 0
            {
                users = users.substring(users.length - 1)
            }
        }
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone.current
        let currentDate = formatter.string(from: currentDateTime)
        if viewIndex <= 1
        {
            let params = [
                "type" : viewIndex,
                "userid" : PreferenceHelper().getId(),
                "choice" : "1",
                "content" : content.text!,
                "createat" : currentDate
                ] as [String : Any]
            DataUtils.customActivityIndicatory(self.view,startAnimate: true)
            let headers: HTTPHeaders = [
                //"Authorization": "your_access_token",  in case you need authorization header
                "Content-type": "multipart/form-data"
            ]
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                if self.filetype == 1
                {
                    if self.viewIndex == 1
                    {
                        guard let _ = self.photoImage else {
                            DataUtils.messageShow(view: self, message: "Please select photo", title: "")
                            return
                        }
                        if let data = UIImageJPEGRepresentation(self.photoImage!, 1){
                            
                            multipartFormData.append(data, withName: "name", fileName: "photo.jpg", mimeType: "image/jpeg")
                        }
                    }
                }
                else if self.filetype == 2 {
                    var movieData:Data?
                    do{
                        guard let _ = self.videoUrl else {
                            DataUtils.messageShow(view: self, message: "Please select video", title: "")
                            return}
                        movieData = try Data.init(contentsOf: self.videoUrl!)
                        
                    }catch{
                        
                    }

                    multipartFormData.append(movieData!, withName: "name", fileName: "video.mp4", mimeType: "video/mp4")
                }
                
            }, usingThreshold: UInt64.init(), to: DataUtils.APIURL + DataUtils.COMMUNITYPOST_URL, method: .post, headers: headers) { (result) in
                switch result{
                case .success(let upload, _, _):
                    print(upload.response)
                    upload.responseJSON { response in
                        print("Succesfully uploaded")
                        
                        DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                        if let err = response.error{
                            //onError?(err)
                            DataUtils.messageShow(view: self, message: err.localizedDescription, title: "")
                            return
                        }
                        //onCompletion
                        if let data = response.result.value {
                            if data is NSNull {
                                DataUtils.messageShow(view: self, message: "Error occurred.", title: "")
                                return
                            }
                            let json : [String:Any] = data as! [String : Any]
                            //let statusMsg: String = json["status_msg"] as! String
                            //self.showResultMessage(statusMsg)
                            //self.showGraph(json)
                            let result = json["status"] as? String
                            if result == "true"
                            {
                                self.dismiss(animated: false, completion: nil)
                                self.delegate.vw_feeds.showData()
                            }
                            else
                            {
                                let message = json["message"] as! String
                                DataUtils.messageShow(view: self, message: message, title: "")
                            }
                        }
                        
                    }
                case .failure(let error):
                    print("Error in upload: \(error.localizedDescription)")
                    DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                }
            }
        }
        else if viewIndex == 2
        {
            if m_selectedHealthIdx == -1 {
                DataUtils.messageShow(view: self, message: "Please select the health data.", title: "Warning")
                return
            }
            let healthValue = m_healthItems[m_selectedHealthIdx]["value"]! + " " + m_healthItems[m_selectedHealthIdx]["unit"]!
            let params = [
                "type" : "3",
                "userid" : PreferenceHelper().getId(),
                "choice" : "1",
                "content" : content.text!,
                "health_type" : m_healthItems[m_selectedHealthIdx]["title"]!,
                "health_value" : healthValue,
                "createat" : currentDate                
                ] as [String : Any]
            DataUtils.customActivityIndicatory(self.view,startAnimate: true)
            Alamofire.request(DataUtils.APIURL + DataUtils.COMMUNITYPOST_URL, method: .post, parameters: params)
                .responseJSON(completionHandler: { response in
                    DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                    if let data = response.result.value {
                        let json : [String:Any] = data as! [String : Any]
                        
                        let result = json["status"] as? String
                        if result == "true"
                        {
                            self.dismiss(animated: false, completion: nil)
                        }
                        else
                        {
                            let message = json["message"] as! String
                            DataUtils.messageShow(view: self, message: message, title: "")
                        }
                    }
                })
        }
        else if viewIndex == 3
        {
            var content = "Is feeling - "
            switch "\(Int(moodSlider.value))"
            {
            case "1":
                content += "Very Sad"
            case "2":
                content += "Sad"
            case "3":
                content += "Neutral"
            case "4":
                content += "Happy"
            case "5":
                content += "Very Happy"
            default:
                break
            }
            let params = [
                "type" : "4",
                "userid" : PreferenceHelper().getId(),
                "choice" : "1",
                "content" : content,
                "createat" : currentDate,
                "moodvalue" : "\(Int(moodSlider.value))"
                ] as [String : Any]
            DataUtils.customActivityIndicatory(self.view,startAnimate: true)
            let headers: HTTPHeaders = [
                "Content-type": "multipart/form-data"
            ]

            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
            }, usingThreshold: UInt64.init(), to: DataUtils.APIURL + DataUtils.COMMUNITYPOST_URL, method: .post, headers: headers) { (result) in
                switch result{
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                        if let err = response.error{
                            DataUtils.messageShow(view: self, message: err.localizedDescription, title: "")
                            return
                        }
                        //onCompletion
                        if let data = response.result.value {
                            if data is NSNull {
                                DataUtils.messageShow(view: self, message: "Error occurred.", title: "")
                                return
                            }
                            let json : [String:Any] = data as! [String : Any]
                            let result = json["status"] as? String
                            if result == "true"
                            {
                                self.dismiss(animated: false, completion: nil)
                            }
                            else
                            {
                                let message = json["message"] as! String
                                DataUtils.messageShow(view: self, message: message, title: "")
                            }
                        }
                        
                    }
                case .failure(let error):
                    print("Error in upload: \(error.localizedDescription)")
                    DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                }
            }
        }        
    }
    
    func getSelectedUser(checks:[Bool]) {
        selectedUsers = checks
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewSelect()
    }
    
    func removeShadow() {
        visualEffectView?.removeFromSuperview()
    }
    
    func viewSelect() {
        mediaView.isHidden = true
        healthView.isHidden = true
        moodView.isHidden = true
        
        
        moodbtn.setImage(UIImage(named: "Mood-3"), for: .normal)
        healthbtn.setImage(UIImage(named: "Health-6"), for: .normal)
        mediabtn.setImage(UIImage(named: "Media-3"), for: .normal)
        
        if viewIndex > 0 {
            selectedBar.isHidden = false
            vwAttachContent.isHidden = false
            containerView.frame.size = CGSize(width:containerView.frame.size.width, height: 540)
        }
        
        switch viewIndex {
        case 1:
            mediaView.isHidden = false
            mediabtn.setImage(UIImage(named: "Media-3"), for: .normal)
            selectedBar.frame = CGRect(x: 10, y: selectedBar.frame.origin.y
                , width: selectedBar.frame.size.width, height: selectedBar.frame.size.height)
            if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) != AVAuthorizationStatus.authorized {
                AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in}
            }
            PHPhotoLibrary.requestAuthorization{ status in
                print(status)
            }
        case 2:
            healthView.isHidden = false
            healthbtn.setImage(UIImage(named: "Health-6"), for: .normal)
            selectedBar.frame = CGRect(x: (containerView.frame.size.width - selectedBar.frame.size.width) / 2, y: selectedBar.frame.origin.y
                , width: selectedBar.frame.size.width, height: selectedBar.frame.size.height)
        case 3:
            moodView.isHidden = false            
            moodbtn.setImage(UIImage(named: "Mood-3"), for: .normal)
            selectedBar.frame = CGRect(x: containerView.frame.size.width - 10 - selectedBar.frame.size.width, y: selectedBar.frame.origin.y
                , width: selectedBar.frame.size.width, height: selectedBar.frame.size.height)
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Global_HideFrostGlass()
    }
    @IBAction func closeWindow(_ sender: Any) {
        dismiss(animated: false, completion: nil)
        
    }
    @IBAction func showCamera(_ sender: Any) {
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photoAndVideo
        config.library.onlySquare  = false
        config.onlySquareImagesFromCamera = true
        config.targetImageSize = .original
        config.usesFrontCamera = true
        config.showsFilters = false
        //config.filters = [YPFilterDescriptor(name: "Normal", filterName: ""),
        //                  YPFilterDescriptor(name: "Mono", filterName: "CIPhotoEffectMono")]
        config.shouldSaveNewPicturesToAlbum = true
        config.video.compression = AVAssetExportPresetMediumQuality //AVAssetExportPresetHighestQuality
        config.albumName = "Nexpil"
        config.video.fileType = AVFileType.mp4
        config.screens = [.photo,.video]
        config.startOnScreen = .library
        config.video.recordingTimeLimit = 10
        config.video.libraryTimeLimit = 20
        config.showsCrop = .rectangle(ratio: (16/9))
        config.wordings.libraryTitle = "Gallery"
        config.hidesStatusBar = false
        //config.overlayView = myOverlayView
        config.library.maxNumberOfItems = 1
        //config.library.minNumberOfItems = 3
        //config.isScrollToChangeModesEnabled = false
        
        // Build a picker with your configuration
        let picker = YPImagePicker(configuration: config)
        
        /* Multiple media implementation */
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            if cancelled {
                print("Picker was canceled")
                picker.dismiss(animated: true, completion: nil)
                return
            }
            _ = items.map { print("🧀 \($0)") }
            
            //self.selectedItems = items
            if let firstItem = items.first {
                switch firstItem {
                case .photo(let photo):
                    self.mediaImage.image = photo.image
                    self.photoImage = photo.image
                    self.filetype = 1
                    self.playbtn.isHidden = true
                    picker.dismiss(animated: true, completion: nil)
                case .video(let video):
                    self.mediaImage.image = video.thumbnail
                    self.filetype = 2
                    let assetURL = video.url
                    self.videoUrl = assetURL
                    self.playbtn.isHidden = false
                    
                    
                    picker.dismiss(animated: true, completion: { [weak self] in
                        
                        print("😀 \(String(describing: self?.resolutionForLocalVideo(url: assetURL)!))")
                    })
                }
            }
        }
        present(picker, animated: true, completion: nil)
    }
    @IBAction func showAlbum(_ sender: Any) {
        /*
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photoAndVideo
        config.library.onlySquare  = false
        config.onlySquareImagesFromCamera = true
        config.targetImageSize = .original
        config.usesFrontCamera = true
        config.showsFilters = false
        //config.filters = [YPFilterDescriptor(name: "Normal", filterName: ""),
        //                  YPFilterDescriptor(name: "Mono", filterName: "CIPhotoEffectMono")]
        config.shouldSaveNewPicturesToAlbum = true
        config.video.compression = AVAssetExportPresetMediumQuality //AVAssetExportPresetHighestQuality
        config.albumName = "Nexpil"
        config.screens = [.library]
        config.startOnScreen = .library
        config.video.fileType = AVFileType.mp4
        config.video.recordingTimeLimit = 10
        config.video.libraryTimeLimit = 20
        config.showsCrop = .rectangle(ratio: (16/9))
        config.wordings.libraryTitle = "Gallery"
        config.hidesStatusBar = false
        //config.overlayView = myOverlayView
        config.library.maxNumberOfItems = 1
        //config.library.minNumberOfItems = 3
        //config.isScrollToChangeModesEnabled = false
        
        // Build a picker with your configuration
        let picker = YPImagePicker(configuration: config)
        
        /* Multiple media implementation */
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            if cancelled {
                print("Picker was canceled")
                picker.dismiss(animated: true, completion: nil)
                return
            }
            _ = items.map { print("🧀 \($0)") }
            
            //self.selectedItems = items
            if let firstItem = items.first {
                switch firstItem {
                case .photo(let photo):
                    self.filetype = "photo"
                    self.mediaImage.image = photo.image
                    self.photoImage = photo.image
                    self.playbtn.isHidden = true
                    picker.dismiss(animated: true, completion: nil)
                case .video(let video):
                    self.mediaImage.image = video.thumbnail
                    self.filetype = "video"
                    let assetURL = video.url
                    self.videoUrl = assetURL
                    self.playbtn.isHidden = false
                    
                    picker.dismiss(animated: true, completion: { [weak self] in
                        
                        print("😀 \(String(describing: self?.resolutionForLocalVideo(url: assetURL)!))")
                    })
                }
            }
        }
        present(picker, animated: true, completion: nil)
        */
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            DispatchQueue.main.async {
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: options)
                DispatchQueue.main.async {
                    self.assets = assets
                    self.albumView = !self.albumView
                    self.showAlbumView()
                    self.collectionView.reloadData()
                }
            }
        }
//        PHPhotoLibrary.requestAuthorization { status in
//            switch status {
//            case .authorized:
//
//
//            case .denied, .restricted:
//                print("Not allowed")
//            case .notDetermined:
//                // Should not see this when requesting
//                print("Not determined yet")
//            }
//        }
        
    }
    func showAlbumView()
    {
        if self.albumView == true
        {
            collectionView.isHidden = false
        }
        else {
            collectionView.isHidden = true
        }
    }
    @IBAction func moodSelect(_ sender: Any) {
        viewIndex = 3
        viewSelect()
    }
    @IBAction func healthSelect(_ sender: Any) {
        viewIndex = 2
        viewSelect()
    }
    @IBAction func mediaSelect(_ sender: Any) {
        viewIndex = 1
        viewSelect()
    }
    @IBAction func showSelectUser(_ sender: Any) {
        self.view.addSubview(visualEffectView!)
        let viewcontroller = (UIStoryboard(name: "Community", bundle: nil).instantiateViewController(withIdentifier: "SelectPrivacyViewController") as! SelectPrivacyViewController)
        viewcontroller.communityUsers = self.communityUsers
        viewcontroller.delegate = self
        viewcontroller.delegate1 = self
        viewcontroller.modalPresentationStyle = .overCurrentContext
        present(viewcontroller, animated: false, completion: nil)
    }
    
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        let title = (error == nil) ? "Success" : "Error"
        let message = (error == nil) ? "Video was saved" : "Video failed to save"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func videoplay(_ sender: Any) {
        let playerVC = AVPlayerViewController()
        let player = AVPlayer(playerItem: AVPlayerItem(url:self.videoUrl!))
        playerVC.player = player
        self.present(playerVC, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround1() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard1))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard1() {
        view.endEditing(true)
        self.albumView = false
        self.showAlbumView()
    }
    
}

// Support methods
extension PostMessageViewController {
    /* Gives a resolution for the video by URL */
    func resolutionForLocalVideo(url: URL) -> CGSize? {
        guard let track = AVURLAsset(url: url).tracks(withMediaType: AVMediaType.video).first else { return nil }
        let size = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: fabs(size.width), height: fabs(size.height))
    }
    func itemAtIndexPath(_ indexPath: IndexPath) -> PHAsset? {
        return assets?[(indexPath as NSIndexPath).row]
    }
}

// MARK: - UICollectionViewDataSource -
extension PostMessageViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout  {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let data = assets?.count ?? 0
        return data
    }
    
    @objc(collectionView:willDisplayCell:forItemAtIndexPath:) public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if cell is PhotoCollectionViewCell {
            if let model = itemAtIndexPath(indexPath) {
                (cell as! PhotoCollectionViewCell).configureWithModel(model)
            }
        }        
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell
        return cell!        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        itemSize = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        return CGSize(width: itemSize, height: itemSize)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.filetype = 1
        
        PHImageManager.default().requestImage(for: itemAtIndexPath(indexPath)!, targetSize: CGSize.init(width: itemSize, height: itemSize), contentMode: .aspectFill, options: nil) { image, info in
            self.filetype = 1
            self.mediaImage.image = image
            self.photoImage = image
        }
    }
}

extension PostMessageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return m_healthItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblHealth.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        cell.setInfo(array: NSMutableArray(array:m_healthItems), index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        m_selectedHealthIdx = indexPath.row
    }
}
