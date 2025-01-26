//
//  ContentView.swift
//  HackTAMU25App
//
//  Created by tk on 1/25/25.
//

import SwiftUI

enum TabType: String {
    case home = "Home"
    case library = "Library"
}

struct ContentView: View {
    @State private var selectedTab: TabType = .home
   
   var body: some View {
       NavigationStack {
           Header(selectedTab)
           
           ZStack(alignment: .bottom) {
               TabView {
                   HomeView()
                       .tabItem {
                           Label("Home", systemImage: "house")
                       }
                       
                   Color.clear
                        .tabItem {
                            Text("•••")
                        }
                   
                   LibraryView()
                       .tabItem {
                           Label("Library", systemImage: "play.square.stack")
                       }
               }
               
               Button(action: {
                   // Add your action here
               }) {
                   Image(systemName: "plus.circle.fill")
                       .font(.system(size: 44))
                       .foregroundColor(.blue)
               }
           }
       }
       .padding()
   }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
}
