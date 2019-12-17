//
//  InformationCardEditDosageViewController.swift
//  Nexpil
//
//  Created by Cagri Sahan on 9/28/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class InformationCardEditDosageViewController: InformationCardEditViewController {

    let screensize = UIScreen.main.bounds.size
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doselabel: UILabel!
    
    var results = [DrugProductInfo]()
    var myItem = [String]()
    var selectedIndexPath:IndexPath?
    
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        if dosage.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please select strength", title: "")
            return
        }
        DispatchQueue.main.async { [unowned self] in
            /*
            self.summaryPage?.prescription?.dose = self.dosage
            self.summaryPage?.strengthCard.valueText = self.dosage
            self.summaryPage?.strengthCard.view.addShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.16, x: 0, y: 3, blur: 6.0)
            */
//            self.navigationController?.popViewController(animated: true)
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let medicationController = storyBoard.instantiateViewController(withIdentifier: "SiriMedicationViewController") as! SiriMedicationViewController
            medicationController.delegate = self.delegate
            self.navigationController?.pushViewController(medicationController, animated: true)
            
        }
    }
    
    //let a = ["10mg","20mg","30mg","40mg"]
    var dosage: String = ""
    //var summaryPage: SummaryScreenViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageHeight.constant = (screensize.width * 72.53) / 100
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.clipsToBounds = true
        //collectionView.layer.masksToBounds = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
        let name = DataUtils.getMedicationName()! + "?"
        doselabel.text = "What's the strength of your " + name
        goProductInfo()
    }
    
    func goProductInfo() {
        self.results.removeAll()
        let urlString = DataUtils.APIURL + DataUtils.PRODUCT_URL + "?name=\(DataUtils.getMedicationName()!)&choice=1"
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: { [unowned self] (data, response, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            let decoder = JSONDecoder()
            self.results = try! decoder.decode([DrugProductInfo].self, from: data)
            print(self.results)
            DispatchQueue.main.async { [unowned self] in
                self.showDrugStrength()
            }
        })
        task.resume()
    }
    func showDrugStrength()
    {
        myItem.removeAll()
        var myItems1 = [String]()
        for data in results
        {
            let data1 = data.Strength.components(separatedBy: ";")
            for data2 in data1
            {
                //myItem.append(data2)
                myItems1.append(data2)
            }
        }

        for index1 in 0 ..< myItems1.count //- 1
        {
            for index2 in index1 + 1 ..< myItems1.count
            {
                var num1 = myItems1[index1].trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.").inverted)//myItems1[index1].components(separatedBy: CharacterSet.alphanumerics).joined()
                num1 = num1.replacingOccurrences(of: ",", with: "")
                var num2 = myItems1[index2].trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.").inverted)
                num2 = num2.replacingOccurrences(of: ",", with: "")
                let fNum1 = Float(num1)
                let fNum2 = Float(num2)
                if fNum1 != nil && fNum2 != nil {
                    if fNum1! > fNum2!
                    {
                        let temp = myItems1[index1]
                        myItems1[index1] = myItems1[index2]
                        myItems1[index2] = temp
                    }
                }
            }
        }
        
        myItem = myItems1
        collectionView.reloadData()
        if selectedIndexPath != nil
        {
            collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredVertically)
        }
    }
    @IBAction func crossButton(_ sender: UIButton) {
        self.view.addSubview(visualEffectView!)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CloseAddMedicationViewController") as! CloseAddMedicationViewController        
        viewController.delegate = self
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: false, completion: nil)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension InformationCardEditDosageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dosageCell", for: indexPath) as! NPPlainCollectionViewCell
        cell.textLabel.text = myItem[indexPath.row]
        cell.roundCorners(.allCorners, radius: 20)
        cell.addShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.16, x: 0, y: 3, blur: 6)
        cell.clipsToBounds = false
        /*
        cell.layer.masksToBounds = false
        cell.clipsToBounds = false
        cell.backgroundColor = UIColor.clear
        */
        return cell
    }
    
    
}

extension InformationCardEditDosageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width-11)/2
        return CGSize(width: width, height: width/2)
    }
}

extension InformationCardEditDosageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! NPPlainCollectionViewCell
        dosage = cell.textLabel.text!
        DataUtils.setMedicationStrength(name: dosage)
        self.selectedIndexPath = indexPath
    }
}
