//
//  SubDetails110ViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/28.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol SubDetails110ViewControllerDelegate: class {
    func didTapButtonAddWithSubDetails110ViewController()
}

class SubDetails110ViewController: UIViewController{

    weak var delegate:SubDetails110ViewControllerDelegate?

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonLabel: UILabel!
    
    var arrayList = NSArray()
    var manager = DataManager()
    @IBOutlet weak var buttonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initMainView()
        setInfo(index: 7)
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
        self.delegate?.didTapButtonAddWithSubDetails110ViewController()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.fetchLipidPanel(index: "HDL")
    }

    func initMainView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    

    // insert
    func insertLipidPanel(date: Date, value: NSInteger, index: String) {
        SVProgressHUD.show()
        let retult = manager.insertLipidPanel(date: date, value: value, index: index)
        
        SVProgressHUD.dismiss()
        if retult == true {
            self.fetchLipidPanel(index: index)
        } else {
            
        }
    }
    
    // fetch
    func fetchLipidPanel(index: String) {
        SVProgressHUD.show()
        
        let array = manager.fetchLipidPanelGetAllYearData(index: index)
        SVProgressHUD.dismiss()
        if array.count > 0 {
            arrayList = array
            collectionView.reloadData()
        }
    }
    
    func loadAlertController(message: String) {
        let alert = UIAlertController(title: message,
                                      message: nil,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
extension SubDetails110ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayList.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIScreen.main.bounds.size.width >= 414.0{
            return CGSize(width: 353, height: 820)
        }
        return CGSize(width: view.frame.width, height: 820)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dicList = arrayList[indexPath.row] as! NSDictionary
        collectionView.register(UINib(nibName: "LipidPanelHDLCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LipidPanelHDLCollectionViewCell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LipidPanelHDLCollectionViewCell", for: indexPath) as! LipidPanelHDLCollectionViewCell
        cell.setInfo(dic: dicList)
        cell.delegate = self
        cell.tag = indexPath.item
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
extension SubDetails110ViewController:LipidPanelHDLCollectionViewCellDelegate{
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
    
    
}
