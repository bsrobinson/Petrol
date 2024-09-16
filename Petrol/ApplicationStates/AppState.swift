//
//  AppState.swift
//  Petrol
//
//  Created by Ben Robinson on 10/09/2024.
//

import Foundation

class AppState: NSObject, ObservableObject {
    
    static let shared = AppState()
    
    @Published var loading = true
    
    @Published var stations: [Station] = []
    
    @Published var feeds = Feeds()
    
    @Published var selectedStations: [Station] = []
    @Published var visibleStations: [Station] = []
    
    var showStationSheet: Bool {
        set {
            selectedStations = newValue ? selectedStations : []
        }
        get {
            selectedStations.count > 0
        }
    }
    
    override init() {
        super.init()
        
        _ = LocationState.shared
        
        for feed in feeds.FeedList {
            Task.detached(priority: .background) { await self.getPrices(feed) }
        }
    }
    
    func getPrices(_ feed: Feed) async {
        
        let task = Task.detached(priority: .background) {
            self.feeds.updateFeed(feed, status: .started)
            return await FeedLoader().getStations(feed)
        }
        do {
            _ = try await Task { @MainActor in
                self.stations.append(contentsOf: await task.value)
                feeds.updateFeed(feed, status: .loaded)
                return true
            }.result.get()
        }
        catch {
            feeds.updateFeed(feed, status: .error)
        }
    }
}
