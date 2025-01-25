//
//  Header.swift
//  HackTAMU25App
//
//  Created by tk on 1/25/25.
//

import SwiftUI

struct Header: View {
    let tab: Tab
    @State var showProfile: Bool = false
    
    init(_ tab: Tab) {
        self.tab = tab
    }
    
    var body: some View {
        HStack {
            Text(tab.rawValue)
                .foregroundStyle(.primary)
            
            Spacer()
            
            Button {
                showProfile.toggle()
            } label: {
                Image(systemName: "person.crop.circle.fill")
            }
        }
        .font(.largeTitle.bold())
    }
}

#Preview {
    Header(.home)
}
