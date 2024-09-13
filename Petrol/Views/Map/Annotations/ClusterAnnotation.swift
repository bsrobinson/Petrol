//
//  ClusterAnnotation.swift
//  Petrol
//
//  Created by Ben Robinson on 11/09/2024.
//

import SwiftUI
import MapKit

class ClusteredAnnotationView: MKMarkerAnnotationView, UIGestureRecognizerDelegate {
    
    unowned let map: MKMapView
    
    init(annotation: MKAnnotation?, reuseIdentifier: String?, map: MKMapView) {
        
        self.map = map
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        titleVisibility = .visible
        
        if let cluster = annotation as? MKClusterAnnotation {
            
            let stations = cluster.memberStations()
            
            let prices = stations.compactMap { $0.prices[Defaults.fuel.type] }
            let minPrice = prices.min() ?? -1
            let maxPrice = prices.max() ?? -1
            
            cluster.title = String(minPrice)
            cluster.subtitle = minPrice != maxPrice ? "+ \(stations.count - 1) higher" : ""
        }
        
        setupGestureRecognizerToPreventInteractionDelay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Thanks: https://stackoverflow.com/questions/35639388/
    private func setupGestureRecognizerToPreventInteractionDelay() {
        let quickSelectGestureRecognizer = UITapGestureRecognizer()
        
        quickSelectGestureRecognizer.delaysTouchesBegan = false
        quickSelectGestureRecognizer.delaysTouchesEnded = false
        quickSelectGestureRecognizer.numberOfTapsRequired = 1
        quickSelectGestureRecognizer.numberOfTouchesRequired = 1
        quickSelectGestureRecognizer.delegate = self
        
        addGestureRecognizer(quickSelectGestureRecognizer)
    }
    
    @objc func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        map.isZoomEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.map.isZoomEnabled = true
        }
        
        return false
    }
}

extension MKClusterAnnotation {
    func memberStations() -> [Station] {
        var stations: [Station] = []
        for member in memberAnnotations {
            if let stationAnnotation = member as? StationAnnotation {
                stations.append(stationAnnotation.station)
            }
        }
        return stations
    }
}

#Preview {
    ContentView()
}
