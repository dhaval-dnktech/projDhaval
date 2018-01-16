//
//  Location.swift
//  Cubber
//
//  Created by Vyas Kishan on 26/07/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class Location: NSObject, CLLocationManagerDelegate , UIApplicationDelegate {

    let locationManager = CLLocationManager()
    internal var longitude: String = " "
    internal var latitude: String = " "
    

    
    override init() {
        super.init()
    /*   if CLLocationManager.locationServicesEnabled()  {
            let authorizationStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
            if authorizationStatus == CLAuthorizationStatus.denied || authorizationStatus == CLAuthorizationStatus.restricted || authorizationStatus == CLAuthorizationStatus.notDetermined { print("Authorization Status Falied") }
            else { self.initializeLocationManager() }
        }
        else { print("Location Service Enable False") } */
        self.initializeLocationManager()
    }
    
    fileprivate func initializeLocationManager() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone;
        
        //For use in foreground
     //   self.locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
    }
    
    //MARK: CLLOCATIONMANAGER DELEGATE
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        let long = "\(userLocation.coordinate.longitude)"
        let lat = "\(userLocation.coordinate.latitude)"
        self.locationManager.stopUpdatingLocation()
        self.longitude = long
        self.latitude = lat
    }
   
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted || status == CLAuthorizationStatus.notDetermined { print("Authorization Status Falied") }
        else { self.initializeLocationManager() }
    }
}
