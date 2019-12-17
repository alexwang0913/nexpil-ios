//
//  InformationCard.swift
//  Nexpil
//
//  Created by Cagri Sahan on 9/5/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

@IBDesignable class InformationCard: UIView {
        
    @IBOutlet weak var identifier: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var containerView: GradientView!
    
    var parent: InformationCardEditableHolder?
    var view: UIView!
    
    
    @IBInspectable var identifierText: String = "Full Name" {
        didSet {
            self.identifier.text = identifierText
        }
    }
    @IBInspectable var valueText: String = "" {
        didSet {
            self.value.text = valueText
        }
    }
    
    @IBInspectable var identifierColor: UIColor = #colorLiteral(red: 0.2235294118, green: 0.8274509804, blue: 0.8901960784, alpha: 1) {
        didSet {
            self.identifier.textColor = identifierColor
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setup()
    }
    
    func xibSetup() {
        self.view = loadViewFromNib()        
//        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
        
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "InformationCard", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func setup() {
        
        self.identifier.text = identifierText
        self.value.text = valueText
        self.identifier.textColor = identifierColor
        self.backgroundColor = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.hideShadow()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.showShadow()
        
        guard let touchPoint = touches.first?.location(in: self) else { return }
        if self.bounds.contains(touchPoint) {
            parent?.cardTapped(withIdentifier: identifierText)
        }
        super.touchesEnded(touches, with: event)
    }
    
    private func sizeHeaderToFit(headerView: UIView?) -> CGFloat {
        guard let headerView = headerView else {
            return 0.0
        }

        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()

        let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height

        return height
    }
}
