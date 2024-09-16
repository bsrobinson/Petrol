//
//  LaunchScreen.swift
//  Petrol
//
//  Created by Ben Robinson on 16/09/2024.
//

import SwiftUI

struct LaunchScreen: View {
    
    @ObservedObject private var appState = AppState.shared
    
    var body: some View {
        
        VStack {
            HStack { }
            .frame(height: 50)
            
            HStack {
                Image("default-sign")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
            }
            .frame(width: 128, height: 128)
            .background(Color(red: 0, green: 0.47451, blue: 0.75686))
            .edgesIgnoringSafeArea(.all)
            
            HStack {
                ProgressView()
            }
            .frame(height: 60)
        }
        .opacity(appState.loading ? 1 : 0)
        .animation(.default, value: appState.loading)
    }
}

#Preview {
    LaunchScreen()
}
