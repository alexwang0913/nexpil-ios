//
//  NewMoodAmdFirstViewController.swift
//  Nexpil
//
//  Created by Guang on 11/5/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class NewMoodAmdFirstViewController: UIViewController {
    
    @IBOutlet weak var midIV: UIImageView!
    @IBOutlet weak var midLB: UILabel!
    @IBOutlet weak var leftIV: UIImageView!
    @IBOutlet weak var leftLB: UILabel!
    @IBOutlet weak var rightIV: UIImageView!
    @IBOutlet weak var rightLB: UILabel!
    @IBOutlet weak var rightMoodBtn: UIImageView!
    @IBOutlet weak var leftMoodBtn: UIImageView!
    
    let moodList = ["Very Sad", "Sad", "Neutral", "Happy", "Very Happy"]
    var moodIdx = 2

    override func viewDidLoad() {
        super.viewDidLoad()
        updateMood()
        
        leftMoodBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(prevMood)))
        rightMoodBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextMood)))
    }
    
    private func updateMood() {
        midIV.image = UIImage(named: moodList[moodIdx])
        midLB.text = moodList[moodIdx]
        if moodIdx == 0 {
            leftIV.isHidden = true
            leftLB.isHidden = true
        } else {
            leftIV.image = UIImage(named: moodList[moodIdx - 1])
            leftLB.text = moodList[moodIdx - 1]
        }
        if moodIdx == 4 {
            rightIV.isHidden = true
            rightLB.isHidden = true
        } else {
            rightIV.image = UIImage(named: moodList[moodIdx + 1])
            rightLB.text = moodList[moodIdx + 1]
        }
    }
    
    @objc func nextMood() {
        if moodIdx == 4 {
            return
        }
        moodIdx += 1
        updateMood()
    }
    
    @objc func prevMood() {
        if moodIdx == 0 {
            return
        }
        moodIdx -= 1
        updateMood()
    }
    

    @IBAction func closeButtonClick(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func gotoNextStep(_ sender: Any) {
        MoodDataManager.Feeling = moodIdx
        weak var pvc = self.presentingViewController
        self.dismiss(animated: false, completion: {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewMoodAmdSecondViewController") as! NewMoodAmdSecondViewController
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
