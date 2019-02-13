//
//  MapViewController.swift
//  MyTravels
//
//  Created by Maurício Oliveira on 13/02/2019.
//  Copyright © 2019 Maurício Oliveira. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    var locationManager = CLLocationManager ()
    var travel: Dictionary<String,String> = [:]
    var selectedIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let index = selectedIndex {
            if index == -1 {
                configLocationManager()
            } else {
                showAnnotation(travel: travel)
            }
        }
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(mark(gesture:)))
        gestureRecognizer.minimumPressDuration = 2
        
        map.addGestureRecognizer(gestureRecognizer)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        
        //show map
        let center = CLLocationCoordinate2D (latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        self.map.setRegion(region, animated: true)
    }
    
    func showMap (lat: Double, lon: Double) {
        let center = CLLocationCoordinate2D (latitude: lat, longitude: lon)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        self.map.setRegion(region, animated: true)
    }
    
    func showAnnotation (travel: Dictionary<String,String>) {
        
        if let localTravel = travel["local"] {
            
            if let latS = travel["latitude"] {
                
                if let lonS = travel["longitude"] {
                    
                    if let lat = Double(latS) {
                        
                        if let lon = Double(lonS) {
                            
                            //show annotation
                            let annotation = MKPointAnnotation()
                            annotation.coordinate.latitude = lat
                            annotation.coordinate.longitude = lon
                            annotation.title = localTravel
                            self.map.addAnnotation(annotation)
                            
                            //show map
                            showMap (lat: lat, lon: lon)
                        }
                        
                    }
                    
                }
            }
        }
    }
    
    @objc func mark(gesture: UIGestureRecognizer) {
        
        if gesture.state == UIGestureRecognizer.State.began {
            
            //recuperar ponto selecionado
            let point = gesture.location(in: self.map)
            let coordinates = map.convert(point, toCoordinateFrom: self.map)
            
            //Reverse
            let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
            
            var completeLocal = "Address not found!"
            
            CLGeocoder().reverseGeocodeLocation(location) { (localDetails, error) in
                if (error == nil) {
                    if let local = localDetails?.first {
                        
                        if local.name != nil {
                            completeLocal = local.name!
                        } else {
                            if local.thoroughfare != nil {
                                completeLocal = local.thoroughfare!
                            }
                        }
                    }
                    //save point
                    self.travel = ["local": completeLocal , "latitude": String(coordinates.latitude) , "longitude" : String(coordinates.longitude)]
                    SaveData().saveTravel(travel: self.travel)
                    
                    //show annotation
                    self.showAnnotation(travel: self.travel)
                }
            }
        }
        
    }
    
    func configLocationManager () {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if (status == .denied) {
            
            let alertController = UIAlertController(title: "Location Permission", message: "Needed location permission", preferredStyle: .alert)
            
            let configAction = UIAlertAction(title: "Open Configs", style: .default) { (actionConfig) in
                
                if let config = NSURL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(config as URL)
                }
                
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            
            alertController.addAction(configAction)
            alertController.addAction(cancel)
            
            present(alertController, animated: true, completion: nil)
            
        }
    }
    
}
