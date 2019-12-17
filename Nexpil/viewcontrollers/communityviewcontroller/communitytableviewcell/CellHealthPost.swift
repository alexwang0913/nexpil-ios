//
//  CellHealthPost.swift
//  Nexpil
//
//  Created by mac on 8/23/19.
//  Copyright © 2019 Admin. All rights reserved.
//
import UIKit
import OnlyPictures

class CellHealthPost: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var like: UIButton!
    @IBOutlet weak var likecounts: UILabel!
    @IBOutlet weak var comment: UIButton!
    @IBOutlet weak var commentcounts: UILabel!
    @IBOutlet weak var commentphoto: UIImageView!
    @IBOutlet weak var lblHealthType: UILabel!
    @IBOutlet weak var lblHealthValue: UILabel!
    @IBOutlet weak var lblSharedUser: UILabel!
    @IBOutlet weak var moreCommentButton: UIButton!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var onlypictures: OnlyHorizontalPictures!
    @IBOutlet weak var commentTableViewTopMargin: NSLayoutConstraint!
    @IBOutlet weak var commentViewHeight: NSLayoutConstraint!
    
    var commentList: [NSDictionary] = []
    var m_tag: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.commentTableView.dequeueReusableCell(withIdentifier: "myCommentTableViewCell") as! MyCommentTableViewCell
        cell.m_tag = self.m_tag
        cell.commontInit(commentList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
