//
//  ProfilePersonDetailModalView.swift
//  Nexpil
//
//  Created by JinYingZhe on 1/25/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Alamofire

protocol ProfilePersonDetailModalViewDelegate {
    func popPersonDetailViewDismissal()
    func popPersonDetailAvatarImgClick()
    func ClickSaveUB(firstName:String,lastName:String?,birth:String,phone:String,address:String)
}

class ProfilePersonDetailModalView: UIView {
    @IBOutlet weak var backUV: UIView!
    @IBOutlet weak var wholeUV: UIView!
    @IBOutlet weak var closeUB: UIButton!
    
    @IBOutlet weak var avatarUIV: UIImageView!
    @IBOutlet weak var avatarUV: UIView!
    
    @IBOutlet weak var spaceUV1: UIView!
    @IBOutlet weak var spaceUV2: UIView!
    @IBOutlet weak var spaceUV3: UIView!
    @IBOutlet weak var spaceUV4: UIView!
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    
    var delegate: ProfilePersonDetailModalViewDelegate?
    var isMale: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //  Initialation code
        backUV.setPopItemViewStyle(title: PShadowType.large)
        let tapWholeView = UITapGestureRecognizer(target: self, action: #selector(wholeTapped(tapGestureRecognizer:)))
        wholeUV.addGestureRecognizer(tapWholeView)
        let tapAvatarImg = UITapGestureRecognizer(target: self, action: #selector(avatarTapped(tapGestureRecognizer:)))
        avatarUIV.addGestureRecognizer(tapAvatarImg)

        avatarUIV.layer.cornerRadius = 50.0
        avatarUV.setPopItemViewStyle(title: PShadowType.small)
        avatarUV.layer.cornerRadius = 50.0

        closeUB.setPopItemViewStyle(title: PShadowType.small)
        closeUB.layer.cornerRadius = 22.5
        
        let preference = PreferenceHelper()
        if preference.getUserImage()! == ""
        {
            let image = UIImage(named: "Intersection 1")
            avatarUIV.image = image
        }
        else
        {
            let url = URL(string: DataUtils.PROFILEURL + preference.getUserImage()!)
            avatarUIV.kf.setImage(with: url)
        }
        
        let username = preference.getFirstName()! + " " + preference.getLastName()!
        nameTF.text = username
        let birthday = preference.getBirthday()
        dateTF.text = birthday
        let phone = preference.getPhoneNumber()
        phoneTF.text = phone
        let address = preference.getAddress()
        addressTF.text = address
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @objc func wholeTapped(tapGestureRecognizer gesture: UITapGestureRecognizer) {
        self.delegate?.popPersonDetailViewDismissal()
    }
    
    @objc func avatarTapped(tapGestureRecognizer gesture: UITapGestureRecognizer) {
        self.delegate?.popPersonDetailAvatarImgClick()
    }
    
    @IBAction func onClickCloseUB(_ sender: Any) {
        self.delegate?.popPersonDetailViewDismissal()
    }
    
//    onClickSaveUB
    @IBAction func onClickSaveUB(_ sender: Any){
        let name = nameTF.text
        if name == "" {
            let alert = UIAlertController(title: "Waring", message: "The username is empty。 Please enter it.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    self.nameTF.becomeFirstResponder()
                case .cancel:
                    print("cancel")
                case .destructive:
                    print("destructive")
                }}))
            self.viewController()?.present(alert, animated: true, completion: nil)
            return
        }
        let birth = dateTF.text!
        let phone = phoneTF.text!
        let address = addressTF.text!
        
        

      //  let imgData = UIImageJPEGRepresentation(avatarUIV.image!, 0.2)!
        
        var fullNameArr = name?.components(separatedBy: " ")
        let firstName: String = fullNameArr![0]
        let lastName: String? = (fullNameArr?.count)! > 1 ? fullNameArr?[1] : nil
        self.delegate?.ClickSaveUB(firstName: firstName, lastName: lastName, birth: birth, phone: phone, address: address)
        
    }
}
