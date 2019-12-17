//
//  MessageTableViewCell.swift
//  Nexpil
//
//  Created by Admin on 4/11/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import OnlyPictures

class MessageTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var messageview: UIView!
    
    @IBOutlet weak var likebtn: UIButton!
    @IBOutlet weak var likecnt: UILabel!
    @IBOutlet weak var commentbtn: UIButton!
    @IBOutlet weak var commentcnt: UILabel!
    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var onlypictures: OnlyHorizontalPictures!
    @IBOutlet weak var moreCommentButton: UIButton!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentTableViewTopMargin: NSLayoutConstraint!
    @IBOutlet weak var commentViewHeight: NSLayoutConstraint!
    
    var commentList: [NSDictionary] = []
    var commentContentHeight: CGFloat?
    var m_tag: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        commentTableView.delegate = self
        commentTableView.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.commentTableView.dequeueReusableCell(withIdentifier: "myCommentTableViewCell") as! MyCommentTableViewCell
        cell.commontInit(commentList[indexPath.row])
        cell.m_tag = self.m_tag
        commentContentHeight = cell.content.bounds.size.height
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120 + (commentContentHeight! - 15)
    }
}
