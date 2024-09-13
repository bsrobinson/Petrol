//
//  FuelSelector.swift
//  Petrol
//
//  Created by Ben Robinson on 11/09/2024.
//

import SwiftUI

struct FuelSelector: View {
    
    @ObservedObject private var appState = AppState.shared
    @ObservedObject private var fuel = Defaults.fuel
    
    var body: some View {
        
        Menu {
            let fuelTypes = Set(appState.stations.flatMap { Array($0.prices.keys) })
            ForEach(Array(fuelTypes.sorted()), id: \.self) { type in
                Button {
                    fuel.type = type
                } label: {
                    Label(type.fuelTypeLabel(), systemImage: fuel.type == type ? "checkmark" : "")
                }
            }
        } label: {
            HStack {
                Image("default-sign")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 22)
                Text(fuel.type.fuelTypeLabel(withCode: false))
                    .fixedSize()
            }
        }
        .padding(8)
        .foregroundColor(.secondary)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

#Preview {
    FuelSelector()
}
