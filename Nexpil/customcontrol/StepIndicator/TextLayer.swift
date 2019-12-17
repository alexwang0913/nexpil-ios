//
//  TextLayer.swift
//  Nexpil
//
//  Created by mac on 9/2/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

class TextLayer: CATextLayer {
    var text: String = ""
    
    func updateStatus() {
        self.string = self.text
        self.frame = self.bounds
        self.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY * 1.2)
        self.contentsScale = UIScreen.main.scale
        self.foregroundColor = UIColor.black.cgColor
    }
}
