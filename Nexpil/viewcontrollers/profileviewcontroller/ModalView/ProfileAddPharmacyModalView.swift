//
//  ProfileAddConditionModalView.swift
//  Nexpil
//
//  Created by JinYingZhe on 1/23/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Contacts

extension MKPlacemark {
    var formattedAddress: String? {
        guard let postalAddress = postalAddress else { return nil }
        return CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress).replacingOccurrences(of: "\n", with: " ")
    }
}


protocol ProfileAddPharmacyModalViewDelegate {
    func popAddPharmacyViewDismissal()
    func popAddPharmacyViewAddBtnClick(MapItem:MKMapItem)
}

protocol customCellDelegate {
    func buttonTapped(sender:UIButton,index:Int)
}

class customCell:UITableViewCell{
    var delegate:customCellDelegate?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let starButton = UIButton(type: .system)
        starButton.setImage(UIImage(named: "icon_info"), for: .normal)
        starButton.frame=CGRect(x: 0, y: 0, width: 20, height: 20)
        starButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        accessoryView = starButton
        
    }
    
    @objc func buttonTapped(sender:UIButton){
        delegate?.buttonTapped(sender: sender, index: accessoryView!.tag)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension ProfileAddPharmacyModalView:customCellDelegate{
    func buttonTapped(sender: UIButton,index:Int) {
        if let mapItem = places?[index]{
            popPharmacyDetailView = Bundle.main.loadNibNamed("ProfilePharmacyDetailModalView", owner: self, options: nil)?.first as! ProfilePharmacyDetailModalView
            popPharmacyDetailView.delegate = self
            popPharmacyDetailView.frame = self.frame
            let artwork = Artwork(title: mapItem.name!,
                                  locationName: mapItem.placemark.formattedAddress!,
                                  discipline: "Pharmacies",
                                  coordinate: CLLocationCoordinate2D(latitude: mapItem.placemark.coordinate.latitude, longitude: mapItem.placemark.coordinate.longitude))
            popPharmacyDetailView.mapView.addAnnotation(artwork)
            let center = CLLocationCoordinate2D(latitude: mapItem.placemark.coordinate.latitude, longitude: mapItem.placemark.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            popPharmacyDetailView.mapView.setRegion(region, animated: false)
            popPharmacyDetailView.addressLine.text = mapItem.placemark.formattedAddress
            popPharmacyDetailView.phoneNumber.text = mapItem.phoneNumber
            popPharmacyDetailView.title.text = mapItem.name
            searchUTF.resignFirstResponder()
            addSubview(popPharmacyDetailView)
            self.backUB.isHidden = true
            self.backUV.isHidden = true
        }
    }
  
}


//location update methods

extension ProfileAddPharmacyModalView:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        print(currentLocation?.coordinate.latitude,currentLocation?.coordinate.longitude)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle any errors returns from Location Services.
    }
}



//tableView delegate methods
extension ProfileAddPharmacyModalView:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! customCell

        if let mapItem = places?[indexPath.row] {
            cell.textLabel?.text = mapItem.name
            cell.textLabel?.font = UIFont(name:"Montserrat Medium",size:16)
            cell.detailTextLabel?.text = mapItem.placemark.formattedAddress
            cell.accessoryView?.tag = indexPath.row
            cell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
    }
}

// ProfilePharmacyDetailModalViewDelegate methods
extension ProfileAddPharmacyModalView:ProfilePharmacyDetailModalViewDelegate{
    func popPharmacyDetailViewDismissal() {
        self.popPharmacyDetailView.removeFromSuperview()
        mTabView.isHidden = true
        self.backUB.isHidden = false
        self.backUV.isHidden = false
    }
}


class ProfileAddPharmacyModalView: UIView{
    @IBOutlet weak var backUV: UIView!
    @IBOutlet weak var addUB: UIButton!
    @IBOutlet weak var wholeUV: UIView!
    @IBOutlet weak var backUB: UIButton!
    @IBOutlet weak var titleUL: UILabel!
    @IBOutlet weak var searchUTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var popPharmacyDetailView: ProfilePharmacyDetailModalView = ProfilePharmacyDetailModalView()
    private let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var delegate: ProfileAddPharmacyModalViewDelegate?
    let cellReuseIdentifier = "cell"
    var selectedIndex = 0
    private var boundingRegion: MKCoordinateRegion?
    private var locationManagerObserver: NSKeyValueObservation?
    
    private var places: [MKMapItem]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var localSearch: MKLocalSearch? {
        willSet {
            places = nil
            localSearch?.cancel()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //  Initialation code
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        searchUTF.addTarget(self, action: #selector(updateText), for: UIControlEvents.editingChanged)
        
        backUV.setPopItemViewStyle(radius: 30.0, title: .large)
        self.backUB.setPopItemViewStyle(radius: 22.5)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(wholeTapped(tapGestureRecognizer:)))
        wholeUV.addGestureRecognizer(tapGestureRecognizer)
        self.tableView.register(customCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.tableView.tableFooterView = UIView()
        self.tableView.alwaysBounceVertical = false
        tableView.delegate = self
        tableView.dataSource = self
        if let location = self.currentLocation {
            let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 120, 120)
            self.boundingRegion = region
            self.tableView.reloadData()
        }
        
    }
    
    @objc func updateText() {
        let text = searchUTF.text ?? ""
        if text != ""
        {
            self.places?.removeAll()
            tableView.isHidden = false
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = "\(text) pharmacy"
            search(using: searchRequest)
        }
    }
    
    
    private func search(using searchRequest: MKLocalSearch.Request) {
        // Confine the map search area to an area around the user's current location.
        if let region = boundingRegion {
            searchRequest.region = region
        }
        
        localSearch = MKLocalSearch(request: searchRequest)
        localSearch?.start { [weak self] (response, error) in
            guard error == nil else {
                return
            }
            self?.places = response?.mapItems
            self?.boundingRegion = response?.boundingRegion
        }
    }
    
    
    
    func resetAddConditionList(datas dataList: [String]){
       
    }
    
    @objc func wholeTapped(tapGestureRecognizer gesture: UITapGestureRecognizer) {
        self.delegate?.popAddPharmacyViewDismissal()
    }
    
    @IBAction func onClickAddConditionUB(_ sender: Any) {
        self.delegate?.popAddPharmacyViewAddBtnClick(MapItem: places![selectedIndex])
    }
    
    @IBAction func onClickbackUB(_ sender: Any){
        //self.delegate?.popAddPharmacyViewAddBtnClick()
    }
    
}
