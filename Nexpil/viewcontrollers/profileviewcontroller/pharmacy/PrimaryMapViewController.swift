//
//  PharmacyViewController.swift
//  Pharmacies
//
//  Created by Mohammed Faizuddin on 3/13/19.
//  Copyright © 2019 Mohammed Faizuddin. All rights reserved.
//

import UIKit
import MapKit
import Pulley

class PrimaryMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapBackgroundView: UIView!

    var locationManager = CLLocationManager()
    
    var currentLocation: CLLocation = CLLocation(latitude: UserCache.instance.getLocation(of: "current").latitude, longitude: UserCache.instance.getLocation(of: "current").longitude)
    let regionRadius: CLLocationDistance = 1000

    weak var drawerViewController: DrawerPharmacyViewController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.customize()
        mapView.setup()
        mapBackgroundView.layer.cornerRadius = 30.0
        self.hideKeyboardWhenTappedAround()
        //UserCache.instance.createTable()
        
    }
   
    //MARK:- Default Pharmacies on launch
    func getPharmaciesNearAndUpdateUI(currentLocation location: CLLocationCoordinate2D, numberOfPharmacies count: Int,underMiles searchRadius: Double)
    {
        DBManager.shared?.deleteAll(from: "Near You")
        var nearbyPharmacies = [Pharmacy1]()
        let searchRadiusInMeters = 1609.344 * searchRadius
        let searchQuery = "Pharmacy"
        
        let request = MKLocalSearch.Request()
        let region = MKCoordinateRegionMakeWithDistance(location, searchRadiusInMeters, searchRadiusInMeters)
        
        request.naturalLanguageQuery = searchQuery
        request.region = region
        
        let search = MKLocalSearch(request: request)
        
        search.start { response, _ in
            guard let response = response else {
                return
            }
            
            let mapItems = response.mapItems
            
            var counter = 0
            
            for pharmacy in mapItems {
                
                if(counter < count && counter <= mapItems.count) {
                    
                    let name = pharmacy.name
                    let address = self.formatAddress(fullAddress: pharmacy.placemark.title!)
                    let phone = pharmacy.phoneNumber ?? "0000000000"
                    let coordinates = pharmacy.placemark.coordinate
                    
                    let pharmacy = Pharmacy1(name: name!, address: address, phone: phone, coordinates: coordinates)
                    
                    nearbyPharmacies.append(Pharmacy1(name: name!, address: address, phone: phone, coordinates: coordinates))
                    counter += 1
                     DBManager.shared?.addPharmacy(pharmacy: pharmacy, pharmacyType: "Near You")
                    
                }
                
            }
            
            self.drawerViewController = (self.parent as? PulleyViewController)?.drawerContentViewController as? DrawerPharmacyViewController
            //passing the whole pharmacy struct to mapview
            self.drawerViewController?.getNearbyPharmaciesFromCacheAndUpdateTableView()
            
            self.addAnnotations(pharmacies: nearbyPharmacies)
            
        }
        
        
    }
    
    
    //MARK: Add Annotation Function
    func addAnnotations(pharmacies: [Pharmacy1] ) {
        
        // Removing Previous Annotations
        self.mapView.removeAnnotations(self.mapView.annotations)
        
//        print(pharmacies.count)
        // Adding new Annotations
        for index in 0..<pharmacies.count {
            
            let annotation = MKPointAnnotation()
            let pharmacy = pharmacies[index]
                
            annotation.coordinate = pharmacy.coordinates!
            annotation.title = pharmacy.name
            mapView.addAnnotation(annotation)
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestAuthorizationForLocation()
        centerMapOnLocation(location: currentLocation)
      //  UserCache.instance.updateLocation(of: "current", latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        getPharmaciesNearAndUpdateUI(currentLocation: currentLocation.coordinate, numberOfPharmacies: 5, underMiles: 5.0)

      
    }
 
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func requestAuthorizationForLocation() {
        locationManager.requestWhenInUseAuthorization()
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways) {
            currentLocation = locationManager.location ?? CLLocation(latitude: UserCache.instance.getLocation(of: "current").latitude, longitude: UserCache.instance.getLocation(of: "current").longitude)
            
        }
    }
    
    func formatAddress(fullAddress: String) -> String {
        let index = fullAddress.firstIndex(of: ",")
        return String(fullAddress.prefix(upTo: index!))
    }
}


extension MKMapView {
    func customize() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 30.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.cornerRadius = 30.0
    }
    func setup() {
        self.showsUserLocation = true
        self.showsPointsOfInterest = false
        self.showsBuildings = false
        self.isUserInteractionEnabled = true
        self.isZoomEnabled = true
        self.isPitchEnabled = false
        self.isScrollEnabled = true
        self.isRotateEnabled = false

    }
}
