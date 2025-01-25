//
//  Navigation.swift
//  HackTAMU25App
//
//  Created by tk on 1/25/25.
//

import SwiftUI

struct Navigation: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack(spacing: 64) {
            Button() {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedTab = .home
                }
            } label: {
                VStack {
                    Image(systemName: selectedTab == .home ? "house.fill" : "house")
                        .font(.title)
                    Text("Home")
                        .font(.subheadline)
                }
            }
            .tint(.primary)
            
            Button(action: {
               // Action here
            }) {
               HStack {
                   Image(systemName: "plus")
                       .font(.system(size: 26, weight: .bold))
                       .foregroundStyle(.white)
               }
               .frame(width: 50, height: 50)
               .background(Color(.systemBlue))
               .cornerRadius(15)
               .shadow(radius: 1.5)
            }
            
            Button() {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedTab = .library
                }
            } label: {
                VStack {
                    Image(systemName: selectedTab == .library ? "play.square.stack.fill" : "play.square.stack")
                        .font(.title)
                    Text("Library")
                        .font(.subheadline)
                }
            }
            .tint(.primary)
        }
    }
}

#Preview {
    Navigation(selectedTab: .constant(.home))
}
