//
//  TextDetectionCard.swift
//  Nexpil
//
//  Created by Ravi Gupta on 18/03/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

@IBDesignable class TextDetectionCard: UIView {
    
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    var parent: InformationCardEditableHolder?
    var view: UIView!
    var gradientLayer: CAGradientLayer!
    
    @IBInspectable var titleText: String = "" {
        didSet {
            self.title.text = titleText
        }
    }
    
    
    
    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    
    @IBInspectable var colorScheme: Int = 0 {
        didSet {
            gradientLayer.colors = NPColorScheme(rawValue: colorScheme)!.gradient
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setup()
    }
    
    func xibSetup() {
        self.view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "UserTypeSelectionCard", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func setup() {
        self.title.text = titleText
        
        self.backgroundColor = nil
        
        let radius = self.frame.height * 1.5
        let shapeLayer = CAShapeLayer()
        let path1 = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: radius, height: radius))
        shapeLayer.path = path1.cgPath
        
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = NPColorScheme(rawValue: colorScheme)!.gradient
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        gradientLayer.frame = CGRect(x: -97, y: -37, width: radius, height: radius)
        gradientLayer.masksToBounds = true
        
        
        //circleView.layer.insertSublayer(gradientLayer, below: title.layer)
        //circleView.layer.addSublayer(shapeLayer)
        shapeLayer.frame = circleView.bounds
        //gradientLayer.mask = shapeLayer
        circleView.layer.masksToBounds = true
        circleView.backgroundColor = .white
        
        view.addSubview(circleView)
        
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        self.addShadow(color: UIColor.black.cgColor, alpha: 0.16, x: 0, y: 3, blur: 6)
        
        //self.bringSubview(toFront: title)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.hideShadow()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        view.showShadow()
        
        guard let touchPoint = touches.first?.location(in: self) else { return }
        if self.bounds.contains(touchPoint) {
            parent?.cardTapped(withIdentifier: titleText)
        }
    }
}
