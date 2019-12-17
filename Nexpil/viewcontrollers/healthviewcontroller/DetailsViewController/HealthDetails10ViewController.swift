//
//  HealthDetails10ViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/28.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol HealthDetails10ViewControllerDelegate: class {
//    func didTapButtonAddWithHealthDetails10ViewController()
}

class HealthDetails10ViewController: UIViewController,
    PopupAlertViewControllerDelegate,
    ScanHemoglobinAlcViewControllerDelegate
{

    weak var delegate:HealthDetails10ViewControllerDelegate?

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var buttonView: UIView!
    
    var popupAlertViewController = PopupAlertViewController()
    var arrayList = NSArray()
    var manager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initMainView()
        setInfo(index: 6)
        buttonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
        // set code
//        self.loadPopupAlertViewController()

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
       self.loadScanHemoglobinAlcViewController()
    }
    override func viewWillAppear(_ animated: Bool) {
        Global_ShowFrostGlass(self.view)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Global_HideFrostGlass()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.fetchHemoglobinAlc()
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
        lblTitle.font = UIFont.init(name: "Montserrat-Bold", size: 20)
    }
    
    // MARK - TableView
   

    func loadScanHemoglobinAlcViewController() {
        let scanHemoglobinAlcViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ScanHemoglobinAlcViewController") as? ScanHemoglobinAlcViewController)!
        scanHemoglobinAlcViewController.delegate = self
        self.present(scanHemoglobinAlcViewController, animated: true, completion: nil)
    }
    
    // MARK - ScanHemoglobinViewCOntrolelr delegate
    func didTapButtonAddScanHemoglobinAlcViewController(date: Date, value: Float) {
        // insert to db
        self.insertHemoglobinAlc(date: date, value: value)
    }
    
    func loadPopupAlertViewController() {
        sleep(UInt32(0.5))
        
        popupAlertViewController = (self.storyboard?.instantiateViewController(withIdentifier: "PopupAlertViewController") as? PopupAlertViewController)!
        popupAlertViewController.delegate = self
        popupAlertViewController.index = 3
        
        UIApplication.shared.keyWindow?.addSubview((popupAlertViewController.view)!)
    }
    
    // MARK - PopupAlertViewController Delegate
    func didTapButtonClosePopupAlertViewController() {
        popupAlertViewController.view.removeFromSuperview()
    }

    @IBAction func tapBtnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK - insert
    func insertHemoglobinAlc(date: Date, value: Float) {
        SVProgressHUD.show()
        let retult = manager.insertHemoglobinHlc(date: date, value: value)
        
        SVProgressHUD.dismiss()
        if retult == true {
            self.fetchHemoglobinAlc()
        } else {
            
        }
        
    }
    
    func fetchHemoglobinAlc() {
        SVProgressHUD.show()
        
        let array = manager.fetchHemoglobinHlcGetAllYearData()
        SVProgressHUD.dismiss()
        if array.count > 0 {
            arrayList = array
            collectionView.reloadData()
        }
    }
    
}
extension HealthDetails10ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayList.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIScreen.main.bounds.size.width >= 414.0{
            return CGSize(width: 353, height: 865)
        }
        return CGSize(width: view.frame.width, height: 865)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dicList = arrayList[indexPath.row] as! NSDictionary
        collectionView.register(UINib(nibName: "HemoglobinAlcCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HemoglobinAlcCollectionViewCell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HemoglobinAlcCollectionViewCell", for: indexPath) as! HemoglobinAlcCollectionViewCell
        cell.setInfo(dic: dicList)
        cell.delegate = self
        cell.tag = indexPath.item
        cell.backgroundColor = .yellow
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
extension HealthDetails10ViewController:HemoglobinAlcCollectionViewCellDelegate{
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
