//
//  ContentView.swift
//  HackTAMU25App
//
//  Created by tk on 1/25/25.
//

import SwiftUI

enum TabType: String {
    case home = "Home"
    case library = "My Songs"
}

struct ContentView: View {
    @State private var selectedTab: TabType = .home
    @State private var showSongForm: Bool = false
   
    var body: some View {
        NavigationStack {
            VStack {
                Header(selectedTab)
                
                ZStack(alignment: .bottom) {
                    TabView(selection: $selectedTab) {
                        HomeView()
                            .tag(TabType.home)
                            .tabItem {
                                Label("Home", systemImage: "house")
                            }
                            .background(Color.gray.opacity(0.05))
                        
                        Color.gray.opacity(0.05)
                            .tag(nil as TabType?)
                            .tabItem {
                                Text("")
                            }
                        
                        LibraryView()
                            .tag(TabType.library)
                            .tabItem {
                                Label("My Songs", systemImage: "play.square.stack")
                            }
                            .background(Color.gray.opacity(0.05))
                    }
                    
                    Button(action: {
                        showSongForm.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 44))
                            .foregroundColor(.blue)
                    }
                }
            }
            .background(Color.gray.opacity(0.05))
            .sheet(isPresented: $showSongForm) {
                SongFormView()
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))

    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
}
