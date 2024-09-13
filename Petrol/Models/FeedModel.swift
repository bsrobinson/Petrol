//
//  Prices.swift
//  Petrol
//
//  Created by Ben Robinson on 10/09/2024.
//

import Foundation

struct FeedModel {
    
    struct Root: Codable {
        let last_updated: String
        let stations: [Station]
    }
    
    struct Station: Codable {
        let site_id: String
        let brand: String?
        let address: String
        let postcode: String
        let location: StationLocation
        let prices: [String:Double?]
    }
    
    struct StationLocation: Codable {
        let latitude: Double
        let longitude: Double
        
        // Thanks: https://stackoverflow.com/a/71168320/404459
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            
            if let theString = try? values.decode(String.self, forKey: .latitude),
               let latitude = Double(theString) {
                self.latitude = latitude
            } else {
                self.latitude = try values.decode(Double.self, forKey: .latitude)
            }
            
            if let theString = try? values.decode(String.self, forKey: .longitude),
               let longitude = Double(theString) {
                self.longitude = longitude
            } else {
                self.longitude = try values.decode(Double.self, forKey: .longitude)
            }
        }
    }
}
