//
//  Updater.swift
//  Petrol
//
//  Created by Ben Robinson on 10/09/2024.
//

import Foundation

actor FeedLoader {
    
    func getStations(_ feed: Feed) async -> [Station] {
        
        print("Getting stations in \(feed.supplier)")
        var stations: [Station] = []
        let brands = Brands()
        
        if let updatedFeed = await getFeed(feed) {
            if let updatedDate = updatedFeed.last_updated.toDate() {
                for station in updatedFeed.stations {
                    if let station = Station(feed: feed, station: station, updated: updatedDate, brands: brands) {
                        stations.append(station)
                    }
                }
            }
        }
        
        return stations
        
    }
        
    func getFeed(_ feed: Feed) async -> FeedModel.Root? {
        
        let request = URLRequest(url: feed.url)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            let status = (response as? HTTPURLResponse)?.statusCode
            if status != 200 {
                print("Updater: HTTP Error \(status ?? -1)")
            }
            
            let decoder = JSONDecoder()
            let feed = try decoder.decode(FeedModel.Root.self, from: data)
            
            return feed
            
        }
        catch {
            print("Feed error in \(feed.supplier) - \(error)")
        }
        
        return nil
        
    }
}
