//
//  DistanceCache.swift
//  TheFestivalsApp
//
//  Created by Ben Robinson on 11/02/2024.
//

import Foundation
import MapKit

class LocationState: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    static let shared = LocationState()
    
    @Published var myLocation: CLLocation?
    
    let locationManager = CLLocationManager()
    private var locationLastUpdated: Date = .distantPast
    
    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            //only update every 60 seconds
            if Date().timeIntervalSince1970 - locationLastUpdated.timeIntervalSince1970 > 60 {
                myLocation = location
                locationLastUpdated = Date()
            }
        }
    }
}
