//
//  InformationCardMedicationSelectViewController.swift
//  Nexpil
//
//  Created by Admin on 21/11/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

import UIKit

class InformationCardMedicationSelectViewController: UIViewController,ShadowDelegate1,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    @IBOutlet weak var drugTextFieldHeight: NSLayoutConstraint!
    
    @IBOutlet weak var medicationNameCard: InformationCardEditable1!
    @IBOutlet weak var doneButton: NPButton!
    @IBOutlet weak var imageHelp: UIImageView!
    @IBOutlet weak var doneButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var shadowviewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var medicationTitle: UILabel!
    @IBOutlet weak var labelTopHeight: NSLayoutConstraint!
    
    let center = NotificationCenter.default
    var keyboardHeight: CGFloat?
    var originalHeight: CGFloat?
    var originalTopHeight: CGFloat?
    
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var searchTable: UITableView!
    let cellReuseIdentifier = "cell"
    
    @IBOutlet weak var shadowView: UIView!
    public var delegate: UIViewController!
    
    var results = [DrugName]()
    
    var visualEffectView:VisualEffectView?
    
    var autoCompleteCharacterCount = 0

     let screensize = UIScreen.main.bounds.size
    var timer = Timer()
    
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        if self.medicationNameCard.textView.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input medication name", title: "")
            return
        }
        DispatchQueue.main.async { [unowned self] in            
            DataUtils.setMedicationName(name: self.medicationNameCard.textView.text!)
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let medicationController = storyBoard.instantiateViewController(withIdentifier: "InformationCardEditDosageViewController") as! InformationCardEditDosageViewController
            medicationController.delegate = self.delegate
            self.navigationController?.pushViewController(medicationController, animated: true)
        }
    }

    override func viewDidLoad() {        
        //self.doneButtonConstraint = doneButtonBottomConstraint
        super.viewDidLoad()
       
        medicationNameCard.showHideButton.setImage(UIImage(named: "Search Icon"), for: .normal)
        medicationNameCard.identifier.text = ""
        medicationNameCard.showHideButton.setTitle("", for: .normal)
        medicationNameCard.showHideButton.isUserInteractionEnabled = false
        medicationNameCard.textView.isSecureTextEntry = false
        medicationNameCard.textView.delegate = self
        medicationNameCard.textView.placeholder = "Search Drug"
        medicationNameCard.textView.autocapitalizationType = UITextAutocapitalizationType.words
        medicationTitle.text = "What is the drug's name?"
        imageHeight.constant = (screensize.width * 72.53) / 100
        labelTopHeight.constant = (((screensize.width * 72.53) / 100) + 29)

        originalHeight = doneButtonBottomConstraint.constant
        visualEffectView = self.view.backgroundBlur(view: self.view)
        originalTopHeight = labelTopHeight.constant
        
        //self.medicationNameCard.textView.placeholder = "Glipizide"
        self.searchTable.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        medicationNameCard.textView.addTarget(self, action: #selector(updateText), for: UIControlEvents.editingChanged)
        self.searchTable.tableFooterView = UIView()
        self.searchTable.alwaysBounceVertical = false
        medicationNameCard.view.layer.shadowOpacity = 0.0
        medicationNameCard.layer.cornerRadius = 20
        medicationNameCard.layer.masksToBounds = true
        shadowView.clipsToBounds = false
        shadowView.layer.cornerRadius = 20

        shadowView.addShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.16, x: 0, y: 3, blur: 6)
        searchTable.layer.cornerRadius = 20
        searchTable.layer.masksToBounds = true
        visualEffectView = self.view.backgroundBlur(view: self.view)
        medicationNameCard.textView.autocorrectionType = .no
       // medicationNameCard.textView.placeholder = ""
    }
    override func viewDidAppear(_ animated: Bool) {
        center.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.searchTable.isHidden = true
        if medicationNameCard.textView.text?.trimmingCharacters(in: .whitespaces) == ""
        {
            medicationNameCard.identifier.text = ""
            medicationTitle.text = "What is the drug's name?"
            //textField.textAlignment = .center
            self.shadowviewHeight.constant = 64
            self.drugTextFieldHeight.constant = 64
        }
        else
        {
            medicationNameCard.identifier.text = "Drug Name"
            medicationTitle.text = "What's the drug's name?"
            // medicationNameCard.textAlignment = .left
            self.shadowviewHeight.constant = 83
            self.drugTextFieldHeight.constant = 83
        }
        self.lineView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        //cell.textLabel?.font = UIFont(name:"Montserrat Medium",size:16)
        cell.textLabel?.text = "  " + results[indexPath.row].DrugName.capitalized
        cell.textLabel?.font = UIFont(name: "Montserrat-Regular", size: 20)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let str = results[indexPath.row].DrugName.lowercased()
        medicationNameCard.textView.text = str.prefix(1).uppercased() + str.dropFirst()
        self.searchTable.isHidden = true
        if medicationNameCard.textView.text?.trimmingCharacters(in: .whitespaces) == ""
        {
            medicationNameCard.identifier.text = ""
            medicationTitle.text = "What is the drug's name?"
            //textField.textAlignment = .center
            self.shadowviewHeight.constant = 64
            self.drugTextFieldHeight.constant = 64
        }
        else
        {
            medicationNameCard.identifier.text = "Drug Name"
            medicationTitle.text = "What's the drug's name?"
            // medicationNameCard.textAlignment = .left
            self.shadowviewHeight.constant = 83
            self.drugTextFieldHeight.constant = 83
        }
        self.lineView.isHidden = true
    }

    @objc func updateText() {
        let text = medicationNameCard.textView.text ?? ""
        if text != ""
        {
            self.results.removeAll()
            searchTable.reloadData()
            searchTable.isHidden = false
            self.shadowviewHeight.constant = 205.5
            self.lineView.isHidden = false
           // shadowView.isHidden = false
            getSuggestions(term: text)
        } else {
            searchTable.isHidden = true
            self.shadowviewHeight.constant = 83
        }
    }
    
    func getSuggestions(term: String) {
        self.results.removeAll()
        let urlString = DataUtils.APIURL + DataUtils.PRODUCT_URL + "?Name=\(term)&choice=0"
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: { [unowned self] (data, response, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            let decoder = JSONDecoder()
            self.results = try! decoder.decode([DrugName].self, from: data)
            
            DispatchQueue.main.async { [unowned self] in
                //fghj
                if self.results.count > 0
                {

                }
                self.searchTable.reloadData()
            }
        })
        task.resume()
    }
    override func viewDidDisappear(_ animated: Bool) {
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if medicationNameCard.textView.text?.trimmingCharacters(in: .whitespaces) == ""
        {
            medicationNameCard.identifier.text = ""
            medicationTitle.text = "What is the drug's name?"
            //textField.textAlignment = .center
            self.shadowviewHeight.constant = 64
            self.drugTextFieldHeight.constant = 64
        }
        else
        {
            medicationNameCard.identifier.text = "Drug Name"
            medicationTitle.text = "What's the drug's name?"
            // medicationNameCard.textAlignment = .left
            self.shadowviewHeight.constant = 83
            self.drugTextFieldHeight.constant = 83
        }
       // self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       // self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillDisappear(animated)
        
        medicationNameCard.textView.resignFirstResponder()
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification)
    {
        
        keyboardHeight = (notification.userInfo?["UIKeyboardBoundsUserInfoKey"] as! CGRect).height
        doneButtonBottomConstraint.constant = self.originalHeight! + self.keyboardHeight!
        imageHeight.constant = 10
        imageHelp.isHidden = true
        labelTopHeight.constant = 30
        medicationNameCard.identifier.text = "Drug Name"
        medicationTitle.text = "What's the drug's name?"
        // medicationNameCard.textAlignment = .left
        self.shadowviewHeight.constant = 83
        self.drugTextFieldHeight.constant = 83
        medicationNameCard.showHideButton.isHidden = true
//        textField.textAlignment = .left
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        doneButtonBottomConstraint.constant = self.originalHeight!
        imageHeight.constant = (screensize.width * 72.53) / 100
        searchTable.isHidden = true
//        self.shadowviewHeight.constant = 64
//        self.drugTextFieldHeight.constant = 64
        self.lineView.isHidden = true
        //shadowView.isHidden = true
        imageHelp.isHidden = false
        labelTopHeight.constant = originalTopHeight!
        if medicationNameCard.textView.text?.trimmingCharacters(in: .whitespaces) == ""
        {
            medicationNameCard.identifier.text = ""
            medicationTitle.text = "What is the drug's name?"
            //textField.textAlignment = .center
            self.shadowviewHeight.constant = 64
            self.drugTextFieldHeight.constant = 64
        }
        else
        {
            medicationNameCard.identifier.text = "Drug Name"
            medicationTitle.text = "What's the drug's name?"
           // medicationNameCard.textAlignment = .left
            self.shadowviewHeight.constant = 83
            self.drugTextFieldHeight.constant = 83
        }
        medicationNameCard.showHideButton.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    @objc func showCloseAddMedicationCardViewController()
    {
        self.view.addSubview(visualEffectView!)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CloseAddMedicationViewController") as! CloseAddMedicationViewController
        //viewController.tabBar.roundCorners([.topLeft, .topRight], radius: 10)
        viewController.delegate = self
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: false, completion: nil)
    }
    func removeShadow(root: Bool) {
        visualEffectView?.removeFromSuperview()
        if root == true
        {
            delegate.dismiss(animated: false, completion: nil)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }

    func formatSubstring(subString: String) -> String {
        let formatted = String(subString.dropLast(autoCompleteCharacterCount)).lowercased().capitalized //5
        return formatted
    }

    func resetValues() {
        autoCompleteCharacterCount = 0
        medicationNameCard.textView.text = ""
    }
    
    func searchAutocompleteEntriesWIthSubstring(substring: String) {
        let userQuery = substring
        let suggestions = getAutocompleteSuggestions(userText: substring) //1
        
        if suggestions.count > 0 {
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in //2
                let autocompleteResult = self.formatAutocompleteResult(substring: substring, possibleMatches: suggestions) // 3
                self.putColourFormattedTextInTextField(autocompleteResult: autocompleteResult, userQuery : userQuery) //4
                self.moveCaretToEndOfUserQueryPosition(userQuery: userQuery) //5
            })
        } else {
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in //7
                self.medicationNameCard.textView.text = substring
            })
            autoCompleteCharacterCount = 0
        }
    }
    
    
    func getAutocompleteSuggestions(userText: String) -> [String]{
        var possibleMatches: [String] = []
        for item in results { //2
            let myString:NSString! = item.DrugName as NSString
            let substringRange :NSRange! = myString.range(of: userText)
            
            if (substringRange!.location == 0)
            {
                possibleMatches.append(item.DrugName)
            }
        }
        return possibleMatches
    }
    
    func putColourFormattedTextInTextField(autocompleteResult: String, userQuery : String) {
        let colouredString: NSMutableAttributedString = NSMutableAttributedString(string: userQuery + autocompleteResult)
        colouredString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.green, range: NSRange(location: userQuery.count,length:autocompleteResult.count))
        self.medicationNameCard.textView.attributedText = colouredString
    }
    func moveCaretToEndOfUserQueryPosition(userQuery : String) {
        if let newPosition = self.medicationNameCard.textView.position(from: self.medicationNameCard.textView.beginningOfDocument, offset: userQuery.count) {
            self.medicationNameCard.textView.selectedTextRange = self.medicationNameCard.textView.textRange(from: newPosition, to: newPosition)
        }
        let selectedRange: UITextRange? = medicationNameCard.textView.selectedTextRange
        medicationNameCard.textView.offset(from: medicationNameCard.textView.beginningOfDocument, to: (selectedRange?.start)!)
    }
    func formatAutocompleteResult(substring: String, possibleMatches: [String]) -> String {
        var autoCompleteResult = possibleMatches[0]
        autoCompleteResult.removeSubrange(autoCompleteResult.startIndex..<autoCompleteResult.index(autoCompleteResult.startIndex, offsetBy: substring.count))
        autoCompleteCharacterCount = autoCompleteResult.count
        return autoCompleteResult
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func crossButton(_ sender: UIButton) {
        self.view.addSubview(visualEffectView!)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CloseAddMedicationViewController") as! CloseAddMedicationViewController
        viewController.delegate = self
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: false, completion: nil)
    }
}
extension NSMutableAttributedString {
    
    func setColor(color: UIColor, forText stringValue: String) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
    }
    
}
