//
//  FeedViewController.swift
//  Nexpil
//
//  Created by Admin on 4/9/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

import XLPagerTabStrip

import Alamofire
import AVFoundation
import AVKit
import OnlyPictures
class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    enum FeedCellType: Int {
        case calluser = 0
        case postmessage
        case image
        case video
        case message
        case question
    }
    
    let names = ["You","James W.","Dr. Smith","Jess W","Hust Wilson","Lau Keith"]
    
    var content:[FeedCellType] = [.postmessage,.image,.message,.question,.video]
    var content1:[FeedCellType] = [.calluser,.image,.message,.question,.video]
    
    var delegate: CommunityMainViewController?
    var selectedUser:Int = 0   
    var selectedUserid:Int = 0
    var posts:[PostEntity] = []
    var communityUsers:[CommunityUser] = []
    @IBOutlet weak var feedtableView: UITableView!
    
    let imageCache = NSCache<NSString, UIImage>()
    var userPictureIndex = 0
    var userimages:[String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        feedtableView.rowHeight = UITableViewAutomaticDimension
        feedtableView.estimatedRowHeight = 100
        //feedtableView.separatorStyle = UITableViewCellSeparatorStyle.none
//        feedtableView.allowsSelection = false
//        feedtableView.alwaysBounceVertical = false
//        feedtableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        
        NotificationCenter.default.addObserver(self, selector: #selector(getPostLikeNotification(notification:)), name: NSNotification.Name(rawValue: "PostLike"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        (selectedUser,selectedUserid) = (delegate?.selectDay(value: 0))!
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "profilechange")
        {
            showData()
            defaults.set(false,forKey:"profilechange")
        }else {
            showData()
        }
    }

    func showData()
    {
        let params = [
            "userid" : selectedUserid,
            "choice" : "0"
            ] as [String : Any]
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        Alamofire.request(DataUtils.APIURL + DataUtils.COMMUNITYPOST_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                
                if let data = response.result.value {
                    self.posts.removeAll()
                    let json : [String:Any] = data as! [String : Any]
                    
                    let result = json["status"] as? String
                    if result == "true"
                    {
                        if self.selectedUser != 0
                        {
                            let user = json["user"] as! [String : Any]
                            let firstname = (user["firstname"] as! NSString) as String
                            let lastname = (user["lastname"] as! NSString) as String
                            let username = firstname + " " + lastname.prefix(1).uppercased() + "."
                            let userimage = (user["userimage"] as! NSString) as String
                            let phonenumber = (user["phonenumber"] as! NSString) as String
                            self.posts.append(PostEntity.init(userid: self.selectedUserid, type: 5, title: "", content: "", filename: "", mediaurl: "", createat: "", username: username, userimage: userimage, phonenumber: phonenumber))
                        }
                        else {
                            self.posts.append(PostEntity.init(userid: self.selectedUserid, type: 6, title: "", content: "", filename: "", mediaurl: "", createat: "", username: "", userimage: "", phonenumber: ""))
                        }
                        // Add divider
                        self.posts.append(PostEntity.init(userid: self.selectedUserid, type: 8, title: "", content: "", filename: "", mediaurl: "", createat: "", username: "", userimage: "", phonenumber: ""))
                        
                        let users = json["data"] as? [[String:Any]]
                        for user in users!
                        {
                            let post = PostEntity.init(json: user)
                            self.posts.append(post)
                        }
                        
                        // Add Fact Ads Cell
                        self.posts.append(PostEntity.init(userid: self.selectedUserid, type: 10, title: "", content: "", filename: "", mediaurl: "", createat: "", username: "", userimage: "", phonenumber: ""))
                        // Add Static Ads Cell
                        self.posts.append(PostEntity.init(userid: self.selectedUserid, type: 11, title: "", content: "", filename: "", mediaurl: "", createat: "", username: "", userimage: "", phonenumber: ""))
                        // Add Video Ads Cell
                        self.posts.append(PostEntity.init(userid: self.selectedUserid, type: 12, title: "", content: "", filename: "", mediaurl: "", createat: "", username: "", userimage: "", phonenumber: ""))
                        
                        // Add EmptyCell
                        self.posts.append(PostEntity.init(userid: self.selectedUserid, type: 9, title: "", content: "", filename: "", mediaurl: "", createat: "", username: "", userimage: "", phonenumber: ""))
                    }
                    else {
                        return
                    }
                    
                    self.feedtableView.reloadData()
                }
                    
            })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        if posts.count == 0 { // Return EmptyCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityEmptyTableViewCell", for: indexPath) as? CommunityEmptyTableViewCell
            return cell!
        }
        
        if posts[indexPath.row].type == 5//FeedCellType.calluser
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CallTableViewCell", for: indexPath) as? CallTableViewCell
            cell?.callbtn.layer.cornerRadius = 10
            cell?.callbtn.layer.masksToBounds = true
            cell?.callbtn.setTitle(posts[0].username,for: .normal)
            return cell!
        }
        else if posts[indexPath.row].type == 8 { // Divider
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityDividerTableViewCell", for: indexPath) as? CommunityDividerTableViewCell
            return cell!
        }
        else if posts[indexPath.row].type == 9 { // EmptyCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityEmptyTableViewCell", for: indexPath) as? CommunityEmptyTableViewCell
            return cell!
        }
        else if posts[indexPath.row].type == 10 { // Fact Ads
            let cell = tableView.dequeueReusableCell(withIdentifier: "FactAdsTableViewCell", for: indexPath) as? FactAdsTableViewCell
            return cell!
        }
        else if posts[indexPath.row].type == 11 { // Static Ads
            let cell = tableView.dequeueReusableCell(withIdentifier: "StaticAdsTableViewCell", for: indexPath) as? StaticAdsTableViewCell
            return cell!
        }
        else if posts[indexPath.row].type == 12 { // Video Ads
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoAdsTableViewCell", for: indexPath) as? VideoAdsTableViewCell
            return cell!
        }
        else if posts[indexPath.row].type == 0//FeedCellType.message
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as? MessageTableViewCell
            
            cell?.photo.layer.cornerRadius =  (cell?.photo.frame.size.width)!/2
            cell?.photo.clipsToBounds = true
            if PreferenceHelper().getUserImage() != ""
            {
                let url = URL(string: DataUtils.PROFILEURL + PreferenceHelper().getUserImage()!)
                cell?.photo.kf.setImage(with: url)
            }
            else
            {
                cell?.photo.image = UIImage(named: "Intersection 2")
                cell?.commentImage.image = UIImage(named: "Intersection 2")
                cell?.photo.contentMode = .center
            }
//            cell?.commentphoto.layer.cornerRadius =  (cell?.commentphoto.frame.size.width)!/2
//            cell?.commentphoto.clipsToBounds = true
//            if posts[indexPath.row].userimage == ""
//            {
//                let image = UIImage(named: "Intersection 1")
//                cell?.photo.image = image
//                //cell?.userImage.contentMode = .bottom
//                cell?.commentphoto.image = image
//                //cell?.commentImage.contentMode = .scaleAspectFit
//            }
//            else
//            {
//                let url = URL(string: DataUtils.PROFILEURL + posts[indexPath.row].userimage)
//                cell?.photo.kf.setImage(with: url)
//                cell?.commentphoto.kf.setImage(with: url)
//            }
            
            cell?.message.text = posts[indexPath.row].content
            cell?.name.text = posts[indexPath.row].firstname + " " + posts[indexPath.row].lastname

            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let time = formatter.date(from: posts[indexPath.row].createat)
            formatter.dateFormat = "h:mm a "
            formatter.amSymbol = "am"
            formatter.pmSymbol = "pm"
            let stringTime = formatter.string(from: time!)

            cell?.time.text = stringTime



            cell?.commentImage.layer.masksToBounds = false
            cell?.commentImage.layer.borderWidth = 0.0
            //photoProfile.photoImage.layer.borderColor = endColor?.cgColor
            cell?.commentImage.layer.cornerRadius =  cell!.commentImage.frame.size.width/2
            cell?.commentImage.clipsToBounds = true


            cell?.commentText.text = posts[indexPath.row].comment
            cell?.commentText.delegate = self
            cell?.commentText.tag = indexPath.row
            cell?.commentcnt.text = "\(posts[indexPath.row].commentcounts)"
            cell?.likecnt.text = "\(posts[indexPath.row].likecounts)"
            cell?.likebtn.tag = indexPath.row
            cell?.likebtn.addTarget(self, action: #selector(self.postLike(_:)), for: .touchUpInside)

            cell?.commentbtn.tag = indexPath.row
            cell?.commentbtn.addTarget(self, action: #selector(self.viewCommentMood(_:)), for: .touchUpInside)

            cell?.onlypictures.dataSource = self
            //cell?.onlypictures.delegate = self
            cell?.onlypictures.gap = 28
            cell?.onlypictures.layer.cornerRadius = 18
            cell?.onlypictures.spacingColor = .white
            cell?.onlypictures.alignment = .left
            if posts[indexPath.row].comments.count == 0
            {
                cell?.onlypictures.isHidden = true
            }
            else {
                self.getUserPictures(postIndex: indexPath.row, onlyPictures: cell!.onlypictures)
            }

            let commentCount = posts[indexPath.row].commentcounts
            if posts[indexPath.row].showMoreComment {
                cell?.commentList = posts[indexPath.row].comments
            } else {
                cell?.commentList.removeAll()
                if commentCount == 1 {
                    cell?.commentList.append(posts[indexPath.row].comments[0])
                } else if commentCount > 1 {
                    cell?.commentList.append(posts[indexPath.row].comments[0])
                    cell?.commentList.append(posts[indexPath.row].comments[1])
                }
            }

            
            cell?.moreCommentButton.isHidden = commentCount < 3
            cell?.commentTableViewTopMargin.constant = commentCount < 3 ? 20 : 45
            if posts[indexPath.row].showMoreComment {
                cell?.moreCommentButton.setTitle("Hide \(commentCount-2) comments", for: .normal)
            } else {
                if commentCount > 2 {
                    cell?.moreCommentButton.setTitle("View \(commentCount-2) more comments", for: .normal)
                    cell?.moreCommentButton.isHidden = false
                }
            }

            cell?.moreCommentButton.tag = indexPath.row
            cell?.moreCommentButton.addTarget(self, action: #selector(self.showMoreComment(_:)), for: .touchUpInside)
            cell?.commentView.layer.cornerRadius = 20
            cell?.commentView.layer.masksToBounds = true
            cell?.commentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            
            if posts[indexPath.row].showMoreComment {
                cell?.commentViewHeight.constant = CGFloat(70 + 150 * commentCount)
            } else {
                cell?.commentViewHeight.constant = CGFloat(70 + 150 * (commentCount > 2 ? 2 : commentCount))
            }
            
            cell?.commentView.isHidden = posts[indexPath.row].showComment ? false : true
            cell?.m_tag = indexPath.row
            cell?.commentTableView.reloadData()
            
            return cell!
        }
        else if posts[indexPath.row].type == 6//FeedCellType.postmessage
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as? PostTableViewCell
            
            if PreferenceHelper().getUserImage() != ""
            {
                let url = URL(string: DataUtils.PROFILEURL + PreferenceHelper().getUserImage()!)
                cell?.userphoto.kf.setImage(with: url)
            }
            else
            {
                cell?.userphoto.image = UIImage(named: "Intersection 2")
                cell?.userphoto.contentMode = .center
            }
            let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.postData))
            cell?.whatsonyourmind.addGestureRecognizer(gesture)
            
            cell?.photobtn.tag = 1
            cell?.photobtn.addTarget(self, action: #selector(self.addPost(_:)), for: .touchUpInside)
            cell?.healthBtn.tag = 2
            cell?.healthBtn.addTarget(self, action: #selector(self.addPost(_:)), for: .touchUpInside)
            cell?.moodbtn.tag = 3
            cell?.moodbtn.addTarget(self, action: #selector(self.addPost(_:)), for: .touchUpInside)
            cell?.userphoto.layer.cornerRadius =  cell!.userphoto.frame.size.width/2
            cell?.userphoto.clipsToBounds = true
            
            return cell!
        }
        else if posts[indexPath.row].type == 7//FeedCellType.question
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as? QuestionTableViewCell
            return cell!
        }
        else if posts[indexPath.row].type <= 2 //FeedCellType.image
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as? ImageTableViewCell
            
            if posts[indexPath.row].type <= 1
            {
                if posts[indexPath.row].filename != ""
                {
                    let url = URL(string: DataUtils.PHOTOURL + posts[indexPath.row].filename)
                    cell?.mediaimage.kf.setImage(with: url)
                }
                cell?.playbtn.isHidden = true
            }
            else {
                if let cachedImage = imageCache.object(forKey: (DataUtils.VIDEOURL + self.posts[indexPath.row].filename) as NSString) {
                    
                    cell?.mediaimage.image = cachedImage
                }
                else {
                    cell?.mediaimage.image = self.createThumbnailOfVideoFromRemoteUrl(url:DataUtils.VIDEOURL + self.posts[indexPath.row].filename)
                }
                cell?.playbtn.isHidden = false
                cell?.playbtn.tag = indexPath.row
                cell?.playbtn.addTarget(self, action: #selector(self.playVideo(_:)), for: .touchUpInside)
            }
            
            if posts[indexPath.row].userimage == ""
            {
                let image = UIImage(named: "Intersection 1")
                cell?.userImage.image = image
                //cell?.userImage.contentMode = .bottom
                cell?.commentImage.image = image
                //cell?.commentImage.contentMode = .scaleAspectFit
            }
            else
            {
                let url = URL(string: DataUtils.PROFILEURL + posts[indexPath.row].userimage)
                cell?.userImage.kf.setImage(with: url)
                cell?.commentImage.kf.setImage(with: url)
            }
            cell?.userImage.layer.masksToBounds = true
            cell?.userImage.layer.borderWidth = 0.0
            cell?.userImage.layer.cornerRadius = cell!.userImage.frame.size.height/2
            cell?.userImage.clipsToBounds = true
            
            cell?.commentImage.layer.masksToBounds = false
            cell?.commentImage.layer.borderWidth = 0.0
            //photoProfile.photoImage.layer.borderColor = endColor?.cgColor
            cell?.commentImage.layer.cornerRadius =  cell!.commentImage.frame.size.width/2
            cell?.commentImage.clipsToBounds = true
            
            cell?.content.text = posts[indexPath.row].content
            cell?.userName.text = posts[indexPath.row].firstname + " " + posts[indexPath.row].lastname
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let time = formatter.date(from: posts[indexPath.row].createat)
            formatter.dateFormat = "h:mm a "
            formatter.amSymbol = "am"
            formatter.pmSymbol = "pm"
            let stringTime = formatter.string(from: time!)
            
            cell?.createTime.text = stringTime
            cell?.commentText.text = posts[indexPath.row].comment
            cell?.commentText.delegate = self
            cell?.commentText.tag = indexPath.row
            cell?.commentcnt.text = "\(posts[indexPath.row].commentcounts)"
            cell?.likecnt.text = "\(posts[indexPath.row].likecounts)"
            cell?.likebtn.tag = indexPath.row
            cell?.likebtn.addTarget(self, action: #selector(self.postLike(_:)), for: .touchUpInside)
            
            cell?.commentbtn.tag = indexPath.row
            cell?.commentbtn.addTarget(self, action: #selector(self.viewComment(_:)), for: .touchUpInside)

            cell?.onlypictures.dataSource = self
            
            cell?.onlypictures.gap = 28
            cell?.onlypictures.layer.cornerRadius = 18
            cell?.onlypictures.spacingColor = .white
            cell?.onlypictures.alignment = .left
            if posts[indexPath.row].comments.count == 0
            {
                cell?.onlypictures.isHidden = true
            }
            else {
                self.getUserPictures(postIndex: indexPath.row, onlyPictures: cell!.onlypictures)
            }
            
            let commentCount = posts[indexPath.row].commentcounts
            if posts[indexPath.row].showMoreComment {
                cell?.commentList = posts[indexPath.row].comments
            } else {
                cell?.commentList.removeAll()
                if commentCount == 1 {
                    cell?.commentList.append(posts[indexPath.row].comments[0])
                } else if commentCount > 1 {
                    cell?.commentList.append(posts[indexPath.row].comments[0])
                    cell?.commentList.append(posts[indexPath.row].comments[1])
                }
            }
            
            
            cell?.moreCommnetButton.isHidden = commentCount < 3
            cell?.commentTableViewTopMargin.constant = commentCount < 3 ? 20 : 45
            if posts[indexPath.row].showMoreComment {
                cell?.moreCommnetButton.setTitle("Hide \(commentCount-2) comments", for: .normal)
            } else {
                cell?.moreCommnetButton.setTitle("View \(commentCount-2) more comments", for: .normal)
            }

            cell?.moreCommnetButton.tag = indexPath.row
            cell?.moreCommnetButton.addTarget(self, action: #selector(self.showMoreComment(_:)), for: .touchUpInside)
            cell?.commentView.layer.cornerRadius = 20
            cell?.commentView.layer.masksToBounds = true
            cell?.commentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            
            if posts[indexPath.row].showMoreComment {
                cell?.commentViewHeight.constant = CGFloat(70 + 150 * commentCount)
            } else {
                cell?.commentViewHeight.constant = CGFloat(70 + 150 * (commentCount > 2 ? 2 : commentCount))
            }
            
            cell?.commentView.isHidden = posts[indexPath.row].showComment ? false : true
            cell?.m_tag = indexPath.row
            cell?.commentTableView.reloadData()
            
            return cell!
            
        }
        else if posts[indexPath.row].type == 4 // mood
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MoodTableViewCell", for: indexPath) as? MoodTableViewCell
            
            if posts[indexPath.row].userimage == ""
            {
                let image = UIImage(named: "Intersection 1")
                cell?.userImage.image = image
                //cell?.userImage.contentMode = .bottom
                cell?.commentImage.image = image
                //cell?.commentImage.contentMode = .scaleAspectFit
            }
            else
            {
                let url = URL(string: DataUtils.PROFILEURL + posts[indexPath.row].userimage)
                cell?.userImage.kf.setImage(with: url)
                cell?.commentImage.kf.setImage(with: url)
            }
            cell?.userImage.layer.masksToBounds = false
            cell?.userImage.layer.borderWidth = 0.0
            cell?.userImage.layer.cornerRadius =  cell!.userImage.frame.size.height/2
            cell?.userImage.clipsToBounds = true
            
            cell?.commentImage.layer.masksToBounds = false
            cell?.commentImage.layer.borderWidth = 0.0
            //photoProfile.photoImage.layer.borderColor = endColor?.cgColor
            cell?.commentImage.layer.cornerRadius =  cell!.commentImage.frame.size.width/2
            cell?.commentImage.clipsToBounds = true
            
//            cell?.content.text = posts[indexPath.row].content
            cell?.userName.text = posts[indexPath.row].firstname + " " + posts[indexPath.row].lastname
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let time = formatter.date(from: posts[indexPath.row].createat)
            formatter.dateFormat = "h:mm a "
            formatter.amSymbol = "am"
            formatter.pmSymbol = "pm"
            let stringTime = formatter.string(from: time!)
            
            cell?.createTime.text = stringTime
            cell?.commentText.text = posts[indexPath.row].comment
            cell?.commentText.delegate = self
            cell?.commentText.tag = indexPath.row
            cell?.commentcnt.text = "\(posts[indexPath.row].commentcounts)"
            cell?.likecnt.text = "\(posts[indexPath.row].likecounts)"
            cell?.likebtn.tag = indexPath.row
            cell?.likebtn.addTarget(self, action: #selector(self.postLike(_:)), for: .touchUpInside)
            cell?.content.text = "Is feeling - "
            cell?.commentbtn.tag = indexPath.row
            cell?.commentbtn.addTarget(self, action: #selector(self.viewCommentMood(_:)), for: .touchUpInside)
            cell?.moodText.textColor = UIColor.init(hex: DataUtils.getEndColor()!)
            switch(posts[indexPath.row].moodstate)
            {
            case "1":
                cell?.moodText.text = "Very Sad"
                cell?.moodImage.image = UIImage.init(named: "Very Sad")
            case "2":
                cell?.moodText.text = "Sad"
                cell?.moodImage.image = UIImage.init(named: "Sad")
            case "3":
                cell?.moodText.text = "Neutral"
                cell?.moodImage.image = UIImage.init(named: "Neutral")
            case "4":
                cell?.moodText.text = "Happy"
                cell?.moodImage.image = UIImage.init(named: "Happy")
            case "5":
                cell?.moodText.text = "Very Happy"
                cell?.moodImage.image = UIImage.init(named: "Very Happy")
            default:
                break
            }
            
            cell?.onlypictures.dataSource = self
            //cell?.onlypictures.delegate = self
            cell?.onlypictures.gap = 28
            cell?.onlypictures.layer.cornerRadius = 18
            cell?.onlypictures.spacingColor = .white
            cell?.onlypictures.alignment = .left
            if posts[indexPath.row].comments.count == 0
            {
                cell?.onlypictures.isHidden = true
            }
            else {
                self.getUserPictures(postIndex: indexPath.row, onlyPictures: cell!.onlypictures)
            }
            
            let commentCount = posts[indexPath.row].commentcounts
            
            if posts[indexPath.row].showMoreComment {
                cell?.commentList = posts[indexPath.row].comments
            } else {
                cell?.commentList.removeAll()
                if commentCount == 1 {
                    cell?.commentList.append(posts[indexPath.row].comments[0])
                } else if commentCount > 1 {
                    cell?.commentList.append(posts[indexPath.row].comments[0])
                    cell?.commentList.append(posts[indexPath.row].comments[1])
                }
            }
            
            
            cell?.moreCommentButton.isHidden = commentCount < 3
            cell?.commentTableViewTopMargin.constant = commentCount < 3 ? 20 : 45
            if posts[indexPath.row].showMoreComment {
                cell?.moreCommentButton.setTitle("Hide \(commentCount-2) comments", for: .normal)
            } else {
                cell?.moreCommentButton.setTitle("View \(commentCount-2) more comments", for: .normal)
            }

            cell?.moreCommentButton.tag = indexPath.row
            cell?.moreCommentButton.addTarget(self, action: #selector(self.showMoreComment(_:)), for: .touchUpInside)
            cell?.commentView.layer.cornerRadius = 20
            cell?.commentView.layer.masksToBounds = true
            cell?.commentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            
            if posts[indexPath.row].showMoreComment {
                cell?.commentViewHeight.constant = CGFloat(70 + 150 * commentCount)
            } else {
                cell?.commentViewHeight.constant = CGFloat(70 + 150 * (commentCount > 2 ? 2 : commentCount))
            }
            
            cell?.commentView.isHidden = posts[indexPath.row].showComment ? false : true
            cell?.m_tag = indexPath.row
            cell?.commentTableView.reloadData()
            
            return cell!
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellHealthPost", for: indexPath) as? CellHealthPost
            
            cell?.photo.layer.cornerRadius =  (cell?.photo.frame.size.width)!/2
            cell?.photo.clipsToBounds = true
            
            cell?.commentphoto.layer.cornerRadius =  (cell?.commentphoto.frame.size.width)!/2
            cell?.commentphoto.clipsToBounds = true
            if posts[indexPath.row].userimage == ""
            {
                let image = UIImage(named: "Intersection 1")
                cell?.photo.image = image
                cell?.commentphoto.image = image
            }
            else
            {
                let url = URL(string: DataUtils.PROFILEURL + posts[indexPath.row].userimage)
                cell?.photo.kf.setImage(with: url)
                cell?.commentphoto.kf.setImage(with: url)
            }
            
            cell?.message.text = posts[indexPath.row].content
            cell?.name.text = posts[indexPath.row].firstname + " " + posts[indexPath.row].lastname
            cell?.lblSharedUser.text = cell?.name.text
            cell?.lblHealthType.text = posts[indexPath.row].healthType
            cell?.lblHealthValue.text = posts[indexPath.row].healthValue
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let time = formatter.date(from: posts[indexPath.row].createat)
            formatter.dateFormat = "h:mm a "
            formatter.amSymbol = "am"
            formatter.pmSymbol = "pm"
            let stringTime = formatter.string(from: time!)
            
            cell?.time.text = stringTime
            cell?.commentText.text = posts[indexPath.row].comment
            cell?.commentText.delegate = self
            cell?.commentText.tag = indexPath.row
            cell?.commentcounts.text = "\(posts[indexPath.row].commentcounts)"
            cell?.likecounts.text = "\(posts[indexPath.row].likecounts)"
            
            cell?.like.tag = indexPath.row
            cell?.like.addTarget(self, action: #selector(self.postLike(_:)), for: .touchUpInside)
            
            cell?.comment.tag = indexPath.row
            cell?.comment.addTarget(self, action: #selector(self.viewComment(_:)), for: .touchUpInside)
            
            cell?.onlypictures.dataSource = self
            //cell?.onlypictures.delegate = self
            cell?.onlypictures.gap = 28
            cell?.onlypictures.layer.cornerRadius = 18
            cell?.onlypictures.spacingColor = .white
            cell?.onlypictures.alignment = .left
            if posts[indexPath.row].comments.count == 0
            {
                cell?.onlypictures.isHidden = true
            }
            else {
                self.getUserPictures(postIndex: indexPath.row, onlyPictures: cell!.onlypictures)
            }
            
            let commentCount = posts[indexPath.row].commentcounts
            if posts[indexPath.row].showMoreComment {
                cell?.commentList = posts[indexPath.row].comments
            } else {
                cell?.commentList.removeAll()
                if commentCount == 1 {
                    cell?.commentList.append(posts[indexPath.row].comments[0])
                } else if commentCount > 1 {
                    cell?.commentList.append(posts[indexPath.row].comments[0])
                    cell?.commentList.append(posts[indexPath.row].comments[1])
                }
            }

            
            cell?.moreCommentButton.isHidden = commentCount < 3
            cell?.commentTableViewTopMargin.constant = commentCount < 3 ? 20 : 45
            if posts[indexPath.row].showMoreComment {
                cell?.moreCommentButton.setTitle("Hide \(commentCount-2) comments", for: .normal)
            } else {
                cell?.moreCommentButton.setTitle("View \(commentCount-2) more comments", for: .normal)
            }

            cell?.moreCommentButton.tag = indexPath.row
            cell?.moreCommentButton.addTarget(self, action: #selector(self.showMoreComment(_:)), for: .touchUpInside)
            cell?.commentView.layer.cornerRadius = 20
            cell?.commentView.layer.masksToBounds = true
            cell?.commentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            
            if posts[indexPath.row].showMoreComment {
                cell?.commentViewHeight.constant = CGFloat(70 + 150 * commentCount)
            } else {
                cell?.commentViewHeight.constant = CGFloat(70 + 150 * (commentCount > 2 ? 2 : commentCount))
            }
            
            cell?.commentView.isHidden = posts[indexPath.row].showComment ? false : true
            cell?.m_tag = indexPath.row
            cell?.commentTableView.reloadData()
            
            return cell!
        }
    }
    
    func getUserPictures(postIndex:Int, onlyPictures:OnlyHorizontalPictures) {
        self.userPictureIndex = postIndex
        
        userimages = []
        
        for i in 0 ..< posts[postIndex].comments.count
        {
            var j = 0
            while(j < userimages.count)
            //for j in 0 ..< userimages.count
            {
                if userimages[j] == posts[postIndex].comments[i].object(forKey: "userimage") as! String
                {
                    break
                }
                else {
                    j += 1
                    continue
                }
            }
            if j == userimages.count
            {
                userimages.append(posts[postIndex].comments[i].object(forKey: "userimage") as! String)
            }
        }
        onlyPictures.reloadData()
        onlyPictures.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let tag = textField.tag
        posts[tag].comment = textField.text!
        feedtableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let tag = textField.tag
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone.current
        let currentDate = formatter.string(from: currentDateTime)
        let params = [
            "userid" : PreferenceHelper().getId(),
            "postid" : posts[tag].postid,
            "content" : textField.text!,
            "choice" : "2",
            "createat" : currentDate
            ] as [String : Any]        
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        Alamofire.request(DataUtils.APIURL + DataUtils.COMMUNITYPOST_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                
                debugPrint(response);
                
                if let data = response.result.value {
                    let json : [String:Any] = data as! [String : Any]
                    let result = json["status"] as? String
                    if result == "true"
                    {
                        self.posts[tag].commentcounts += 1
                        self.posts[tag].comment = ""
                        let date = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                        dateFormatter.timeZone = TimeZone.current
                        dateFormatter.locale = Locale.current
                        
                        let comment: NSDictionary = [
                            "userimage": PreferenceHelper().getUserImage()!,
                            "content": textField.text!,
                            "first_name": PreferenceHelper().getFirstName() ?? "",
                            "last_name": PreferenceHelper().getLastName() ?? "",
                            "createat": dateFormatter.string(from: date)
                        ]
                        self.posts[tag].comments.append(comment as NSDictionary)
                        self.feedtableView.reloadData()
                    }
                    else
                    {
                        let message = json["message"] as! String
                        DataUtils.messageShow(view: self, message: message, title: "")
                    }
                }
            })
        return true
        
    }
    
    @objc func postData(gesture: UIGestureRecognizer) {
        
        let viewcontroller = (UIStoryboard(name: "Community", bundle: nil).instantiateViewController(withIdentifier: "PostMessageViewController") as! PostMessageViewController)
        viewcontroller.viewIndex = 0
        viewcontroller.delegate = delegate
        viewcontroller.communityUsers = self.communityUsers
        viewcontroller.modalPresentationStyle = .overCurrentContext
        present(viewcontroller, animated: false, completion: nil)
    }
    @objc private func addPost(_ sender:UIButton) {
        // your code goes here
        let tag = sender.tag
        let viewcontroller = (UIStoryboard(name: "Community", bundle: nil).instantiateViewController(withIdentifier: "PostMessageViewController") as! PostMessageViewController)
        viewcontroller.viewIndex = tag
        viewcontroller.delegate = delegate
        viewcontroller.communityUsers = self.communityUsers
        viewcontroller.modalPresentationStyle = .overCurrentContext
        present(viewcontroller, animated: false, completion: nil)        
    }
    
    @objc private func playVideo(_ sender:UIButton) {
        let tag = sender.tag
        let url = URL(string: DataUtils.VIDEOURL + posts[tag].filename)!
        let playerVC = AVPlayerViewController()
        let player = AVPlayer(playerItem: AVPlayerItem(url:url))
        playerVC.player = player
        self.present(playerVC, animated: true, completion: nil)
    }
    
    @objc private func viewComment(_ sender:UIButton) {
        let tag = sender.tag
        
        posts[tag].showComment = !posts[tag].showComment
        self.feedtableView.reloadData()
    }
    
    @objc private func viewCommentMood(_ sender:UIButton) {
        let tag = sender.tag
        
        posts[tag].showComment = !posts[tag].showComment
        self.feedtableView.reloadData()
    }
    
    @objc private func showMoreComment(_ sender:UIButton) {
        let tag = sender.tag
        
        posts[tag].showMoreComment = !posts[tag].showMoreComment
        self.feedtableView.reloadData()
    }
    
    @objc func getPostLikeNotification(notification:Foundation.Notification) {
        let tag = notification.userInfo!["tag"] as! Int
        sendLikeEvent(tag)
    }
    
    @objc private func postLike(_ sender:UIButton) {
        let tag = sender.tag
        sendLikeEvent(tag)
    }
    
    func sendLikeEvent(_ tag: Int) {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone.current
        let currentDate = formatter.string(from: currentDateTime)
        let params = [
            "userid" : PreferenceHelper().getId(),
            "postid" : posts[tag].postid,
            "choice" : "3",
            "createat" : currentDate
            ] as [String : Any]
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        Alamofire.request(DataUtils.APIURL + DataUtils.COMMUNITYPOST_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                
                debugPrint(response);
                
                if let data = response.result.value {
                    let json : [String:Any] = data as! [String : Any]
                    let result = json["status"] as? String
                    if result == "true"
                    {
                        self.posts[tag].likecounts += 1
                        self.feedtableView.reloadData()
                    }
                    else
                    {
                        let message = json["message"] as! String
                        DataUtils.messageShow(view: self, message: message, title: "")
                    }
                }
            })
    }
    
    func createThumbnailOfVideoFromRemoteUrl(url: String) -> UIImage? {
        let asset = AVAsset(url: URL(string: url)!)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        //Can set this to improve performance if target size is known before hand
        //assetImgGenerate.maximumSize = CGSize(width,height)
        //let time = CMTimeMakeWithSeconds(1.0, 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            imageCache.setObject(thumbnail, forKey: url as NSString)
            return thumbnail
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(posts[indexPath.row].type)
        if indexPath.row == posts.count {
            return 80
        }
        if posts[indexPath.row].type == 5//.calluser
        {
            return 70
        }
        else if posts[indexPath.row].type == 0//.message
        {
            let width = UIScreen.main.bounds.width - 60
            let text = posts[indexPath.row].content
            let height = heightForView(text: text, font: UIFont(name: "Montserrat-Regular", size: 20)!, width: width)
            
            if posts[indexPath.row].showComment {
                let commentCount = posts[indexPath.row].comments.count
                if posts[indexPath.row].showMoreComment {
                    return 164 + 10 + 70 + CGFloat(150 * commentCount) + height - 20
                } else {
                    return 164 + 10 + 70 + CGFloat(150 * (commentCount > 2 ? 2 : commentCount) ) + height - 20
                }
                
            } else {
                return 179 + height - 20
            }

//            return UITableViewAutomaticDimension
        }
        else if posts[indexPath.row].type == 7//.question
        {
            return 180
        }
        else if posts[indexPath.row].type == 6//.postmessage
        {
            return 230
        }
        else if posts[indexPath.row].type <= 2//.image
        {
            let width = UIScreen.main.bounds.width - 60
            let text = posts[indexPath.row].content
            let height = heightForView(text: text, font: UIFont(name: "Montserrat-Regular", size: 20)!, width: width)
            
            if posts[indexPath.row].showComment {
                let commentCount = posts[indexPath.row].comments.count
//                return CGFloat(450 + commentCount * 160)
                if posts[indexPath.row].showMoreComment {
                    return 400 + 70 + CGFloat(150 * commentCount) + height - 20
                } else {
                    return 400 + 70 + CGFloat(150 * (commentCount > 2 ? 2 : commentCount) ) + height - 20
                }
            } else {
                return 400 + height - 20
            }
        }
        else if posts[indexPath.row].type == 3 // Health
        {
            let width = UIScreen.main.bounds.width - 60
            let text = posts[indexPath.row].content
            let height = heightForView(text: text, font: UIFont(name: "Montserrat-Regular", size: 20)!, width: width)
            
            if posts[indexPath.row].showComment {
                let commentCount = posts[indexPath.row].comments.count
//                return CGFloat(450 + commentCount * 160)
                if posts[indexPath.row].showMoreComment {
                    return 300 + 70 + CGFloat(150 * commentCount) + height - 20
                } else {
                    return 300 + 70 + CGFloat(150 * (commentCount > 2 ? 2 : commentCount) ) + height - 20
                }
            } else {
                return 320 + height - 20
            }
        }
        else if posts[indexPath.row].type == 4//.mood
        {
            if posts[indexPath.row].showComment {
                let commentCount = posts[indexPath.row].comments.count
//                return CGFloat(260 + commentCount * 160)
                if posts[indexPath.row].showMoreComment {
                    return 179 + 70 + CGFloat(150 * commentCount)
                } else {
                    return 179 + 70 + CGFloat(150 * (commentCount > 2 ? 2 : commentCount) )
                }
            } else {
                return 179
            }
        }
        else if posts[indexPath.row].type == 8 // Divider
        {
            return 20
        }
        else if posts[indexPath.row].type == 9 // Empty
        {
            return 100
        }
        else if posts[indexPath.row].type == 10 { // Fact Ads
            return UITableViewAutomaticDimension
        }
        else if posts[indexPath.row].type == 11 { // Static Ads
            return 310
        }
        else if posts[indexPath.row].type == 12 { // Video Ads
            return 210
        }
        else{
            return 0
        }
    }
}

extension FeedViewController : IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Feed")
    }
}

extension FeedViewController: OnlyPicturesDataSource {
    
    // ---------------------------------------------------
    // returns the total no of pictures
    
    func numberOfPictures() -> Int {
        return userimages.count//posts[userPictureIndex].pictures.count//pictures.count
    }
    
    // ---------------------------------------------------
    // returns the no of pictures should be visible in screen.
    // In above preview, Left & Right formats are example of visible pictures, if you want pictures to be shown without count, remove this function, it's optional.
    
    func visiblePictures() -> Int {
        return 5
    }
    
    
    // ---------------------------------------------------
    // return the images you want to show. If you have URL's for images, use next function instead of this.
    // use .defaultPicture property to set placeholder image. This only work with local images. for URL's images we provided imageView instance, it's your responsibility to assign placeholder image in it. Check next function.
    // onlyPictures.defaultPicture = #imageLiteral(resourceName: "defaultProfilePicture")
    /*
    func pictureViews(index: Int) -> UIImage {
        return UIImage(named: posts[userPictureIndex].pictures[index])!//pictures[index]
    }
    */
    
    // ---------------------------------------------------
    // If you do have URLs of images. Use below function to have UIImageView instance and index insted of 'pictureViews(index: Int) -> UIImage'
    // NOTE: It's your resposibility to assign any placeholder image till download & assignment completes.
    // I've used AlamofireImage here for image async downloading, assigning & caching, Use any library to allocate your image from url to imageView.
    
    func pictureViews(_ imageView: UIImageView, index: Int) {                        
        // Use 'index' to receive specific url from your collection. It's similar to indexPath.row in UITableView.
        if userimages[index] != "" //posts[userPictureIndex].pictures[index] != ""
        {
            let url = URL(string: DataUtils.PROFILEURL + userimages[index])
            //imageView.image = #imageLiteral(resourceName: "defaultProfilePicture")   // placeholder image
            //imageView.af_setImage(withURL: url!)
            imageView.kf.setImage(with: url)
        }
        else {
            let image = UIImage(named: "Intersection 1")
            imageView.image = image
            //imageView.contentMode = .center
        }
        
    }
}
