//
//  PharmacyInfoViewController.swift
//  Pharmacies
//
//  Created by Mohammed Faizuddin on 3/21/19.
//  Copyright © 2019 Mohammed Faizuddin. All rights reserved.
//

import UIKit
import MapKit
import Pulley
import Alamofire
class PharmacyInfoViewController: UIViewController {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var timingsLabel: UILabel!
    @IBOutlet var walkDriveSymbol: UIImageView!
    @IBOutlet var walkTime: UILabel!
    @IBOutlet var heartButton: UIButton!
    @IBOutlet var infoButton: UIButton!
    
    @IBOutlet var directionsButton: UIButton!
    @IBOutlet var callButton: UIButton!
    
    @IBOutlet var prescriptionBackground: UIView!
    @IBOutlet var dateLabel: UILabel! // "Filed on Date " format
    
    var pharmacy = Pharmacy1()
    
    enum PharmacyType: String {
        case nearYou
        case nearHome
        case myPharmacies
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        pulleyViewController?.allowsUserDrawerPositionChange = false
        pulleyViewController?.setNeedsSupportedDrawerPositionsUpdate()
      
        
        let isMyPharmacy = DBManager.shared!.contains(this:pharmacy)//PharmacyCache.instance.contains(this: pharmacy)
        if isMyPharmacy {
            heartButton.setImage(UIImage(named: "selected"), for: .normal)
        } else {
            heartButton.setImage(UIImage(named: "deselected"), for: .normal)
            pulleyViewController?.allowsUserDrawerPositionChange = false
            infoButton.isHidden = true
        }
        
        prescriptionBackground.isHidden = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameLabel.text = pharmacy.name
        addressLabel.text = pharmacy.address
        logoImageView.image = fetchImage(for: pharmacy.name)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goBack), name: Notification.Name(rawValue: "goBack"), object: nil)

        
        pulleyViewController?.setDrawerPosition(position: .closed, animated: true)
    }
    

    @IBAction func directionsTapped(_ sender: Any) {
        openMapForPlace()
    }
    @IBAction func callTapped(_ sender: Any) {
        let number = pharmacy.phone
        guard let numberURL = URL(string: "tel://" + number) else { return }
        UIApplication.shared.open(numberURL)
        
    }
    @IBAction func heartTapped(_ sender: Any) {
        
        if heartButton.currentImage == UIImage(named: "selected") {
            
            let alert = UIAlertController(title: "Are You Sure?", message: "This will remove this Pharmacy from your favorites and also delete any related content.", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
                    //DELETE HERE
                
                DBManager.shared?.removeFromMyPharmacies(pharmacy: self.pharmacy)
                DataUtils.deleteMyPharmacy(address: self.pharmacy.address, completionHandler: {  success in
                    if success{
                        
                    }
                    if !success{
                        
                    }
                })
                self.heartButton.setImage(UIImage(named: "deselected"), for: .normal)
                self.infoButton.isHidden = true
                self.pulleyViewController?.setDrawerPosition(position: .collapsed, animated: true)
                self.pulleyViewController?.setNeedsSupportedDrawerPositionsUpdate()

            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)

            
        } else if heartButton.currentImage == UIImage(named: "deselected")
        {
            //ADD PHARMACY HERE
            DBManager.shared?.addPharmacy(pharmacy: pharmacy, pharmacyType: "My Pharmacies")
            addPharmacyToServersDB(pharmacy: pharmacy) { success in
                
            }
            self.heartButton.setImage(UIImage(named: "selected"), for: .normal)
            infoButton.isHidden = false
            self.pulleyViewController?.setNeedsSupportedDrawerPositionsUpdate()


        }
       
       // goBack()
    }
    
    
    func addPharmacyToServersDB(pharmacy: Pharmacy1,completionHandler:@escaping (_ Success:Bool)->Void ){
        
        //let number = MapItem.phoneNumber?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
       // print(number)
        let params = [
            "userid" : PreferenceHelper().getId(),
            "brand" : pharmacy.name,
            "choice" : "0",
            "address":pharmacy.address,
            "phone_number":pharmacy.phone,
            "latitude":pharmacy.coordinates?.latitude ?? "39.111541",
            "longitude":pharmacy.coordinates?.longitude ?? "-82.272293"
            ] as [String : Any]
        
        Alamofire.request(DataUtils.APIURL + DataUtils.Pharmacy_URL,method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                
                debugPrint(response);
                
                if let data = response.result.value {
                    print("JSON: \(data)")
                    let json : [String:Any] = data as! [String : Any]
                    let result = json["status"] as? String
                    if result == "true" {
                        completionHandler(true)
                    } else {
                        DataUtils.messageShow(view: self, message: "can't get user data", title: "")
                    }
                }
            })
    }
    func deletePharmacyFromServersDB(pharmacyId: Int,completionHandler:@escaping (_ Success:Bool)->Void ){

        let params = [
            "pharmaceid" : pharmacyId,
            ] as [String : Any]
        
        Alamofire.request(DataUtils.APIURL + DataUtils.Pharmacy_URL,method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                
                debugPrint(response);
                
                if let data = response.result.value {
                    print("JSON: \(data)")
                    let json : [String:Any] = data as! [String : Any]
                    let result = json["status"] as? String
                    if result == "true" {
                        completionHandler(true)
                    } else {
                        DataUtils.messageShow(view: self, message: "can't get user data", title: "")
                    }
                }
            })
    }
    @IBAction func infoTapped(_ sender: Any) {
        pulleyViewController?.setDrawerPosition(position: .partiallyRevealed, animated: true)
    }
    
    func openMapForPlace() {
        
        let latitude: CLLocationDegrees = pharmacy.coordinates!.latitude
        let longitude: CLLocationDegrees = pharmacy.coordinates!.longitude
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = pharmacy.name
        mapItem.openInMaps(launchOptions: options)
    }
    
    
   @objc func goBack()  {
        let drawerPharmacyViewController = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "DrawerPharmacyViewController") as? DrawerPharmacyViewController
        self.pulleyViewController?.setDrawerContentViewController(controller: drawerPharmacyViewController!, animated: false)
        drawerPharmacyViewController?.openDrawer()
    }
    
    @IBAction func barTapped(_ sender: Any) {
//        if pulleyViewController?.drawerPosition == .partiallyRevealed {
//            pulleyViewController?.setDrawerPosition(position: .collapsed, animated: true)
//        } else if pulleyViewController?.drawerPosition == .collapsed {
//            pulleyViewController?.setDrawerPosition(position: .partiallyRevealed, animated: true)
//
//        }
    }
    
    
    fileprivate func setupView() {
        prescriptionBackground.layer.cornerRadius = 20.0
        prescriptionBackground.layer.shadowColor = UIColor.darkGray.cgColor
        prescriptionBackground.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        prescriptionBackground.layer.shadowRadius = 3.0
        prescriptionBackground.layer.shadowOpacity = 0.2
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
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}

extension PharmacyInfoViewController: PulleyDrawerViewControllerDelegate {
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat
    {
        // For devices with a bottom safe area, we want to make our drawer taller. Your implementation may not want to do that. In that case, disregard the bottomSafeArea value.
        return 336.0 + (pulleyViewController?.currentDisplayMode == .drawer ? bottomSafeArea : 0.0)
    }
    
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat
    {
        // For devices with a bottom safe area, we want to make our drawer taller. Your implementation may not want to do that. In that case, disregard the bottomSafeArea value.
        return 163.0 + (pulleyViewController?.currentDisplayMode == .drawer ? bottomSafeArea : 0.0)
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        
        if heartButton.imageView?.image == UIImage(named: "deselected")  {
            return [.collapsed]

        } else {
            return [.collapsed, .partiallyRevealed]

        }
    }
    
    
}
