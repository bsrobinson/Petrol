//
//  StationAnnotation.swift
//  Petrol
//
//  Created by Ben Robinson on 11/09/2024.
//

import SwiftUI
import MapKit

class StationAnnotation: NSObject, MKAnnotation {
    
    var station: Station
    
    var title: String? {
        String(station.prices[Defaults.fuel.type] ?? -1)
    }
    var coordinate: CLLocationCoordinate2D {
        station.coordinate
    }
    
    init(_ station: Station) {
        self.station = station
    }
}

class StationAnnotationView: MKMarkerAnnotationView, UIGestureRecognizerDelegate {
    
    unowned let map: MKMapView
    
    init(annotation: MKAnnotation?, reuseIdentifier: String?, map: MKMapView) {

        self.map = map

        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "clustering"
        titleVisibility = .visible
        
        if let annotation = annotation as? StationAnnotation {
            glyphImage = OriginalUIImage(named: annotation.station.brand.image)
            markerTintColor = annotation.station.brand.bgColour
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

//Thanks: https://stackoverflow.com/a/65970545/404459
class OriginalUIImage: UIImage {

    convenience init?(named name: String) {
        guard let image = UIImage(named: name),
              nil != image.cgImage else {
                    return nil
        }
        self.init(cgImage: image.cgImage!)
    }

    override func withRenderingMode(_ renderingMode: UIImage.RenderingMode) -> UIImage {
        return super.withRenderingMode(.alwaysOriginal)
    }
}

#Preview {
    ContentView()
}
