//
//  Price.swift
//  Petrol
//
//  Created by Ben Robinson on 10/09/2024.
//

import Foundation
import MapKit

struct Station: Identifiable, Equatable {
    
    let feed: Feed
    var updated: Date
    
    let id = UUID() //site_id from feed can fail to be unique (i.e. Asda on A45 in Northampton, two sites on either side of the road have the same site_id)
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let prices: [String:Double]
    let brand: Brand
    
    var milesAway: Int?
    
    var relativeUpdated: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: updated, relativeTo: Date())
    }
    
    init?(feed: Feed, station: FeedModel.Station, updated: Date, brands: Brands) {
        
        if station.location.latitude == 0 && station.location.longitude == 0 {
            return nil
        }
        
        self.feed = feed
        self.updated = updated
        
        self.name = station.brand?.trim() ?? "Unknown name"
        self.address = "\(station.address.trim())  \(station.postcode.trim())"
        self.coordinate = CLLocationCoordinate2D(latitude: station.location.latitude, longitude: station.location.longitude)
        self.prices = station.prices.filter({ $0.value != nil && $0.value! > 0 }) as! [String:Double]
        self.brand = brands.findBy(name: station.brand ?? "")
    }
    
    static func == (lhs: Station, rhs: Station) -> Bool {
        lhs.id == rhs.id
    }
}
