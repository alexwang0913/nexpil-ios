//
//  ProfilePhoto.swift
//  Nexpil
//
//  Created by Admin on 4/9/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ProfilePhoto: UIView {

    var photoImage: UIImageView = UIImageView()
    var userName: UILabel = UILabel()

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public convenience init(image: UIImage, title: String) {
        self.init(frame: .zero)
        self.photoImage.image = image
        self.userName.text = title
        setupView()
    }
    
    private func setupView() {
        userName.textColor = UIColor.init(hex: "333333")
        userName.font = UIFont(name: "Montserrat-Medium", size: 12)
        let width = self.frame.size.width
        
        photoImage.frame = CGRect(x: 0, y: 0, width: width, height: width)
        userName.frame = CGRect(x: 0, y: 75, width: width, height: 18)
        userName.textAlignment = .center
        addSubview(photoImage)
        addSubview(userName)
    }
}
