//
//  ProgressBar.swift
//  Petrol
//
//  Created by Ben Robinson on 12/09/2024.
//

import SwiftUI

struct ProgressBar: View {
    
    @ObservedObject private var appState = AppState.shared
    
    @State var onScreen = false
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
                
        VStack {
            
            Spacer()
            
            VStack {
                VStack {
                    Text("Loading price data")
                        .font(.footnote)
                    ProgressView(value: appState.feeds.progress)
                }
                .padding(.horizontal, 20)
                .padding(.vertical)
            }
            .frame(width: 180)
            .background {
                Color(.systemBackground)
                    .opacity(0.9)
            }
//            .background(Color(uiColor: UIColor(white: 1, alpha: 0.9)))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: .secondary, radius:40, x: 0.0, y: 0.0)
            
            Spacer()
                .frame(height: 50)
        }
        .animation(.bouncy(extraBounce: 0.2), value: [onScreen, loading])
        .offset(x: 0, y: onScreen && loading ? 0 : 200)
        .onAppear() {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                onScreen = true
                updateLoading()
            }
        }
    }
}

#Preview {
    ProgressBar()
}
