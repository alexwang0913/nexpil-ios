//
//  AsNeededHistoryTableViewCell.swift
//  Nexpil
//
//  Created by mac on 9/7/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class AsNeededHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backView: GradientView!
    
    var histories: [[String: Any]] = []
//    var timeHistories: [String] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tableView.delegate = self
        tableView.dataSource = self
        
        backView.viewShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func commonInit() {
        tableView.reloadData()
    }
    public func setColor(_ color: UIColor){        
        backView.topColor = color
        backView.bottomColor = color
    }
}

extension AsNeededHistoryTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let history = self.histories[row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AsNeededHistoryTableViewItemCell", for: indexPath) as! AsNeededHistoryTableViewItemCell
        
        let amount = history["amount"] as! String
        let timediff = (history["timediff"] as! String).components(separatedBy: ":")
        var timeMsg = ""
        if Int(timediff[0])! > 0 {
            timeMsg += "\(Int(timediff[0])!) Hours "
        } else if Int(timediff[1])! > 0 {
            timeMsg += "\(Int(timediff[1])!) Mins "
        } else if Int(timediff[2])! > 0 {
            timeMsg += "\(Int(timediff[2])!) Seconds "
        }
        timeMsg += "Ago"
        
        cell.historyContent.text = "\(amount) - \(timeMsg)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    
}

class AsNeededHistoryTableViewItemCell: UITableViewCell {
    
    @IBOutlet weak var historyContent: UILabel!
    
}
