//
//  CurrentMapViewController.swift
//  GameDay
//
//  Created by MAC on 15/05/21.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON


class CurrentMapViewController: UIViewController, GMSMapViewDelegate, UIGestureRecognizerDelegate  {
   
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet var pinImage: UIImageView!
    
    let locationManager = CLLocationManager()
    var GoogleMapView:GMSMapView!
    var geoCoder :CLGeocoder!
    
    let previewDemoData = [(title: "PItch 1", img: #imageLiteral(resourceName: "OffIcon"), price: 10), (title: "Pitch 2", img: #imageLiteral(resourceName: "OffIcon"), price: 8), (title: "Pitch 3", img: #imageLiteral(resourceName: "OffIcon"), price: 12)]
    let customMarkerWidth: Int = 35
    let customMarkerHeight: Int = 35
    override func viewDidLoad() {
        super.viewDidLoad()
        let locale = Locale.current
        print(locale.regionCode)

        // Disable swipe-to-pop gesture
                navigationController?.interactivePopGestureRecognizer?.delegate = self
                navigationController?.interactivePopGestureRecognizer?.isEnabled = false

                // Detect swipe gesture to load next entry
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeNextEntry)))
        
        // Do any additional setup after loading the view.
        // 1
          locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()

          // 2
          if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.startUpdatingLocation()
            
         
            
            
            }
        
        //  self.mapView?.isMyLocationEnabled = true
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    @objc func swipeNextEntry(_ sender: UIPanGestureRecognizer) {
          print("[DEBUG] Pan Gesture Detected")

          if (sender.state == .ended) {
              let velocity = sender.velocity(in: self.view)

              if (velocity.x > 0) { // Coming from left
                self.navigationController?.popViewController(animated: true)

              }
          }
      }
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if (gesture){
            print("dragged")
        }
    }
    //Mark: Marker methods
       func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
           print("Position of marker is = \(marker.position.latitude),\(marker.position.longitude)")
           reverseGeocoding(marker: marker)
       print("Position of marker is = \(marker.position.latitude),\(marker.position.longitude)")
       }
      func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
           print("didBeginDragging")
       }
       func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
           print("didDrag")
       }
    //Mark: Reverse GeoCoding
    func reverseGeocoding(marker: GMSMarker) {
        let geocoder = GMSGeocoder()
        let coordinate = CLLocationCoordinate2DMake(Double(marker.position.latitude),Double(marker.position.longitude))
        
        var currentAddress = String()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                
                print("Response is = \(address)")
                print("Response is = \(lines)")
                
                currentAddress = lines.joined(separator: "\n")
                
            }
            marker.title = currentAddress
//                marker.map = self.mapView
        }
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//        destinationMarker.position = position.target
//        print(destinationMarker.position)
    }
    
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition)
    {
            
            let lat = position.target.latitude
            let lng = position.target.longitude
            
            // Create Location
            let location = CLLocation(latitude: lat, longitude: lng)
        let geocoder = CLGeocoder()
        let sharedData = SharedDefault()

            // Geocode Location
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let placemarks = placemarks{
                    if let location = placemarks.first?.location{
                        //self.addressTextField.text = (placemarks.first?.name ?? "")+" "+(placemarks.first?.subLocality ?? " ")
                        if let addressDict = (placemarks.first?.addressDictionary as? NSDictionary){
                            let dict = JSON(addressDict)
                            
//                            if self.bNotInTheRegion == false
//                            {
                                sharedData.setLandMArk(loginStatus: dict["Thoroughfare"].stringValue)

                                sharedData.setZipCode(loginStatus: dict["ZIP"].stringValue)

                                sharedData.setRoadName(loginStatus: dict["Street"].stringValue)

                                sharedData.setFlatName(loginStatus: dict["Name"].stringValue)

                                sharedData.setCity(loginStatus:  dict["City"].stringValue)
                         
           
                            print("Selected country code", dict["CountryCode"].stringValue)
                            

                            var address:String = ""
                            for data in dict["FormattedAddressLines"].arrayValue{
                                address = address+" "+data.stringValue
                                
                                print("address getted ",address)
                            }
                                        
                         // here you will get the Address.
     
     
                        }
                    }
                }
            
            }
        }
    
    
    
func reverseGeocode(coordinate: CLLocationCoordinate2D) {
    // 1
    let geocoder = GMSGeocoder()

    // 2
    geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
      guard
        let address = response?.firstResult(),
        let lines = address.lines
        else {
          return
      }
      let locale = Locale.current


      print(locale.regionCode as Any)
      
     
    }
      
      // 1
      let labelHeight = self.addressLabel.intrinsicContentSize.height
      let topInset = self.view.safeAreaInsets.top
      self.GoogleMapView.padding = UIEdgeInsets(
        top: topInset,
        left: 0,
        bottom: labelHeight,
        right: 0)

  }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//      mapCenterPinImage.fadeOut(0.25)
      return false
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
//      mapCenterPinImage.fadeIn(0.25)
      mapView.selectedMarker = nil
      return false
    }
    func showPartyMarkers(lat: Double, long: Double) {
        GoogleMapView.clear()
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
            marker.map = self.GoogleMapView
        }
    }
    

    
    @IBAction func ActionBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}
extension CurrentMapViewController: CLLocationManagerDelegate {
    // 2
    func locationManager(
      _ manager: CLLocationManager,
      didChangeAuthorization status: CLAuthorizationStatus
    ) {
      // 3
//      guard status == .authorizedWhenInUse else {
//        return
//      }
//      // 4
//      locationManager.requestLocation()
//
//      //5
//      GoogleMapView.isMyLocationEnabled = true
//        GoogleMapView.settings.myLocationButton = true
        
        
        switch status {
                case .notDetermined:
                    manager.requestAlwaysAuthorization()
                    print("notDetermined")

                    break
                case .authorizedWhenInUse:
                    manager.startUpdatingLocation()
                    let locationObj = locationManager.location
                  let coord = locationObj?.coordinate
                  let lattitude = coord?.latitude
                  let longitude = coord?.longitude
                  print(" lat in  updating \(String(describing: lattitude)) ")
                  print(" long in  updating \(String(describing: longitude))")
                    
                    
                  if lattitude == nil || longitude == nil
                  {
                      
                  }
                  else
                  {
                  let camera = GMSCameraPosition.camera(withLatitude:(locationObj?.coordinate.latitude)!, longitude: (locationObj?.coordinate.longitude)!, zoom: 12)
                      GoogleMapView = GMSMapView.map(withFrame: CGRect(x: -15, y: 0, width: self.mapView.frame.width, height: self.mapView.frame.height), camera: camera)
                            GoogleMapView.delegate = self
                      GoogleMapView.clear()

                            self.mapView.addSubview(GoogleMapView)
                            self.mapView.bringSubviewToFront(pinImage)
              
                  }
                    print("authorizedWhenInUse")
                    break
                case .authorizedAlways:
                    manager.startUpdatingLocation()
                    print("startUpdatingLocation")
                    let locationObj = locationManager.location
                  let coord = locationObj?.coordinate
                  let lattitude = coord?.latitude
                  let longitude = coord?.longitude
                  print(" lat in  updating \(String(describing: lattitude)) ")
                  print(" long in  updating \(String(describing: longitude))")
                    
                    
                  if lattitude == nil || longitude == nil
                  {
                      
                  }
                  else
                  {
                  let camera = GMSCameraPosition.camera(withLatitude:(locationObj?.coordinate.latitude)!, longitude: (locationObj?.coordinate.longitude)!, zoom: 12)
                      GoogleMapView = GMSMapView.map(withFrame: CGRect(x: -15, y: 0, width: self.mapView.frame.width, height: self.mapView.frame.height), camera: camera)
                            GoogleMapView.delegate = self
                      GoogleMapView.clear()

                            self.mapView.addSubview(GoogleMapView)
                            self.mapView.bringSubviewToFront(pinImage)
              
                  }
                    break
                case .restricted:
                    // restricted by e.g. parental controls. User can't enable Location Services
                    print("restricted")
                    self.setAlertMessages()
                    break
                case .denied:

                    self.setAlertMessages()

                    print("denied")

                    break
                }

//        guard status == .authorizedWhenInUse else {
//                manager.startUpdatingLocation()
//          return
//        }
        
    }

    // 6
    func locationManager(
      _ manager: CLLocationManager,
      didUpdateLocations locations: [CLLocation]) {
      guard let location = locations.first else {
        return
      }

        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
        let locationa = locations.last
        let lat = (locationa?.coordinate.latitude)!
        let long = (locationa?.coordinate.longitude)!
        _ = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 14.0)
        
//        self.mapView.animate(to: camera)
        
        showPartyMarkers(lat: lat, long: long)
        
        
        
      // 7
      GoogleMapView.camera = GMSCameraPosition(
        target: location.coordinate,
        zoom: 15,
        bearing: 0,
        viewingAngle: 0)
    }

    // 8
    func locationManager(
      _ manager: CLLocationManager,
      didFailWithError error: Error
    ) {
      print(error)
    }
  }
