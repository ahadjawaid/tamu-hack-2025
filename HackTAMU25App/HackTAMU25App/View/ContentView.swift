//
//  ContentView.swift
//  HackTAMU25App
//
//  Created by tk on 1/25/25.
//

import SwiftUI

enum Tab: String {
    case home = "Home"
    case library = "Library"
}

struct ContentView: View {
    @State private var selectedTab: Tab = .home
   
   var body: some View {
       NavigationStack {
           Header(selectedTab)
           
           ScrollView {
               
           }
           
           
       }
       .padding()
   }
}

#Preview {
    ContentView()
}
