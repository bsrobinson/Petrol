//
//  Feeds.swift
//  Petrol
//
//  Created by Ben Robinson on 10/09/2024.
//

import Foundation
import UIKit

struct Feed {
    
    let supplier: String
    let url: URL
    
    var loadStatus = LoadStatus.notStarted
    
    var host: String {
        if let host = url.host {
            let hostParts = host.split(separator: ".")
            let parts = hostParts.suffix(2).joined() == "couk" ? 3 : 2
            return hostParts.suffix(parts).joined(separator: ".")
        }
        return "error"
    }
    
    init?(supplier: String, urlString: String, imageName: String? = nil, color: UIColor? = nil) {
        guard let url = URL(string: urlString) else { return nil }
        self.supplier = supplier
        self.url = url
    }
}

enum LoadStatus {
    case notStarted, started, loaded, error
}

class Feeds {
    
    var FeedList: [Feed] = []
    
    var progress: Double {
        let loaded = Double(FeedList.filter({ $0.loadStatus == .loaded || $0.loadStatus == .error }).count)
        return loaded / Double(FeedList.count)
    }
    var loading: Bool {
        progress < 1
    }
    
    init() {
        self.FeedList = [
            Feed(supplier: "Applegreen UK", urlString: "https://applegreenstores.com/fuel-prices/data.json"),
            Feed(supplier: "Ascona Group", urlString: "https://fuelprices.asconagroup.co.uk/newfuel.json"),
            Feed(supplier: "Asda", urlString: "https://storelocator.asda.com/fuel_prices_data.json"),
            Feed(supplier: "bp", urlString: "https://www.bp.com/en_gb/united-kingdom/home/fuelprices/fuel_prices_data.json"),
            Feed(supplier: "Esso Tesco Alliance", urlString: "https://fuelprices.esso.co.uk/latestdata.json"),
            Feed(supplier: "JET Retail UK", urlString: "https://jetlocal.co.uk/fuel_prices_data.json"),
            Feed(supplier: "Karan Retail Ltd", urlString: "https://api2.krlmedia.com/integration/live_price/krl"),
            Feed(supplier: "Morrisons", urlString: "https://www.morrisons.com/fuel-prices/fuel.json"),
            Feed(supplier: "Moto", urlString: "https://moto-way.com/fuel-price/fuel_prices.json"),
            Feed(supplier: "Motor Fuel Group", urlString: "https://fuel.motorfuelgroup.com/fuel_prices_data.json"),
            Feed(supplier: "Rontec", urlString: "https://www.rontec-servicestations.co.uk/fuel-prices/data/fuel_prices_data.json"),
            Feed(supplier: "Sainsbury’s", urlString: "https://api.sainsburys.co.uk/v1/exports/latest/fuel_prices_data.json"),
            Feed(supplier: "SGN", urlString: "https://www.sgnretail.uk/files/data/SGN_daily_fuel_prices.json"),
            Feed(supplier: "Shell", urlString: "https://www.shell.co.uk/fuel-prices-data.html"),
            Feed(supplier: "Tesco", urlString: "https://www.tesco.com/fuel_prices/fuel_prices_data.json"),
        ].compactMap( { $0 } )
    }
    
    func updateFeed(_ feed: Feed, status: LoadStatus) {
        Task { @MainActor in
            for i in FeedList.indices {
                if (FeedList[i].url == feed.url) {
                    FeedList[i].loadStatus = status
                }
            }
        }
    }
}
