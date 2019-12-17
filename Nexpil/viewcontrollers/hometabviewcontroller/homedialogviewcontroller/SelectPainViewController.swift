//
//  SelectPainViewController.swift
//  Nexpil
//
//  Created by Admin on 4/19/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

import fluid_slider

protocol DialogClose {
    func closeDialog()
    func closeDialog1()
}

class SelectPainViewController: UIViewController,DialogClose {
    
    @IBOutlet weak var medicationname: UILabel!
    @IBOutlet var lblPainScores: [UILabel]!
    @IBOutlet var lblPainDescs: [UILabel]!
    @IBOutlet var imgFaces: [UIImageView]!
    @IBOutlet weak var imgGreenCircle: UIImageView!
    @IBOutlet weak var imgGreyCircle: UIImageView!
    @IBOutlet weak var lblSelectedScore: UILabel!
    @IBOutlet weak var prescription: UILabel!
    @IBOutlet weak var facePanel: UIView!
    
    var mymedication = MyMedication()
    var quantityText = ""
    
    var delegate:DialogClose?
    var severeString = ""
    
    var m_LevelNums = ["0 - 1", "2 - 3", "4 - 5", "6 - 7", "8 - 9"]
    var m_LevelTxts = ["Very Sad", "Sad", "Neutral", "Happy", "Very Happy"]
    var m_selectedLevel = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imgGreenCircle.layer.borderColor = UIColor.init(hexString: "#43D3E3")?.cgColor
        imgGreenCircle.layer.borderWidth = 2
        imgGreenCircle.layer.masksToBounds = false
        imgGreenCircle.layer.cornerRadius = 15
        
        imgGreyCircle.layer.borderColor = UIColor.init(hexString: "#CCCCCC")?.cgColor
        imgGreyCircle.layer.borderWidth = 2
        imgGreyCircle.layer.masksToBounds = false
        imgGreyCircle.layer.cornerRadius = 15
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        facePanel.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        facePanel.addGestureRecognizer(swipeRight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Global_ShowFrostGlass(self.view)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Global_HideFrostGlass()
    }
    
    func updatePainFaces(){
        let preview = m_selectedLevel - 1
        if preview < 0 {
            lblPainDescs[0].text = ""
            lblPainScores[0].text = ""
            imgFaces[0].image = nil
        } else {
            lblPainDescs[0].text = m_LevelTxts[preview]
            lblPainScores[0].text = m_LevelNums[preview]
            imgFaces[0].image = UIImage(named: "feel_\(preview)")
        }
        
        lblPainDescs[1].text = m_LevelTxts[m_selectedLevel]
        lblPainScores[1].text = m_LevelNums[m_selectedLevel]
        imgFaces[1].image = UIImage(named: "feel_\(m_selectedLevel)")
        
        let next = m_selectedLevel + 1
        if next > 4 {
            lblPainDescs[2].text = ""
            lblPainScores[2].text = ""
            imgFaces[2].image = nil
        } else {
            lblPainDescs[2].text = m_LevelTxts[next]
            lblPainScores[2].text = m_LevelNums[next]
            imgFaces[2].image = UIImage(named: "feel_\(next)")
        }
    }
    
    @IBAction func OnPainScore(_ btn: UIButton){
        
        if m_selectedLevel == 0 && btn.tag == -1 {
            return
        }
        
        if m_selectedLevel == 4 && btn.tag == 1 {
            return
        }
        
        m_selectedLevel += btn.tag
        updatePainFaces()
    }
    
    @IBAction func onClose(){
        self.dismiss(animated: false, completion: {
            self.delegate?.closeDialog()
        })
    }
    
    @IBAction func onNext(){
        lblSelectedScore.text = m_LevelNums[m_selectedLevel] + " " + m_LevelTxts[m_selectedLevel]
        imgGreenCircle.image = UIImage(named: "icon_complete")
        imgGreenCircle.layer.borderWidth = 0
        imgGreenCircle.backgroundColor = UIColor.clear
        imgGreenCircle.layer.cornerRadius = 0
        imgGreenCircle.frame = CGRect(x: 91, y: 94, width: 47, height: 47)
        
        let viewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "SelectTimeViewController") as! SelectTimeViewController
        
        viewController.mymedication = mymedication
        viewController.delegate = self
        viewController.quantity = quantityText
        viewController.painScore = severeString
        viewController.m_painScore = lblSelectedScore!.text!
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: false, completion: nil)
    }
    
    func closeDialog1() {
        dismiss(animated: false, completion: {
            self.delegate?.closeDialog()
        })
    }
    
    func closeDialog() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        medicationname.text = mymedication.medicationname + " - " + mymedication.strength
        prescription.text = "(\(GlobalManager.capitalizeFirstLetters(mymedication.directions)))"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == .right{
            if m_selectedLevel == 0 {
                return
            }
            m_selectedLevel -= 1
            updatePainFaces()
        } else if gesture.direction == .left {
            if m_selectedLevel == 4 {
                return
            }
            m_selectedLevel += 1
            updatePainFaces()
        }
    }
}
