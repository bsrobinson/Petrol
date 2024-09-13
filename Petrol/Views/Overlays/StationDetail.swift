//
//  StationDetail.swift
//  Petrol
//
//  Created by Ben Robinson on 11/09/2024.
//

import SwiftUI
import CoreLocation
import MapKit

struct StationDetail: View {
    
    @ObservedObject private var appState = AppState.shared
    @State private var selectedTab = ""
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            ForEach(appState.selectedStations) { station in
                StationDetailPage(station: station)
                    .tag(station.id)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: appState.selectedStations.count > 1 ? .always : .never))
        .onAppear() {
            UIPageControl.appearance().currentPageIndicatorTintColor = .label
            UIPageControl.appearance().pageIndicatorTintColor = .secondaryLabel
        }
    }
}


struct StationDetailPage: View {
    
    @ObservedObject private var appState = AppState.shared
    @ObservedObject private var fuel = Defaults.fuel
    @ObservedObject private var locationState = LocationState.shared
    @State private var locationChanged = false
    @State private var loadingDistance = false
    @State private var visible = false
    
    var station: Station
    
    func getDistance(to station: Station, from location: CLLocation? = nil) {
        if let location = location ?? locationState.myLocation {
            Task.detached(priority: .background) {
                let miles = await LoadDistanceInMiles(from: location.coordinate, to: station.coordinate)
                if let stationIndex = await appState.stations.firstIndex(where: { $0.id == station.id }) {
                    Task { @MainActor in
                        AppState.shared.stations[stationIndex].milesAway = miles
                        self.loadingDistance = false
                        self.locationChanged = false
                    }
                }
            }
        }
    }
    
    var body: some View {
        
        VStack {
            HStack(alignment: .top) {
                
                VStack {
                    ZStack {
                        Image(station.brand.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(8)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 75)
                    .background(Color(uiColor: station.brand.bgColour))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 1)) //for light mode
                    
                    Text(station.prices[fuel.type] ?? -1, format: .number)
                        .frame(maxWidth: .infinity)
                        .bold()
                        .padding(.vertical, 2)
                        .padding(.horizontal, 6)
                        .background(.black)
                        .foregroundColor(.green)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(.white, lineWidth: 1)) //for dark mode
                }
                .frame(width: 75)
                
                Spacer()
                    .frame(width: 15)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(station.brand.name ?? station.name)
                        .font(.title3)
                        .bold()
                    
                    Text(station.address)
                        .font(.subheadline)
                        .lineLimit(2, reservesSpace: true)
                        .textSelection(.enabled)
                    
                    Spacer()
                        .frame(height: 3)
                    
                    VStack(alignment: .leading) {
                        Text(station.feed.host)
                        Text(station.relativeUpdated)
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: station.coordinate))
                    mapItem.name = station.name
                    mapItem.openInMaps()
                }, label: {
                    VStack {
                        Image(systemName: "car.fill")
                            .font(.title2)
                        Spacer()
                            .frame(height: 3)
                        HStack {
                            if let miles = appState.stations.first(where: { $0.id == station.id })?.milesAway {
                                Text("\(miles) mi")
                            } else {
                                Text("Open Map")
                            }
                        }
                        .font(.caption)
                    }
                    .frame(width: 60)
                })
                .buttonStyle(.bordered)
            }
            .padding()
            
            Spacer()
        }
        .padding(.top)
        .onReceive(locationState.$myLocation) { location in
            if visible {
                getDistance(to: station, from: location)
            }
            locationChanged = true
        }
        .onAppear() {
            if !loadingDistance && locationChanged {
                getDistance(to: station, from: locationState.myLocation)
            }
        }
        .onDisappear() {
            visible = false
        }
    }
}
