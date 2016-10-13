//
//  LocationManager.swift
//  Selfme
//
//  Created by Clayton Cohn on 10/12/16.
//  Copyright © 2016 Radhatter, LLC. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject {
    let manager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    var onLocationFix: ((CLPlacemark?, NSError?) -> Void)?
    
    override init() {
        super.init()
        manager.delegate = self
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            getPermission()
        } else {
            manager.requestLocation()
        }
    }
    
    private func getPermission() {
        manager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alertController = UIAlertController(
            title: "Unable to Determine Location",
            message: "Sorry, we were unable to determine your current location.\nPlease make sure that location services for Selfme are enabled When In Use.",
            preferredStyle: .alert)
        let cancelAction = UIAlertAction(
            title: "Ok",
            style: .cancel,
            handler: nil)
        alertController.addAction(cancelAction)
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let onLocationFix = self.onLocationFix {
                onLocationFix(placemarks?.first, error as NSError?)
            }
        }
    }
    
    func presentLocationAuthorizationController() {
        let alertController = UIAlertController(
            title: "Enable Location",
            message: "You must let Selfme recognize your location in order to map your selfies.",
            preferredStyle: .alert)
        let cancelAction = UIAlertAction(
            title: "Ok",
            style: .cancel,
            handler: nil)
        alertController.addAction(cancelAction)
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
}
