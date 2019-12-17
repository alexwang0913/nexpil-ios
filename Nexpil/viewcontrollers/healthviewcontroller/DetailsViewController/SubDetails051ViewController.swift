//
//  SubDetails051ViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/28.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import SVProgressHUD

class SubDetails051ViewController: UIViewController
{
    
    var arrayList = NSArray()
    var manager = DataManager()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.initMainView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.fetchWeight()
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
    

    
    // MARK - Fetch
    func fetchWeight() {
        SVProgressHUD.show()
        
        let array = manager.fetchWeightGetAllMonthData()
        
        SVProgressHUD.dismiss()
        if array.count > 0 {
            arrayList = array
            collectionView.reloadData()
        }
        
    }
    
}
extension SubDetails051ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayList.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIScreen.main.bounds.size.width >= 414.0{
            return CGSize(width: 353, height: 530)
        }
        return CGSize(width: view.frame.width, height: 530)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dicList = arrayList[indexPath.row] as! NSDictionary
        collectionView.register(UINib(nibName: "WeightMonthCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WeightMonthCollectionViewCell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeightMonthCollectionViewCell", for: indexPath) as! WeightMonthCollectionViewCell
        cell.setInfo(dic: dicList)
        cell.delegate = self
        cell.tag = indexPath.item
        cell.backgroundColor = .yellow
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
extension SubDetails051ViewController:WeightMonthCollectionViewCellDelegate{
    func didTapButtonBloodGlucoseDayCollectionViewCell(index: NSInteger, sendDic: NSDictionary) {
        
    }
    
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
