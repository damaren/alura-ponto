//
//  Location.swift
//  AluraPonto
//
//  Created by Jose Luis Damaren Junior on 22/04/23.
//

import Foundation
import CoreLocation

protocol LocationDelegate: AnyObject {
    func updateUserLocation(latitude: Double?, longitude: Double?)
}

class Location: NSObject {
    private var latitude: CLLocationDegrees?
    private var longitude: CLLocationDegrees?
    
    weak var delegate: LocationDelegate?
    
    func askPermission(_ locationManager: CLLocationManager) {
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
            case .denied:
                break
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            default:
                break
            }
        }
    }
}

extension Location: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let local = locations.first {
            latitude = local.coordinate.latitude
            longitude = local.coordinate.longitude
            delegate?.updateUserLocation(latitude: latitude, longitude: longitude)
        }
    }
}
