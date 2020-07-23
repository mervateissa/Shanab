//
//  LocationVC.swift
//  Shanab
//
//  Created by Macbook on 5/4/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import MapKit
class LocationVC: UIViewController {
    @IBOutlet weak var locationConfirmation: UIButton!
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var MapView: MKMapView!
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 300
    var perviousLocation: CLLocation?
    let geoCoder = CLGeocoder()
    var lat = Double()
    var long = Double()
    var view_controller = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        checklocationAuthorization()
        setupLocationManager()
        startTackingUserLocation()
        
    }
    
    func handleLongPress (gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint: CGPoint = gestureRecognizer.location(in: MapView)
            let newCoordinate: CLLocationCoordinate2D = MapView.convert(touchPoint, toCoordinateFrom: MapView)
            addAnnotationOnLocation(pointedCoordinate: newCoordinate)
        }
    }
    
    func addAnnotationOnLocation(pointedCoordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = pointedCoordinate
        
        guard let previousLocation = self.perviousLocation else { return }
        geoCoder.reverseGeocodeLocation(previousLocation) { [weak self] (Placemark, error) in
            guard  let self = self else {return}
            if error != nil {
                print("sorry for it")
                return
                
            }
            guard  let Placemark = Placemark?.first else {
                return
            }
            
            let streetNumber = Placemark.subThoroughfare ?? ""
            let streetName = Placemark.thoroughfare ?? ""
            DispatchQueue.main.async {
                self.LocationLabel.text = "\(streetNumber) \(streetName)"
                annotation.subtitle = (Placemark.subThoroughfare ?? "") + " " + (Placemark.thoroughfare ?? "")
                annotation.title = (Placemark.subThoroughfare ?? "") + " " + (Placemark.thoroughfare ?? "")
            }
            
        }
        MapView.removeAnnotations(self.MapView.annotations)
        MapView.addAnnotation(annotation)
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        MapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            MapView.setRegion(region, animated: true)
        }
    }
    @IBAction func LocationConfirmation(_ sender: Any) {
        UserDefaults.standard.set(self.LocationLabel.text ?? "", forKey: "Address")
        self.navigationController?.popViewController(animated: true)
        
    }
    func checklocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            MapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            
            break
        case .denied:
            locationManager.requestWhenInUseAuthorization()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            locationManager.requestWhenInUseAuthorization()
            break
        case .authorizedAlways:
            MapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
            
        @unknown default:
            fatalError()
        }
    }
    func startTackingUserLocation() {
        MapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        perviousLocation = getCenterLocation(for: MapView)
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(perviousLocation!) { [weak self] (Placemark, error) in
            guard  let self = self else {return}
            if error != nil {
                print("sorry for it")
                return
                
            }
            guard  let Placemark = Placemark?.first else {
                return
            }
            let streetNumber = Placemark.subThoroughfare ?? ""
            let streetName = Placemark.thoroughfare ?? ""
            DispatchQueue.main.async {
                self.LocationLabel.text = "\(streetNumber) \(streetName)"
                
            }
            
        }
    }
    
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longtitude = mapView.centerCoordinate.longitude
        self.long = longtitude
        self.lat = latitude
        UserDefaults.standard.set(self.long, forKey: "Longitude")
        UserDefaults.standard.set(self.lat, forKey: "Latitude")
        
        self.addAnnotationOnLocation(pointedCoordinate: CLLocationCoordinate2D(latitude: self.lat, longitude: self.long))
        return CLLocation(latitude: latitude, longitude: longtitude)
    }
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checklocationAuthorization()
        } else {
            print("Please turn on your location")
        }
    }
    func handleTap(gestureReconizer: UILongPressGestureRecognizer) {
        
        let location = gestureReconizer.location(in: MapView)
        let coordinate = MapView.convert(location,toCoordinateFrom: MapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        MapView.addAnnotation(annotation)
    }
    
}

extension LocationVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checklocationAuthorization()
    }
    
}
extension LocationVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        guard let previousLocation = self.perviousLocation else { return }
        guard center.distance(from: previousLocation) > 50 else {return}
        perviousLocation = center
        guard self.perviousLocation != nil else {return}
        geoCoder.reverseGeocodeLocation(center) { [weak self] (Placemark, error) in
            guard  let self = self else {return}
            if error != nil {
                print("sorry for it")
                return
                
            }
            guard  let Placemark = Placemark?.first else {
                return
            }
            let streetNumber = Placemark.subThoroughfare ?? ""
            let streetName = Placemark.thoroughfare ?? ""
            DispatchQueue.main.async {
                self.LocationLabel.text = "\(streetNumber) \(streetName)"
            }
            
        }
        
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated: Bool) {
        let center = getCenterLocation(for: mapView)
        
        guard let previousLocation = self.perviousLocation else { return }
        guard center.distance(from: previousLocation) > 50 else {return}
        perviousLocation = center
        guard self.perviousLocation != nil else {return}
        geoCoder.reverseGeocodeLocation(center) { [weak self] (Placemark, error) in
            guard  let self = self else {return}
            if error != nil {
                print("sorry for it")
                return
                
            }
            guard  let Placemark = Placemark?.first else {
                return
            }
            let streetNumber = Placemark.subThoroughfare ?? ""
            let streetName = Placemark.thoroughfare ?? ""
            DispatchQueue.main.async {
                self.LocationLabel.text = "\(streetNumber) \(streetName)"
            }
            
        }
    }
    
    
    
}
