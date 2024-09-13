//
//  MapButtons.swift
//  Petrol
//
//  Created by Ben Robinson on 12/09/2024.
//

import SwiftUI
import MapKit

struct MapButtons: View {
    
    @Binding var moveToUserLocation: Bool
    @Binding var openCheapest: Bool
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Spacer()
                
                FuelSelector()
                
                LocationButton(moveToUserLocation: $moveToUserLocation)
                
            }
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .shadow(color: .secondary, radius:40, x: 0.0, y: 0.0)
            .padding()
            
            Spacer()
            
            HStack {
                Spacer()
                
                FindCheapest(openCheapest: $openCheapest)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .shadow(color: .secondary, radius:40, x: 0.0, y: 0.0)
                    .padding()
            }
        }
    }
}

#Preview {
    MapButtons(moveToUserLocation: .constant(false), openCheapest: .constant(false))
}
