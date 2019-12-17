//
//  UntakeConfirmViewController.swift
//  Nexpil
//
//  Created by Guang on 10/18/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Alamofire

protocol UntakConfirmDelegate {
    func closeUntakeConfirmDialog()
}

class UntakeConfirmViewController: UIViewController {

    var takenId = 0
    var delegate: UntakConfirmDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Global_ShowFrostGlass(self.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Global_HideFrostGlass()
    }
    
    @IBAction func closeButtonClick(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func editButtonClick(_ sender: Any) {
        let viewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "EditTakeTimeViewController") as! EditTakeTimeViewController
        viewController.takenId = self.takenId
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: false, completion: nil)
    }
    
    @IBAction func untakeButtonClick(_ sender: Any) {
        let params = [
            "taken_id" : takenId,
            "choice" : "10"
            ] as [String : Any]
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        
        Alamofire.request(DataUtils.APIURL + DataUtils.MYDRUG_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                self.dismiss(animated: false, completion: {
                    self.delegate?.closeUntakeConfirmDialog()
                })
            })
    }
}
