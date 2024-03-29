//
//  SmallProfilePhoto.swift
//  Nexpil
//
//  Created by Admin on 25/06/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class SmallProfilePhoto: UIView {

    var photoImage: UIImageView = UIImageView()
    var userName: UILabel = UILabel()
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // #2
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    // #3
    public convenience init(image: UIImage, title: String) {
        self.init(frame: .zero)
        self.photoImage.image = image
        self.userName.text = title
        setupView()
    }
    
    private func setupView() {
        //translatesAutoresizingMaskIntoConstraints = false
        
        // Create, add and layout the children views ..
        
        userName.textColor = UIColor.init(hex: "333333")
        userName.font = UIFont(name: "Montserrat-Medium", size: 10)
        
        photoImage.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        userName.frame = CGRect(x: 0, y: 55, width: 50, height: 13)
        userName.textAlignment = .center
        addSubview(photoImage)
        addSubview(userName)
    }

}
