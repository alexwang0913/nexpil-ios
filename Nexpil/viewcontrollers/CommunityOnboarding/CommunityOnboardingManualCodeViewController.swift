//
//  CommunityOnboardingManualCodeViewController.swift
//  Nexpil
//
//  Created by mac on 6/30/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Alamofire

class CommunityOnboardingManualCodeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var txtCodes: [UITextField]!
    @IBOutlet var lblMsg: UILabel!
    @IBOutlet var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblMsg.text = ""
        loader.isHidden = true
        for item in txtCodes {
            item.delegate = self
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        var idx = 0
        for item in txtCodes {
            idx += 1
            if item == textField {
                break
            }
        }
        if updatedText.count == 1 {
            if idx < 5{
                Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(moveFocus), userInfo: idx, repeats: false)
            } else {
                Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(editedLastCode), userInfo: idx, repeats: false)
            }
        }
        self.lblMsg.text = ""
        return updatedText.count <= 1
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return loader.isHidden
    }
    
    @objc func moveFocus(_ sender: Timer) {
        txtCodes[sender.userInfo as! Int].becomeFirstResponder()
        processCode()
    }
    
    @objc func editedLastCode(_ sender: Timer) {
        processCode()
    }
    
    @objc func moveToNextScreen() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "CommunityOnboardingSignupViewController") as! CommunityOnboardingSignupViewController
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
    }
    
    func processCode(){
        var filled = true
        for item in txtCodes {
            if item.text?.length == 0 {
                filled = false
                break
            }
        }
        
        if filled == false {
            return
        }
        loader.isHidden = false
        var code = ""
        for item in txtCodes {
            item.resignFirstResponder()
            code += item.text!
        }
        
        let params = [
            "choice" : "5",
            "code" : code
            ] as [String : Any]
        Alamofire.request(DataUtils.APIURL + DataUtils.COMMUNITYUSERS_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                debugPrint(response)
                self.loader.isHidden = true
                if let data = response.result.value {
                    let json : [String:Any] = data as! [String : Any]
                    let result = json["status"] as? String
                    
                    if result == "true"
                    {
                        UserDefaults.standard.set(code, forKey: "signup_usercode")              
                        self.lblMsg.text = "valid usercode"
                        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.moveToNextScreen), userInfo: nil, repeats: false)
                    }
                    else
                    {
                        self.lblMsg.text = "invalid usercode"
                        for item in self.txtCodes {
                            item.text = ""
                        }
                        self.txtCodes[0].becomeFirstResponder()
                    }
                } else {
                    DataUtils.messageShow(view: self, message: "Server Error", title: "")
                }
            })
    }
}
