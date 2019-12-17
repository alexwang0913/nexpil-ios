//
//  SubDetails013ViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/28.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol SubDetails013ViewControllerDelegate: class {
    func didTapButtonAddWithSubDetails013ViewController()
}

class SubDetails013ViewController: UIViewController{

    weak var delegate:SubDetails013ViewControllerDelegate?
    @IBOutlet weak var collectionView: UICollectionView!
    var arrayList = NSArray()
    var manager = DataManager()
    
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
        
        self.fetchBloodGlucose()
    }
    

    func initMainView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    

    // MARK - Fetch
    func fetchBloodGlucose() {
        SVProgressHUD.show()
        
        let array = manager.fetchBloodPressureGetAllYearData()
        
        SVProgressHUD.dismiss()
        if array.count > 0 {
            arrayList = array
            collectionView.reloadData()
        }
        
    }
    
}
extension SubDetails013ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayList.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIScreen.main.bounds.size.width >= 414.0{
            return CGSize(width: 353, height: 845)
        }
        return CGSize(width: view.frame.width, height: 845)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dicList = arrayList[indexPath.row] as! NSDictionary
        collectionView.register(UINib(nibName: "BloodPressureYearCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BloodPressureYearCollectionViewCell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BloodPressureYearCollectionViewCell", for: indexPath) as! BloodPressureYearCollectionViewCell
        cell.setInfo(dic: dicList)
        cell.delegate = self
        cell.tag = indexPath.item
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
extension SubDetails013ViewController:BloodPressureYearCollectionViewCellDelegate{
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
