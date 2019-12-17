//
//  NewMoodViewController.swift
//  Nexpil
//
//  Created by Guang on 11/5/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class NewMoodViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moodView: GradientView!
    @IBOutlet weak var moodIcon: UIImageView!
    @IBOutlet weak var moodTitle: UILabel!
    @IBOutlet weak var moodDescription: UILabel!
    
    var dateInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateDateLabel()
    }
    
    private func updateDateLabel() {
        let date = GlobalManager.GetToday().addingTimeInterval(TimeInterval(3600 * 24 * dateInterval))
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        dateLabel.text = formatter.string(from: date)
        
        // Get Mood data
        let strDate = DataManager().getStrDate(date: date)
        let datas = DataManager().fetchMoodQueryDate(strDate: strDate)
        
        if datas.count > 0 {
            let mood = datas[0] as! Mood
            let feelingStrList = ["Very Sad", "Sad", "Neutral", "Happy", "Very Happy"]
            let feeling = Int(truncatingIfNeeded: mood.feeling)
            moodIcon.image =  UIImage(named: feelingStrList[feeling])
            moodTitle.text = feelingStrList[feeling]
            moodDescription.text = mood.notes
            moodView.isHidden = false
        } else {
            moodView.isHidden = true
        }
    }
    

    @IBAction func closeButtonClick(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func nextDateButtonClick(_ sender: Any) {
        dateInterval += 1
        updateDateLabel()
    }
    
    @IBAction func prevDateButtonClick(_ sender: Any) {
        dateInterval -= 1
        updateDateLabel()
    }
    
    @IBAction func addButtonClick(_ sender: Any) {
        weak var pvc = self.presentingViewController
        self.dismiss(animated: false, completion: {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewMoodAmdFirstViewController") as! NewMoodAmdFirstViewController
            vc.modalPresentationStyle = .overFullScreen
            pvc?.present(vc, animated: false, completion: nil)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Global_ShowFrostGlass(self.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Global_HideFrostGlass()
    }
}
