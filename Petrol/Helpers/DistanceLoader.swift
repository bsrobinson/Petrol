//
//  DistanceLoader.swift
//  Petrol
//
//  Created by Ben Robinson on 12/09/2024.
//

import Foundation
import MapKit

func LoadDistanceInMiles(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) async -> Int? {
    
    let request = MKDirections.Request()
    request.source = MKMapItem(placemark: MKPlacemark(coordinate: from))
    request.destination = MKMapItem(placemark: MKPlacemark(coordinate: to))
    request.transportType = .automobile
    
    do {
        let response = try await MKDirections(request: request).calculate()
        if response.routes.count > 0 {
            let meters = Measurement(value: response.routes[0].distance, unit: UnitLength.meters)
            let miles = meters.converted(to: UnitLength.miles)
            return Int(miles.value.rounded())
        } else {
            return nil
        }
    }
    catch {
        print("Error getting driving distance from \(from) to \(to) (\(error.localizedDescription))")
        return nil
    }
}
