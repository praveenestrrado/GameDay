//
//  MapViewController.swift
//  GameDay
//
//  Created by MAC on 11/05/21.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import CoreLocation
class MapViewController: UIViewController,GMSMapViewDelegate, CLLocationManagerDelegate ,GMSAutocompleteViewControllerDelegate{

    struct MyPlace {
        var name: String
        var lat: Double
        var long: Double
    }
    var chosenPlace: MyPlace?

    let customMarkerWidth: Int = 50
    let customMarkerHeight: Int = 70
    let currentLocationMarker = GMSMarker()

    @IBOutlet weak var mapView: UIView!
    let previewDemoData = [(title: "PItch 1", img: #imageLiteral(resourceName: "OffIcon"), price: 10), (title: "Pitch 2", img: #imageLiteral(resourceName: "OffIcon"), price: 8), (title: "Pitch 3", img: #imageLiteral(resourceName: "OffIcon"), price: 12)]
        let locationManager = CLLocationManager()
    var GoogleMapView:GMSMapView!
    var geoCoder :CLGeocoder!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        myMapView.delegate=self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        // 2
        if CLLocationManager.locationServicesEnabled() {
          locationManager.delegate = self
          locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.startUpdatingLocation()
          
       
          
          
          }
      
      //  self.mapView?.isMyLocationEnabled = true
        let locationObj = locationManager.location
      let coord = locationObj?.coordinate
      let lattitude = coord?.latitude
      let longitude = coord?.longitude
      print(" lat in  updating \(String(describing: lattitude)) ")
      print(" long in  updating \(String(describing: longitude))")
        
        
        
        
        
      
        

    }
    
    func setupViews() {
        view.addSubview(myMapView)
        myMapView.topAnchor.constraint(equalTo: view.topAnchor).isActive=true
        myMapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        myMapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
        myMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 60).isActive=true
        
        
        
        self.view.addSubview(btnBack)
        btnBack.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 65).isActive=true
        btnBack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive=true
        btnBack.widthAnchor.constraint(equalToConstant: 50).isActive=true
        btnBack.heightAnchor.constraint(equalTo: btnBack.widthAnchor).isActive=true
        

        self.view.addSubview(btnMyLocation)
        btnMyLocation.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive=true
        btnMyLocation.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive=true
        btnMyLocation.widthAnchor.constraint(equalToConstant: 50).isActive=true
        btnMyLocation.heightAnchor.constraint(equalTo: btnMyLocation.widthAnchor).isActive=true
    }
    
    let btnMyLocation: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor.white
        btn.setImage(#imageLiteral(resourceName: "Football_Green"), for: .normal)
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        btn.tintColor = UIColor.gray
        btn.imageView?.tintColor=UIColor.gray
        btn.addTarget(self, action: #selector(btnMyLocationAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    let btnBack: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor.black
        btn.setTitle("Back", for: .normal)
        btn.layer.cornerRadius = 10
        btn.clipsToBounds=true
        btn.tintColor = UIColor.white
        btn.addTarget(self, action: #selector(btnMyLocationAction1), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    
    @objc func btnMyLocationAction() {
        let location: CLLocation? = myMapView.myLocation
        if location != nil {
            myMapView.animate(toLocation: (location?.coordinate)!)
        }
    }
    
    @objc func btnMyLocationAction1() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func initGoogleMaps() {
        
       
            
        let camera = GMSCameraPosition.camera(withLatitude: 28.7041, longitude: 77.1025, zoom: 12.0)
        self.myMapView.camera = camera
        self.myMapView.mapType = .hybrid
        self.myMapView.delegate = self
        self.myMapView.isMyLocationEnabled = true
    }
    // MARK: GOOGLE AUTO COMPLETE DELEGATE
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let lat = place.coordinate.latitude
        let long = place.coordinate.longitude
        
        showPartyMarkers(lat: lat, long: long)
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
        myMapView.camera = camera
        chosenPlace = MyPlace(name: place.formattedAddress!, lat: lat, long: long)
        let marker=GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.title = "\(place.name)"
        marker.snippet = "\(place.formattedAddress!)"
        marker.map = myMapView
        
        self.dismiss(animated: true, completion: nil) // dismiss after place selected
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("ERROR AUTO COMPLETE \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    let myMapView: GMSMapView = {
        let v=GMSMapView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    // MARK: CLLocation Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while getting location \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
        let location = locations.last
        let lat = (location?.coordinate.latitude)!
        let long = (location?.coordinate.longitude)!
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 14.0)
        
        self.myMapView.animate(to: camera)
        
        showPartyMarkers(lat: lat, long: long)
    }
    
    // MARK: GOOGLE MAP DELEGATE
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return false }
        let img = customMarkerView.img!
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img, borderColor: UIColor.black, tag: customMarkerView.tag)
        
        marker.iconView = customMarker
        marker.title = "Pitch Name" + String(customMarkerView.tag)
        marker.snippet = String(customMarkerView.tag)
        return false
    }
    
//    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
//        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return nil }
//        let data = previewDemoData[customMarkerView.tag]
//        restaurantPreviewView.setData(title: data.title, img: data.img, price: data.price)
//        return restaurantPreviewView
//    }
//
//    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
//        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
//        let tag = customMarkerView.tag
//        restaurantTapped(tag: tag)
//    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let img = customMarkerView.img!
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img, borderColor: UIColor.darkGray, tag: customMarkerView.tag)
        
        marker.iconView = customMarker
        marker.title = "Pitch Name" + String(customMarkerView.tag)
        marker.snippet = String(customMarkerView.tag)
        
        marker.iconView = customMarker
    }
    
    func showPartyMarkers(lat: Double, long: Double) {
        myMapView.clear()
        for i in 0..<3 {
            let randNum=Double(arc4random_uniform(50))/10000
            let marker=GMSMarker()
            let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: previewDemoData[i].img, borderColor: UIColor.darkGray, tag: i)
            marker.iconView=customMarker
            let randInt = arc4random_uniform(4)
            if randInt == 0 {
                marker.position = CLLocationCoordinate2D(latitude: lat+randNum, longitude: long-randNum)
            } else if randInt == 1 {
                marker.position = CLLocationCoordinate2D(latitude: lat-randNum, longitude: long+randNum)
            } else if randInt == 2 {
                marker.position = CLLocationCoordinate2D(latitude: lat-randNum, longitude: long-randNum)
            } else {
                marker.position = CLLocationCoordinate2D(latitude: lat+randNum, longitude: long+randNum)
            }
            marker.map = self.myMapView
        }
    }
    

    func imageWithView(view: UIView) -> UIImage {
        var image: UIImage?
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return image ?? UIImage()
    }
    @IBAction func ACtionBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ActionFavourites(_ sender: Any)
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "FavouritesViewController") as! FavouritesViewController
        self.navigationController?.pushViewController(next, animated: false)
    }
    @IBAction func ActionHome(_ sender: Any)
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(next, animated: false)
    }
    @IBAction func Actionprofile(_ sender: Any)
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(next, animated: false)
    }
    @IBAction func ActionContacts(_ sender: Any)
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
        self.navigationController?.pushViewController(next, animated: false)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


    func locationManager(
      _ manager: CLLocationManager,
      didChangeAuthorization status: CLAuthorizationStatus
    ) {
//      guard status == .authorizedWhenInUse else {
//        return
//      }
//      // 4
//      locationManager.requestLocation()

      //5
//      GoogleMapView.isMyLocationEnabled = true
//        GoogleMapView.settings.myLocationButton = true
        
        
//        switch status {
//                case .notDetermined:
//                    manager.requestAlwaysAuthorization()
//                    print("notDetermined")
//
//                    break
//                case .authorizedWhenInUse:
//                    manager.startUpdatingLocation()
//                    setupViews()
//                    initGoogleMaps()
//                    print("authorizedWhenInUse")
//                    break
//                case .authorizedAlways:
//                    manager.startUpdatingLocation()
//                    setupViews()
//                    initGoogleMaps()
//                    print("startUpdatingLocation")
//
//                    break
//                case .restricted:
//                    // restricted by e.g. parental controls. User can't enable Location Services
//                    print("restricted")
//                    self.setAlertMessages()
//
//                    break
//                case .denied:
//                    // user denied your app access to Location Services, but can grant access from Settings.app
//
//                    self.setAlertMessages()
//
//                    print("denied")
//
//                    break
//                }
        guard status == .authorizedWhenInUse else {
          return
        }
        manager.startUpdatingLocation()
                           setupViews()
                           initGoogleMaps()
                           print("startUpdatingLocation")
        
    }
}
