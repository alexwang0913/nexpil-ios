//
//  PharmacyTableViewCustomHeader.swift
//  Pharmacies
//
//  Created by Mohammed Faizuddin on 3/15/19.
//  Copyright © 2019 Mohammed Faizuddin. All rights reserved.
//

import UIKit

class PharmacyTableViewCustomHeader: UITableViewHeaderFooterView {

    static let reuseIdentifer = "CustomHeaderReuseIdentifier"
    let customLabel = UILabel.init()
    let customFontName: String = "Montserrat-Medium"
    let customFontSize: CGFloat = 20.0
    let customTextColor: UIColor = UIColor.blue
    var customLine = UIView.init()
    
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        guard let customFont =  UIFont(name: customFontName, size: customFontSize) else {
            fatalError("""
        Failed to load the \(customFontName) font.
        Make sure the font file is included in the project and the font name is spelled correctly.
        """
            )
        }
        customLabel.font = customFont
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(customLabel)
        customLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        customLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -4.0).isActive = true
        self.customLabel.textColor = customTextColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
