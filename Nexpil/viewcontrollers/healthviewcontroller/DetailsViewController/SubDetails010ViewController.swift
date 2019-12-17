//
//  SubDetails010ViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/28.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol SubDetails010ViewControllerDelegate: class {
    func didTapButtonAddWithSubDetails010ViewController()
}

class SubDetails010ViewController: UIViewController {

    weak var delegate:SubDetails010ViewControllerDelegate?
    
    var arrayList = NSArray()
    var manager = DataManager()
    
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initMainView()
        setInfo(index: 1)
        buttonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
    }
    func setInfo(index: NSInteger) {
        let colorBule   = #colorLiteral(red: 0.2773378491, green: 0.5805652142, blue: 0.9156668782, alpha: 1)//"397ee3"
        let colorPurple = #colorLiteral(red: 0.2866193056, green: 0.2258678973, blue: 0.8887504935, alpha: 1)//"4939e3"
        let colorSky    = #colorLiteral(red: 0.22498703, green: 0.8181471229, blue: 0.8770048022, alpha: 1)//"39d3e3"
        
        var strTitle = ""
        var strColor = UIColor.red
        
        if index == 0 {
            strTitle = "Measurements"
            strColor = colorBule
            
        } else if index == 1 {
            strTitle = "Measurements"
            strColor = colorPurple
            
        } else if index == 2 {
            strTitle = "Measurements"
            strColor = colorSky
            
        } else if index == 3 {
            strTitle = "Mood"
            strColor = colorBule
            
            //        } else if index == 4 {
            //            strTitle = "Mood"
            //            strColor = colorBule
            
        } else if index == 5 {
            strTitle = "Weight"
            strColor = colorPurple
            
        } else if index == 6 {
            strTitle = "Measurements"
            strColor = colorSky
            
        } else if index == 7 {
            strTitle = "Numbers"
            strColor = colorPurple
            
        } else if index == 8 {
            strTitle = "Numbers"
            strColor = colorBule
            
        }
        
        buttonLabel.text = "Add " + strTitle
        buttonView.backgroundColor = strColor//UIColor.init(hexString: strColor)
    }
    @objc func handleTapGesture(){
        self.delegate?.didTapButtonAddWithSubDetails010ViewController()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.fetchBloodPressure()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func initMainView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    


    

    // MARK - insert
    func insertBloodPressurel(date: Date, time: String, timeIndex: String, value1: NSInteger, value2: NSInteger) {
        SVProgressHUD.show()
        let retult = manager.insertBloodPressure(date: date, time: time, timeIndex: timeIndex, value1: value1, value2: value2)
        
        SVProgressHUD.dismiss()
        if retult == true {
            self.fetchBloodPressure()
        } else {
            
        }
        
    }
    
    func fetchBloodPressure() {
        SVProgressHUD.show()
        
        let array = manager.fetchBloodPressureGetAllDaysData()
        
        SVProgressHUD.dismiss()
        if array.count > 0 {
            arrayList = array
            collectionView.reloadData()
        }
        
    }
}
extension SubDetails010ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrayList.count > 0 {
            return arrayList.count
        }
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIScreen.main.bounds.size.width >= 414.0{
            return CGSize(width: 353, height: 540)
        }
        return CGSize(width: view.frame.width, height: 540)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        collectionView.register(UINib(nibName: "BloodPressureDayCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BloodPressureDayCollectionViewCell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BloodPressureDayCollectionViewCell", for: indexPath) as! BloodPressureDayCollectionViewCell
        if arrayList.count > 0 {
            let dicList = arrayList[indexPath.item] as! NSDictionary
            cell.setInfo(dic: dicList)
            cell.delegate = self
            cell.tag = indexPath.item
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
extension SubDetails010ViewController:BloodPressureDayCollectionViewCellDelegate{
    func forwordBtnClicked(_ sender: Any, index: Int) {
        if arrayList.count-1 > index{
            let indexpath = IndexPath(item: index+1, section: 0)
            collectionView.scrollToItem(at: indexpath, at: .centeredHorizontally, animated: true)
        }
        
    }
    
    func backBtnClicked(_ sender: Any, index: Int) {
        if  index > 0{
            let indexpath = IndexPath(item: index-1, section: 0)
            collectionView.scrollToItem(at: indexpath, at: .centeredHorizontally, animated: true)
        }
    }
    
    
    func didTapButtonBloodGlucoseDayCollectionViewCell(index: NSInteger, sendDic: NSDictionary) {
        //self.delegate?.didTapButtonAddWithSubDetails010ViewController(index: index, sendDic: sendDic)
    }
    
    
}
