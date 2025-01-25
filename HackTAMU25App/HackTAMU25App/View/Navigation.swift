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
        HStack {
            
        }
    }
}

#Preview {
    Navigation(selectedTab: .constant(.home))
}
