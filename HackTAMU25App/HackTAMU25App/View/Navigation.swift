//
//  Navigation.swift
//  HackTAMU25App
//
//  Created by tk on 1/25/25.
//

import SwiftUI

struct Navigation: View {
    @Binding var selectedTab: TabType
    
    var body: some View {
        HStack {
            Spacer()
            HStack(spacing: 64) {
                Button() {
                    selectedTab = .home
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
                   .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                   .shadow(radius: 1.5)
                }
                
                Button() {
                    selectedTab = .library
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
            Spacer()
        }
        .padding(.top)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    Navigation(selectedTab: .constant(.home))
}
