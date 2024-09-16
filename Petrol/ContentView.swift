//
//  ContentView.swift
//  Petrol
//
//  Created by Ben Robinson on 10/09/2024.
//

//unable to move between pins
//progress in dark mode

import SwiftUI
import MapKit

struct ContentView: View {
    
    @ObservedObject private var appState = AppState.shared
    @ObservedObject private var locationState = LocationState.shared
    @ObservedObject private var fuel = Defaults.fuel
    
    @State private var moveToUserLocation = false
    @State private var movedToLoadedLocation = false

    @State private var openCheapest = false
    
    var body: some View {
        
        ZStack() {
                
            StationMap(
                stations: $appState.stations,
                fuelType: $fuel.type,
                moveToUserLocation: $moveToUserLocation,
                openCheapest: $openCheapest
            )
            .edgesIgnoringSafeArea(.all)
                
            MapButtons(moveToUserLocation: $moveToUserLocation, openCheapest: $openCheapest)
            
            ProgressBar()
            
            LaunchScreen()
            
        }
        .sheet(isPresented: $appState.showStationSheet) {
            StationDetail()
                .presentationDetents([.height(200), .height(201)])
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.enabled)
        }
        .onReceive(locationState.$myLocation) { location in
            if !movedToLoadedLocation {
                moveToUserLocation = true
            }
            if location != nil {
                movedToLoadedLocation = true
            }
        }
    }
}

#Preview {
    ContentView()
}
