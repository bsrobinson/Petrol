//
//  MapView.swift
//  Petrol
//
//  Created by Ben Robinson on 10/09/2024.
//

import SwiftUI
import MapKit

struct StationMap: UIViewRepresentable {
    
    @Binding var stations: [Station]
    @Binding var fuelType: String
    @Binding var selectedStations: [Station]
    @Binding var cheapestStationOnMap: StationAnnotation?
    
    @Binding var moveToUserLocation: Bool
    @Binding var openCheapest: Bool
    
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        var parent: StationMap
        var previousFuelType: String = ""
        
        init(_ parent: StationMap) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is StationAnnotation {
                return StationAnnotationView(
                    annotation: annotation,
                    reuseIdentifier: "marker",
                    map: mapView
                )
            }
            if let cluster = annotation as? MKClusterAnnotation {
                return ClusteredAnnotationView(
                    annotation: cluster,
                    reuseIdentifier: "cluster",
                    map: mapView
                )
            }
            
            return nil
        }
        
        func mapView(_ mapView: MKMapView, didSelect annotation: any MKAnnotation) {
            if let stationAnnotation = annotation as? StationAnnotation {
                AppState.shared.selectedStations = [stationAnnotation.station]
            }
            if let cluster = annotation as? MKClusterAnnotation {
                AppState.shared.selectedStations = cluster.memberStations().sorted(by: { ($0.prices[parent.fuelType] ?? -1) < ($1.prices[parent.fuelType] ?? -1) })
            }
        }
        
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            Task { @MainActor in
                AppState.shared.selectedStations = []
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        StationMap.Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView()
        view.delegate = context.coordinator
        view.showsUserLocation = true
        view.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 54, longitude: -2), span: MKCoordinateSpan(latitudeDelta: 6, longitudeDelta: 6)), animated: false)
        return view
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        
        if selectedStations.count == 0 {
            for selected in view.selectedAnnotations {
                view.deselectAnnotation(selected, animated: true)
            }
        }
        
        if moveToUserLocation {
            moveToUserLocation(view)
        }
        
        if openCheapest {
            openCheapest(view)
        }
        
        if context.coordinator.previousFuelType != fuelType {
            view.removeAnnotations(view.annotations)
            context.coordinator.previousFuelType = fuelType
        }
        let stationAnnotations = view.annotations.compactMap {
            if let stationAnnotation = $0 as? StationAnnotation { return stationAnnotation }
            return nil
        }
        for station in stations.filter({ $0.prices.keys.contains(fuelType) }) {
            if !stationAnnotations.contains(where: { $0.station.id == station.id }) {
                view.addAnnotation(StationAnnotation(station))
            }
        }
    }
    
    private func moveToUserLocation(_ mapView: MKMapView) {
        Task { @MainActor in
            moveToUserLocation = false
            
            if let location = LocationState.shared.myLocation {
                mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)), animated: true)
            }
        }
    }
    
    private func openCheapest(_ mapView: MKMapView) {

        Task { @MainActor in
            openCheapest = false
            
            let annotations = mapView.annotations(in: mapView.visibleMapRect)
            
            let stationAnnotations = annotations.compactMap { $0 as? StationAnnotation }
            let clusterAnnotations = annotations.compactMap { $0 as? MKClusterAnnotation }
            
            //problem here!:  https://stackoverflow.com/questions/78981722/
            
            if let cheapestStationOnMap = stationAnnotations.min(by: {
                $0.station.prices[fuelType] ?? 9999 < $1.station.prices[fuelType] ?? 9999
            }) {
                if let cheapestCluster = clusterAnnotations.first(where: { $0.title == cheapestStationOnMap.title }) {
                    mapView.selectAnnotation(cheapestCluster, animated: true)
                } else {
                    mapView.selectAnnotation(cheapestStationOnMap, animated: true)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
