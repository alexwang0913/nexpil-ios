//
//  HealthConditionModelView.swift
//  Nexpil
//
//  Created by mac on 8/27/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

protocol HealthConditionModelViewDelegate {
    func healConditionModelViewDismiss()
}

class HealthConditionModelView: UIView{
    
    @IBOutlet weak var backUV: UIView!
    @IBOutlet weak var searchConditionTextField: UITextField!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UIView!
    @IBOutlet weak var conditionTableView: UITableView!
    
    var delegate: HealthConditionModelViewDelegate?
    var searchResults: [MedicalCondition] = []
    var conditions: [String] = []
    
    let cellReuseIdentifier = "searchCell"
    override func awakeFromNib() {
        backUV.setPopItemViewStyle(radius: 30, title: .large)
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        searchTableView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        searchTableView.layer.shadowOpacity = 0.2
        searchTableView.layer.shadowRadius = 3.0
        searchTableView.layer.masksToBounds = false
        searchTableView.layer.cornerRadius = 20
        
        conditionTableView.delegate = self
        conditionTableView.dataSource = self
        conditionTableView.register(UINib(nibName: "HealthConditionTableViewCell", bundle: nil), forCellReuseIdentifier: "healthConditionTableViewCell")
        
        searchBar.isHidden = true
        searchTableView.isHidden = true
    }
    
    @IBAction func closeButtonClick(_ sender: Any) {
        self.delegate?.healConditionModelViewDismiss()
    }
    
    @IBAction func onChangeSearchCondition(_ sender: Any) {
        let searchKeyword = searchConditionTextField.text as! String
        
        if searchKeyword != "" {
            let urlString = DataUtils.APIURL + DataUtils.MEDICAL_CONDITION_URL + "?Name=\(searchKeyword)&choice=0"
            let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
            let session = URLSession.shared
            let task = session.dataTask(with: url!, completionHandler: { [unowned self] (data, response, error) in
                guard error == nil else { return }
                guard let data = data else { return }
                let decoder = JSONDecoder()
                self.searchResults = try! decoder.decode([MedicalCondition].self, from: data)
                
                DispatchQueue.main.async { [unowned self] in
                    self.searchTableView.reloadData()
                    self.searchTableView.isHidden = false
                    self.searchBar.isHidden = false
                }
            })
            task.resume()
        } else {
            searchBar.isHidden = true
            searchTableView.isHidden = true
        }
    }
}

extension HealthConditionModelView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchTableView {
            return searchResults.count
        } else if tableView == conditionTableView {
            return conditions.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView ==  searchTableView {
            let cell = searchTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
            cell.textLabel?.text = "  " + searchResults[indexPath.row].name
            cell.textLabel?.font = UIFont(name: "Montserrat-Regular", size: 20)
            return cell
        } else {
            let cell = conditionTableView.dequeueReusableCell(withIdentifier: "healthConditionTableViewCell", for: indexPath) as! HealthConditionTableViewCell
            cell.conditionLabel.text = conditions[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == searchTableView {
            conditions.append(searchResults[indexPath.row].name)
            conditionTableView.reloadData()
            
            searchConditionTextField.text = ""
            searchTableView.isHidden = true
            searchBar.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == conditionTableView {
            return 74
        }
        return 44
    }
}
