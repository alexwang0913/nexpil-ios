//
//  primaryContentViewController.swift
//  
//
//  Created by Mohammed Faizuddin on 3/14/19.
//

import UIKit
import Pulley
import MapKit

class DrawerPharmacyViewController: UIViewController {
    
    @IBOutlet weak var findPharmacyTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    
    var matchingItems:[MKMapItem] = []
    
    var pharmacies: [PharmacyType: [Pharmacy1]] = [PharmacyType.nearYou: [Pharmacy1] (),
                                                  PharmacyType.nearHome: [Pharmacy1] (),
                                                  PharmacyType.myPharmacies: [Pharmacy1] ()]
    let minimumNumberOfPharmacies = 5
    let searchRadius = 5.0
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D? = nil
    
    weak var mapViewController: PrimaryMapViewController?
    weak var parentContainerViewController: MainViewController?
    
    enum PharmacyType: String {
        case nearYou
        case nearHome
        case myPharmacies
    }
    
    enum PharmacyTypeHeader: String {
        case nearYou = "Near You"
        case nearHome = "Near Home"
        case myPharmacies = "My Pharmacies"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        generalSetup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getNearbyPharmaciesFromCacheAndUpdateTableView()
        getHomeAddressFromDatabaseAndUpdateTableView()
        getMyPharmaciesFromDatabaseAndUpdateTableView()
//        locationManager.requestLocation()
     pulleyViewController?.setDrawerPosition(position: .open, animated: true)
    }
    
    
    func getNearbyPharmaciesFromCacheAndUpdateTableView() {
        let pharmaciesNearYou = DBManager.shared?.getPharmaciesFromCache(pharmacyType: PharmacyTypeHeader.nearYou.rawValue)
        self.pharmacies[PharmacyType.nearYou] = []
        for pharmacy in pharmaciesNearYou! {
            self.pharmacies[PharmacyType.nearYou]?.append(pharmacy)
        }
        tableView.reloadData()
        
        self.mapViewController = (self.parent as? PulleyViewController)?.primaryContentViewController as? PrimaryMapViewController
        //passing the whole pharmacy struct to mapview
        self.mapViewController?.addAnnotations(pharmacies: self.pharmacies[PharmacyType.nearYou]!)
        
    }
    
    
    func generalSetup()  {
        findPharmacyTextField.delegate = self
        locationTextField.delegate = self
        locationTextField.isUserInteractionEnabled = false
        self.hideKeyboardWhenTappedAround()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    
    //MARK: Table View Setup
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(PharmacyTableViewCustomHeader.self, forHeaderFooterViewReuseIdentifier: PharmacyTableViewCustomHeader.reuseIdentifer)
    }
    
    //
    func getHomeAddressFromDatabaseAndUpdateTableView() {
        
        let homeAddress = UserCache.instance.getLocation(of: "home")
        
        let pharmaciesNearHome = DBManager.shared!.getPharmaciesFromCache(pharmacyType:PharmacyTypeHeader.nearHome.rawValue)
        
        if pharmaciesNearHome.count != 0 {
            
            let type = PharmacyType.nearHome
            self.pharmacies[type] = []
            for pharmacy in pharmaciesNearHome {
                self.pharmacies[type]?.append(pharmacy)
            }
            self.tableView.reloadData()
            print("FETCHING DATA FROM CACHE")
        } else {
            print("CALLING SERVICE FOR HOME ADDRESSES")
            searchPharmaciesNear(location: homeAddress, locationType: PharmacyType.nearHome, numberOfPharmacies: minimumNumberOfPharmacies, underMiles: searchRadius)
        }
    }
    
    func getMyPharmaciesFromDatabaseAndUpdateTableView()  {
        DataUtils.customActivityIndicatory(self.view, startAnimate: true)
        DBManager.shared!.deleteMypharmacyAll(from: "My Pharmacies")
        self.pharmacies[PharmacyType.myPharmacies] = []
        DataUtils.getPharmacy(completionHandler: { (Status , Datas) in
            arrayPharmacy = Datas
            for i in 0..<arrayPharmacy.count{
                DBManager.shared!.addPharmacyFromServer(pharmacy: arrayPharmacy[i], pharmacyType: "My Pharmacies")
            }
            let myPharmacies = DBManager.shared!.getPharmaciesFromCache(pharmacyType:"My Pharmacies")
            for pharmacy in myPharmacies {
                self.pharmacies[PharmacyType.myPharmacies]?.append(pharmacy)
            }
            self.tableView.reloadData()
            DataUtils.customActivityIndicatory(self.view, startAnimate: false)
        })

        
    }
    
    func openDrawer() {
        pulleyViewController?.setDrawerPosition(position: .open, animated: true)
    }
    
    
    //MARK:- Generic Function for Pharmacy Search
    func searchPharmaciesNear(location: CLLocationCoordinate2D, locationType: PharmacyType, numberOfPharmacies count: Int, underMiles searchRadius: Double, searchQuery: String = "Pharmacy", updateMap: Bool = false, updateDatabase: Bool = true)
    {
        self.pharmacies[locationType]?.removeAll()
        
        if updateDatabase {
             DBManager.shared!.deleteAll(from: locationType.rawValue)
        }
        
        let searchRadiusInMeters = 1609.344 * searchRadius
        
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
                    
                    guard let name = pharmacy.name else {
                        print("Error while initializing name")
                        return
                    }
                    guard var address =  pharmacy.placemark.title else {
                        print("Error while initializing address")
                        return
                    }
                    address = self.formatAddress(fullAddress: address)
                    
                    guard var phone = pharmacy.phoneNumber else {
                        print("Error while initializing phone")
                        return
                    }
                    phone = self.formatPhoneNumber(phoneNumber: phone)
                    
                    let coordinates = pharmacy.placemark.coordinate
                    
                    let pharmacy = Pharmacy1(name: name, address: address, phone: phone, coordinates: coordinates)
                    
                    self.pharmacies[locationType]?.append(pharmacy)
                    
                    if updateDatabase {
                        DBManager.shared?.addPharmacy(pharmacy: pharmacy, pharmacyType: String(locationType.rawValue))
                    }
                    counter += 1
                }
                
            }
            self.tableView.reloadData()
            
            if updateMap {
                self.mapViewController = (self.parent as? PulleyViewController)?.primaryContentViewController as? PrimaryMapViewController
                //passing the whole pharmacy struct to mapview
                self.mapViewController?.addAnnotations(pharmacies: self.pharmacies[PharmacyType.nearYou]!)
                let currentLocationCoordinates = UserCache.instance.getLocation(of: "current")
                let currentLocation = CLLocation(latitude: currentLocationCoordinates.latitude, longitude: currentLocationCoordinates.longitude)
                
                self.mapViewController?.centerMapOnLocation(location: currentLocation)
            }
        }
    }
    
    
    func fetchImage(for pharmacy: String) -> UIImage {
        if pharmacy.lowercased().contains("cvs") {
            return UIImage(named: "cvs")!
        } else  if pharmacy.lowercased().contains("albertson") {
            return UIImage(named: "albertson")!
        } else  if pharmacy.lowercased().contains("walgreens") {
            return UIImage(named: "walgreens")!
        } else  if pharmacy.lowercased().contains("boots") {
            return UIImage(named: "boots")!
        } else  if pharmacy.lowercased().contains("costco") {
            return UIImage(named: "costco")!
        } else  if pharmacy.lowercased().contains("diplomat") {
            return UIImage(named: "diplomat")!
        } else  if pharmacy.lowercased().contains("express scripts") {
            return UIImage(named: "expressscripts")!
        } else  if pharmacy.lowercased().contains("humana") {
            return UIImage(named: "humana")!
        } else  if pharmacy.lowercased().contains("jewel-osco") {
            return UIImage(named: "jewelosco")!
        } else  if pharmacy.lowercased().contains("kroger") {
            return UIImage(named: "kroger")!
        } else  if pharmacy.lowercased().contains("publix") {
            return UIImage(named: "publix")!
        } else  if pharmacy.lowercased().contains("rite aid") {
            return UIImage(named: "riteaid")!
        } else  if pharmacy.lowercased().contains("walmart") {
            return UIImage(named: "walmart")!
        }  else {
            return UIImage(named: "generic")!
            
        }
    }
    
    
    
    //MARK: Search Button Tapped
    @IBAction func searchButtonTapped(_ sender: Any) {
        let searchQuery = findPharmacyTextField.text ?? "Pharmacy"
        let currentCoordinates = UserCache.instance.getLocation(of: "current")
        print(currentCoordinates)
        searchPharmaciesNear(location: currentCoordinates, locationType: PharmacyType.nearYou, numberOfPharmacies: minimumNumberOfPharmacies, underMiles: searchRadius, searchQuery: searchQuery, updateMap: true, updateDatabase: false)
        pulleyViewController?.setDrawerPosition(position: .open, animated: true)
        
    }
    @IBAction func currentLocationButtonTapped(_ sender: Any) {
        locationManager.requestLocation()
        
    }
    @IBAction func barTapped(_ sender: Any) {
        if pulleyViewController?.drawerPosition == .open {
            pulleyViewController?.setDrawerPosition(position: .collapsed, animated: true)
        } else if pulleyViewController?.drawerPosition == .partiallyRevealed || pulleyViewController?.drawerPosition == .collapsed {
            pulleyViewController?.setDrawerPosition(position: .open, animated: true)
        }
    }
}

//MARK: TextField Delegate
extension DrawerPharmacyViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        pulleyViewController?.setDrawerPosition(position: .partiallyRevealed, animated: true)
    }
}

//MARK: CLLocationManagerDelegate Configuration
extension DrawerPharmacyViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    //MARK: Default Values in Table View
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.first != nil {
            
            print("location:: \(locations)")
            currentLocation = locations.first!.coordinate
            let oldLocation = UserCache.instance.getLocation(of: "current")
            let loc1 = CLLocation(latitude: (currentLocation?.latitude)!, longitude: (currentLocation?.longitude)!)
            let loc2 = CLLocation(latitude: (oldLocation.latitude), longitude: (oldLocation.longitude))
            let distanceInMeters = loc1.distance(from: loc2) // result is in meters
            let geocoder = CLGeocoder()
            let distanceInMiles = distanceInMeters/1609
            
            if distanceInMiles < 1 {
                
                print("USER HAS NOT MOVED ENOUGH TO UPDATE THE DB")
                geocoder.reverseGeocodeLocation(locations.first!, completionHandler: { (placemarks, error) in
                    if error == nil {
                        let firstLocation = placemarks?[0]
                        self.locationTextField.text = firstLocation?.name!
                    }
                    else {
                        print("An error occurred during geocoding")
                    }
                })
            }
            else {
                print("DISTANCE IN MILES: \(distanceInMiles)")
                UserCache.instance.updateLocation(of: "current", latitude: (currentLocation?.latitude)!, longitude: (currentLocation?.longitude)!)
                
                geocoder.reverseGeocodeLocation(locations.first!, completionHandler: { (placemarks, error) in
                    if error == nil {
                        let firstLocation = placemarks?[0]
                        self.locationTextField.text = firstLocation?.name!
                            self.searchPharmaciesNear(location: (firstLocation?.location!.coordinate)!, locationType: PharmacyType.nearYou, numberOfPharmacies: self.minimumNumberOfPharmacies , underMiles: self.searchRadius)
                            print("UPDATING DB WITH NEW NEAR ME PHARMACIES")
                        
                    }
                    else {
                        print("An error occurred during geocoding")
                    }
                })
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
}

//MARK: All TableView Configuration here
extension DrawerPharmacyViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return pharmacies[PharmacyType.nearYou]!.count
        case 1:
            return pharmacies[PharmacyType.nearHome]!.count
        case 2:
            return pharmacies[PharmacyType.myPharmacies]!.count == 0 ? 1 : pharmacies[PharmacyType.myPharmacies]!.count
        default:
            return 0
            
        }
    }
    
    //MARK:- Content inside of the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //if no pharmacies in view then doing this
        if indexPath.section == 2 && pharmacies[PharmacyType.myPharmacies]!.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PharmacyCustomCellTwo", for: indexPath) as! PharmacyTableViewCellTwo
            cell.isUserInteractionEnabled = false
            return cell
            
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PharmacyCustomCell", for: indexPath) as! PharmacyTableViewCell
            let row = indexPath.item
            var pharmacyType: PharmacyType
            
            //Hiding infor button for Near You & Near Home
            switch indexPath.section {
            case 0:
                cell.pharmacyInfoButton.isHidden = true
                pharmacyType = PharmacyType.nearYou
            case 1:
                cell.pharmacyInfoButton.isHidden = true
                pharmacyType = PharmacyType.nearHome
            default:
                cell.pharmacyInfoButton.isHidden = false
                pharmacyType = PharmacyType.myPharmacies
            }
            
            let pharmacy = pharmacies[pharmacyType]
            if indexPath.item < pharmacy!.count{
                let name = pharmacy?[row].name ?? ""
                let address = pharmacy?[row].address ?? ""
                
                cell.pharmacyNameLabel.text = name
                cell.pharmacyAddressLabel.text = address
                
                
                cell.pharmacyLogoImageView.image = fetchImage(for: name)
            }
            
            
            
            return cell
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: PharmacyTableViewCustomHeader.reuseIdentifer) as? PharmacyTableViewCustomHeader else {
            return nil
        }
        
        switch section {
        case 0:
            header.customLabel.text =  PharmacyTypeHeader.nearYou.rawValue
        case 1:
            header.customLabel.text =  PharmacyTypeHeader.nearHome.rawValue
        case 2:
            header.customLabel.text =  PharmacyTypeHeader.myPharmacies.rawValue
        default:
            header.customLabel.text =  "Pharmacies"
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54.0
    }
    
    
    
    //MARK: On selection Cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

        
        let pharmacyType = indexPath.section == 0 ? PharmacyType.nearYou : ( indexPath.section == 1 ? PharmacyType.nearHome : PharmacyType.myPharmacies)
        
        let pharmacy = pharmacies[pharmacyType]![indexPath.row]
        
        let pharmacyInfoViewController = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "PharmacyInfoViewController") as! PharmacyInfoViewController
        
        pharmacyInfoViewController.pharmacy = pharmacy
        
        self.parentContainerViewController = (self.parent as! PulleyViewController).parent as? MainViewController
        parentContainerViewController?.cancelButton.setImage(UIImage(named: "back"), for: .normal)
        
        pulleyViewController?.setDrawerContentViewController(controller: pharmacyInfoViewController, animated: true)
        
        
    }
    
}

extension DrawerPharmacyViewController: PulleyDrawerViewControllerDelegate {
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat
    {
        // For devices with a bottom safe area, we want to make our drawer taller. Your implementation may not want to do that. In that case, disregard the bottomSafeArea value.
        return 264.0 + (pulleyViewController?.currentDisplayMode == .drawer ? bottomSafeArea : 0.0)
    }
    
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 87.0 + (pulleyViewController?.currentDisplayMode == .drawer ? bottomSafeArea : 0.0)
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return [.collapsed, .partiallyRevealed, .open]
    }
    
  
}

//MARK: Helper Functions
extension DrawerPharmacyViewController {
    func formatAddress(fullAddress: String) -> String {
        let index = fullAddress.firstIndex(of: ",")
        return String(fullAddress.prefix(upTo: index!))
    }
    func formatPhoneNumber(phoneNumber: String) -> String {
        let number = phoneNumber.filter("+01234567890.".contains)
        return number
    }
}
