//
//  NewMoodAmdThirdViewController.swift
//  Nexpil
//
//  Created by Guang on 11/5/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class NewMoodAmdThirdViewController: UIViewController {

    @IBOutlet weak var feelingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noteTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateDateLabel()
        feelingLabel.text = MoodDataManager.GetFeelingString()
    }
    @IBAction func closeButtonClick(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func doneButtonClick(_ sender: Any) {
        MoodDataManager.Note = noteTF.text!
        if !MoodDataManager.SendData() {
            DataUtils.messageShow(view: self, message: "Failed to add data", title: "")
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    func updateDateLabel() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        dateLabel.text = formatter.string(from: MoodDataManager.Date)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Global_ShowFrostGlass(self.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Global_HideFrostGlass()
    }
}
