//
//  LocationButton.swift
//  Petrol
//
//  Created by Ben Robinson on 12/09/2024.
//

import SwiftUI
import MapKit

struct LocationButton: View {
    
    @ObservedObject private var locationState = LocationState.shared
    @Binding var moveToUserLocation: Bool
    
    var body: some View {
        
        Button {
            moveToUserLocation = true
        } label: {
            Image(systemName: locationState.myLocation == nil ? "location.slash" : "location.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 22)
        }
        .disabled(locationState.myLocation == nil)
        .padding(8)
        .foregroundColor(.secondary)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

#Preview {
    LocationButton(moveToUserLocation: .constant(false))
}
