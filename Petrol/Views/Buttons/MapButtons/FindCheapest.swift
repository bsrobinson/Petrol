//
//  FindCheapest.swift
//  Petrol
//
//  Created by Ben Robinson on 13/09/2024.
//

import SwiftUI

struct FindCheapest: View {
    
    @ObservedObject private var appState = AppState.shared
    @Binding var openCheapest: Bool
    
    @State var loading = true
    
    func updateLoading() {
        loading = appState.feeds.loading
        if loading {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                updateLoading()
            }
        }
    }
    
    var body: some View {
        
        Button {
            openCheapest = true
        } label: {
            Image(systemName: "sterlingsign.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 22)
            Text("Open cheapest on map")
                .fixedSize()
        }
        .padding(8)
        .foregroundColor(.secondary)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        
        .animation(.default, value: loading)
        .opacity(loading ? 0 : 1)
        .onAppear() {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                updateLoading()
            }
        }
        
    }
}

#Preview {
    FindCheapest(openCheapest: .constant(false))
}
