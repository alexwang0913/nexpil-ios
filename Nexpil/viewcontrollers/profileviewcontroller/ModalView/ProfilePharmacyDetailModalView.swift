//
//  ProfilePharmacyDetailModalView.swift
//  Nexpil
//
//  Created by JinYingZhe on 1/24/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import MapKit
protocol ProfilePharmacyDetailModalViewDelegate {
    func popPharmacyDetailViewDismissal()
}
class PlaceAnnotation: NSObject, MKAnnotation {
    
    /*
     This property is declared with `@objc dynamic` to meet the API requirement that the coordinate property on all MKAnnotations
     must be KVO compliant.
     */
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    var title: String?
    var url: URL?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}
import MapKit

class Artwork: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}

class ProfilePharmacyDetailModalView: UIView{
    @IBOutlet weak var backUV: UIView!
    @IBOutlet weak var wholeUV: UIView!
    @IBOutlet weak var closeUB: UIButton!
    @IBOutlet weak var weekUV: UIView!
    @IBOutlet weak var weekUSV: UIStackView!
    @IBOutlet weak var mapView: MKMapView!{
        didSet{
            mapView.layer.cornerRadius = 20
        }
    }
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var addressLine: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var sundayUV: UIView!
    @IBOutlet weak var saturdayUV: UIView!
    
    var delegate: ProfilePharmacyDetailModalViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //  Initialation code
        backUV.setPopItemViewStyle(radius: 30.0, title: .large)
        closeUB.setPopItemViewStyle(radius: 22.5)
        
        sundayUV.layer.cornerRadius = 20.0
        saturdayUV.layer.cornerRadius = 20.0
        weekUSV.layer.cornerRadius = 20.0
        weekUV.setPopItemViewStyle()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(wholeTapped(tapGestureRecognizer:)))
        wholeUV.addGestureRecognizer(tapGestureRecognizer)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBAction func onClickCloseUB(_ sender: Any) {
        self.delegate?.popPharmacyDetailViewDismissal()
    }
    
    @objc func wholeTapped(tapGestureRecognizer gesture: UITapGestureRecognizer) {
        self.delegate?.popPharmacyDetailViewDismissal()
    }

}
